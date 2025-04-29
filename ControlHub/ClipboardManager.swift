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
}

class ClipboardManager: ObservableObject {
    @Published var history: [ClipboardItem] = []

    private let pasteboard = NSPasteboard.general
    private var lastItem: ClipboardItem?

    init() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.checkClipboard()
        }
    }

    func checkClipboard() {
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
                                self.history.insert(newItem, at: 0)
                                self.limitHistory()
                            }
                        }
                    }
                }
            } else if let copiedString = pasteboard.string(forType: .string) {
                let newItem = ClipboardItem.text(copiedString)
                if newItem != lastItem {
                    lastItem = newItem
                    DispatchQueue.main.async {
                        self.history.insert(newItem, at: 0)
                        self.limitHistory()
                    }
                }
            }
        }
    }

    func copyToClipboard(_ item: ClipboardItem) {
        pasteboard.clearContents()
        switch item {
        case .text(let string):
            pasteboard.setString(string, forType: .string)
        case .file(let url):
            pasteboard.writeObjects([url as NSURL])
        }
    }

    func clearClipboard() {
        history.removeAll()
    }

    private func limitHistory() {
        if history.count > 20 {
            history.removeLast()
        }
    }
}
