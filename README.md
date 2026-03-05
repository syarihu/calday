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

## License

MIT
