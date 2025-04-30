import Foundation

enum ClipboardContentType: String, Codable {
    case text
    case fileURL
}

struct ClipboardItem: Identifiable, Codable, Hashable {
    var id = UUID()
    var content: String
    var type: ClipboardContentType
}
