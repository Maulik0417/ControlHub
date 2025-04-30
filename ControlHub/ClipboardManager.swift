import Foundation
import AppKit

enum ClipboardItem: Hashable, Codable {
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

    enum CodingKeys: String, CodingKey {
        case type, value
    }

    enum ItemType: String, Codable {
        case text, file
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(ItemType.self, forKey: .type)
        switch type {
        case .text:
            let string = try container.decode(String.self, forKey: .value)
            self = .text(string)
        case .file:
            let url = try container.decode(URL.self, forKey: .value)
            self = .file(url)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .text(let string):
            try container.encode(ItemType.text, forKey: .type)
            try container.encode(string, forKey: .value)
        case .file(let url):
            try container.encode(ItemType.file, forKey: .type)
            try container.encode(url, forKey: .value)
        }
    }
}

class ClipboardManager: ObservableObject {
    @Published var history: [ClipboardItem] = [] {
        didSet {
            saveHistory()
        }
    }

    private let pasteboard = NSPasteboard.general
    private var lastItem: ClipboardItem?

    private let historyFileName = "clipboard_history.json"

    private var historyFileURL: URL {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let directory = appSupport.appendingPathComponent("ControlHub", isDirectory: true)

        if !FileManager.default.fileExists(atPath: directory.path) {
            try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        }

        return directory.appendingPathComponent(historyFileName)
    }

    init() {
        loadHistory()
        if let first = history.first {
            lastItem = first
        }
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
                                self.history.removeAll { $0 == newItem }
                                self.history.insert(newItem, at: 0)
                                self.limitHistory()
                                self.saveHistory()
                            }
                        }
                    }
                }
            } else if let copiedString = pasteboard.string(forType: .string) {
                let newItem = ClipboardItem.text(copiedString)
                if newItem != lastItem {
                    lastItem = newItem
                    DispatchQueue.main.async {
                        self.history.removeAll { $0 == newItem }
                        self.history.insert(newItem, at: 0)
                        self.limitHistory()
                        self.saveHistory()
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

    // MARK: - Persistence

    private func saveHistory() {
        do {
            let data = try JSONEncoder().encode(history)
            try data.write(to: historyFileURL)
        } catch {
            print("Failed to save clipboard history: \(error)")
        }
    }

    private func loadHistory() {
        do {
            let data = try Data(contentsOf: historyFileURL)
            let loadedHistory = try JSONDecoder().decode([ClipboardItem].self, from: data)
            history = loadedHistory
        } catch {
            print("Failed to load clipboard history: \(error)")
        }
    }
}
