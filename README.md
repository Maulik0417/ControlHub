# ControlHub

A macOS menu bar app combining productivity and monitoring tools to help you work smarter and stay in control — all from one compact interface. 🧠⚙️

## 🚀 Features
### 📋 Clipboard Manager
- View and reuse your recent clipboard history.
- Quickly copy past items with a single click.
- Automatically removes duplicates and manages capacity.
- Save plain text, files and folders

### 🧠 System Statistics
- View live system metrics including memory usage and CPU load.
- Visual indicators help track performance at a glance.
- Lightweight and efficient — no heavy monitoring overhead.

### 📝 Quick Notes
- Maintain up to 3 short notes with autosave.
- Tabbed interface to switch between notes.
- Edits tracked with timestamps.

## 🛠 Tech Stack
- Language: Swift, SwiftUI
- Platform: macOS
- Data Storage: UserDefaults (for autosave/local persistence)
- Architecture: MVVM

## 📄 Usage
### Clipboard Manager
- Automatically tracks clipboard entries as you copy text.
- Click an entry to copy it back to your clipboard.

### System Stats
- Monitors key system usage metrics.
- Helpful when debugging or testing under load.

### Quick Notes
- Select a note tab (1 to 3) to focus on a specific note.
- Notes are saved instantly — no need to hit save.

## 💡 Future Improvements
- 🧩 Add markdown support in notes
- 🌐 Sync notes and clipboard across devices via iCloud
- ⚡ System tray / menu bar access
- 🎨 Add themes for customization
- 🔐 Optionally password-lock certain notes or clip entries