import EventKit
import Foundation

// Handle `calday init` subcommand
if CommandLine.arguments.count > 1 && CommandLine.arguments[1] == "init" {
    let configDir = FileManager.default.homeDirectoryForCurrentUser
        .appendingPathComponent(".config/calday")
    let configFile = configDir.appendingPathComponent("config.json")

    if FileManager.default.fileExists(atPath: configFile.path) {
        fputs("Config already exists: \(configFile.path)\n", stderr)
        exit(1)
    }

    let template = """
    {
      "excludedCalendars": []
    }
    """
    try FileManager.default.createDirectory(at: configDir, withIntermediateDirectories: true)
    try template.write(to: configFile, atomically: true, encoding: .utf8)
    print("Created \(configFile.path)")
    exit(0)
}

let store = EKEventStore()

// Request access to calendar
let granted: Bool
if #available(macOS 14.0, *) {
    granted = try await store.requestFullAccessToEvents()
} else {
    granted = try await store.requestAccess(to: .event)
}

guard granted else {
    fputs("Error: Calendar access denied. Grant access in System Settings > Privacy & Security > Calendars.\n", stderr)
    exit(1)
}

// Start and end of today
let calendar = Calendar.current
let now = Date()
let startOfDay = calendar.startOfDay(for: now)
let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

// Collect own email addresses (from calendar accounts)
let myEmails: Set<String> = Set(
    store.calendars(for: .event)
        .compactMap { $0.source?.title.lowercased() }
        .filter { $0.contains("@") }
)

// Fetch events
let predicate = store.predicateForEvents(withStart: startOfDay, end: endOfDay, calendars: nil)
let allEvents = store.events(matching: predicate)

// Load config file (~/.config/calday/config.json)
struct Config: Decodable {
    var excludedCalendars: [String] = []
}

let configURL = FileManager.default.homeDirectoryForCurrentUser
    .appendingPathComponent(".config/calday/config.json")
let config: Config = {
    guard let data = try? Data(contentsOf: configURL),
          let decoded = try? JSONDecoder().decode(Config.self, from: data) else {
        return Config()
    }
    return decoded
}()
let excludedCalendars = Set(config.excludedCalendars)

// Filter to only events the user is attending
let events = allEvents.filter { event in
    guard !excludedCalendars.contains(event.calendar.title) else { return false }
    guard let attendees = event.attendees, !attendees.isEmpty else {
        // No attendees = personal event
        return true
    }
    return attendees.contains { attendee in
        guard let email = attendee.url.absoluteString
            .replacingOccurrences(of: "mailto:", with: "")
            .lowercased() as String? else { return false }
        return attendee.isCurrentUser || myEmails.contains(email)
    }
}

// JSON output
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "HH:mm"
dateFormatter.locale = Locale(identifier: "ja_JP")

let jsonEvents = events.map { event -> [String: Any] in
    var dict: [String: Any] = [
        "title": event.title ?? "(no title)",
        "allDay": event.isAllDay,
        "calendar": event.calendar.title,
    ]
    if event.isAllDay {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "yyyy-MM-dd"
        dict["date"] = dayFormatter.string(from: event.startDate)
    } else {
        dict["start"] = dateFormatter.string(from: event.startDate)
        dict["end"] = dateFormatter.string(from: event.endDate)
    }
    if let location = event.location, !location.isEmpty {
        dict["location"] = location
    }
    return dict
}

let jsonData = try JSONSerialization.data(withJSONObject: jsonEvents, options: [.prettyPrinted, .sortedKeys])
print(String(data: jsonData, encoding: .utf8)!)
