import Foundation
import SwiftUI

class QuickNotesManager: ObservableObject {
    @Published var notes: [String]
    @Published var lastEdited: [Date]

    private let notesKey = "QuickNotes"
    private let timestampsKey = "QuickNotesTimestamps"

    init() {
        self.notes = UserDefaults.standard.stringArray(forKey: notesKey) ?? Array(repeating: "", count: 3)
        self.lastEdited = (UserDefaults.standard.array(forKey: timestampsKey) as? [Date]) ?? Array(repeating: Date(), count: 3)
    }

    func updateNote(at index: Int, with text: String) {
        guard index < notes.count else { return }
        notes[index] = text
        lastEdited[index] = Date()
        save()
    }

    private func save() {
        UserDefaults.standard.set(notes, forKey: notesKey)
        UserDefaults.standard.set(lastEdited, forKey: timestampsKey)
    }
}
