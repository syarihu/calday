English | [日本語](README.ja.md)

# calday

A CLI tool that fetches today's calendar events from macOS Calendar app and outputs them as JSON.

## Requirements

- macOS 14.0+
- Xcode Command Line Tools

## Install

```bash
swift build -c release
cp .build/release/calday /usr/local/bin/
```

On first run, a dialog will appear requesting access to Calendar.

## Usage

```bash
calday
```

## Configuration

You can specify calendars to exclude in `~/.config/calday/config.json`.

```json
{
  "excludedCalendars": [
    "Calendar name to exclude"
  ]
}
```

## Tips: Claude Code integration

You can configure Claude Code to automatically use `calday` when creating daily reports or when schedule information is needed. Add the following to your `CLAUDE.md` (global or project-level):

```markdown
## Calendar integration

When creating daily reports or when today's meeting/schedule information is needed, run the `calday` command to fetch today's calendar events automatically. This eliminates the need to ask the user about their schedule.

- Command: `calday`
- Output: JSON array of today's events with `title`, `start`, `end`, `calendar`, `allDay`, `location` fields
- Use the output to populate the schedule section of daily reports
```

With this configuration, Claude Code will automatically run `calday` to fetch your calendar events when generating daily reports, without needing to ask you about your schedule.

## License

MIT
