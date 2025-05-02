import Foundation
import AppKit

enum ClipboardItem: Hashable {
    case text(String)
    case file(URL)

    var displayName: String {
        switch self {
        case .text(let string):
            return string
        case .file(let url):
            return url.lastPathComponent
        }
    }

    func toDict() -> [String: Any] {
        switch self {
        case .text(let string):
            return ["type": "text", "value": string]
        case .file(let url):
            if let bookmark = try? url.bookmarkData(options: [.withSecurityScope],
                                                    includingResourceValuesForKeys: nil,
                                                    relativeTo: nil) {
                return ["type": "file", "bookmark": bookmark.base64EncodedString()]
            } else {
                return [:]
            }
        }
    }

    static func fromDict(_ dict: [String: Any]) -> ClipboardItem? {
        guard let type = dict["type"] as? String else { return nil }

        switch type {
        case "text":
            if let string = dict["value"] as? String {
                return .text(string)
            }

        case "file":
            if let base64 = dict["bookmark"] as? String,
               let data = Data(base64Encoded: base64) {
                var isStale = false
                if let url = try? URL(resolvingBookmarkData: data,
                                      options: [.withSecurityScope],
                                      bookmarkDataIsStale: &isStale),
                   !isStale {
                    _ = url.startAccessingSecurityScopedResource()
                    return .file(url)
                }
            }

        default:
            return nil
        }

        return nil
    }
}

class ClipboardManager: ObservableObject {
    @Published var history: [ClipboardItem] = []

    private let pasteboard = NSPasteboard.general
    private var lastItem: ClipboardItem?
    private var suppressNextUpdate = false

    private let historyFileURL: URL = {
        let appSupportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let dir = appSupportDir.appendingPathComponent("ControlHub", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("clipboard_history.json")
    }()

    init() {
        loadHistory()

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.checkClipboard()
        }
    }

    func checkClipboard() {
        guard !suppressNextUpdate else {
            suppressNextUpdate = false
            return
        }

        if let types = pasteboard.types {
            if types.contains(.fileURL),
               let items = pasteboard.pasteboardItems {
                for item in items {
                    if let filePath = item.string(forType: .fileURL),
                       let url = URL(string: filePath),
                       url.isFileURL {
                        let newItem = ClipboardItem.file(url)
                        if newItem != lastItem {
                            lastItem = newItem
                            DispatchQueue.main.async {
                                self.insertOrMoveToTop(newItem)
                            }
                        }
                    }
                }
            } else if let copiedString = pasteboard.string(forType: .string) {
                let newItem = ClipboardItem.text(copiedString)
                if newItem != lastItem {
                    lastItem = newItem
                    DispatchQueue.main.async {
                        self.insertOrMoveToTop(newItem)
                    }
                }
            }
        }
    }

    func copyToClipboard(_ item: ClipboardItem) {
        suppressNextUpdate = true
        pasteboard.clearContents()

        switch item {
        case .text(let string):
            pasteboard.setString(string, forType: .string)

        case .file(let url):
            guard FileManager.default.fileExists(atPath: url.path) else {
                print("❌ File no longer exists at path: \(url.path)")
                return
            }

            let success = pasteboard.writeObjects([url as NSURL])
            if !success {
                print("❌ Failed to write file URL to pasteboard")
            } else {
                print("✅ File URL copied to pasteboard: \(url)")
            }
        }

        insertOrMoveToTop(item)
    }

    func clearClipboard() {
        history.removeAll()
        saveHistory()
    }

    private func insertOrMoveToTop(_ item: ClipboardItem) {
        if let existingIndex = history.firstIndex(of: item) {
            history.remove(at: existingIndex)
        }
        history.insert(item, at: 0)
        limitHistory()
        saveHistory()
    }

    private func limitHistory() {
        if history.count > 20 {
            history.removeLast()
        }
    }

    private func saveHistory() {
        let dictArray = history.map { $0.toDict() }
        if let data = try? JSONSerialization.data(withJSONObject: dictArray) {
            try? data.write(to: historyFileURL)
        }
    }

    private func loadHistory() {
        guard let data = try? Data(contentsOf: historyFileURL),
              let rawArray = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            return
        }

        history = rawArray.compactMap { ClipboardItem.fromDict($0) }
    }
}
