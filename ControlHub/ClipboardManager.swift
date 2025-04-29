import AppKit

class ClipboardManager: ObservableObject {
    @Published var history: [String] = []
    private var timer: Timer?
    private var lastChangeCount: Int = NSPasteboard.general.changeCount

    init() {
        startMonitoring()
    }

    func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.checkClipboard()
        }
    }

    private func checkClipboard() {
        let pasteboard = NSPasteboard.general
        if pasteboard.changeCount != lastChangeCount {
            lastChangeCount = pasteboard.changeCount
            
            guard let copiedString = pasteboard.string(forType: .string),
                  !copiedString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                  copiedString != history.first else { return }
            
            DispatchQueue.main.async {
                self.history.removeAll { $0 == copiedString } // ✅ remove duplicates
                self.history.insert(copiedString, at: 0)
                if self.history.count > 10 {
                    self.history.removeLast()
                }
            }
        }
    }

    func copyToClipboard(_ string: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(string, forType: .string)
    }
    
    func clearClipboard() {
        history.removeAll()
    }
    
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

    deinit {
        timer?.invalidate()
    }
}

