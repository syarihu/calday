[English](README.md) | 日本語

# calday

macOSのカレンダーアプリから今日の予定を取得し、JSON形式で出力するCLIツールです。

## 必要要件

- macOS 14.0+
- Xcode Command Line Tools

## インストール

### Homebrew

```bash
brew tap syarihu/tap
brew install calday
```

### ソースからビルド

```bash
git clone https://github.com/syarihu/calday.git
cd calday
make install
```

初回実行時にカレンダーへのアクセス許可を求めるダイアログが表示されます。

## 使い方

```bash
calday
```

## 設定

`~/.config/calday/config.json` で除外するカレンダーを指定できます。

```json
{
  "excludedCalendars": [
    "除外するカレンダー名"
  ]
}
```

## Tips: Claude Codeとの連携

`CLAUDE.md`（グローバルまたはプロジェクトレベル）に以下を追加することで、日報作成時やスケジュール情報が必要な場面でClaude Codeが自動的に`calday`を実行するようになります。

```markdown
## Calendar integration

When creating daily reports or when today's meeting/schedule information is needed, run the `calday` command to fetch today's calendar events automatically. This eliminates the need to ask the user about their schedule.

- Command: `calday`
- Output: JSON array of today's events with `title`, `start`, `end`, `calendar`, `allDay`, `location` fields
- Use the output to populate the schedule section of daily reports
```

この設定により、Claude Codeが日報を生成する際にユーザーへスケジュールを確認することなく、自動的に`calday`を実行してカレンダーの予定を取得してくれます。

## ライセンス

MIT
