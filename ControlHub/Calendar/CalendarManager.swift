import Foundation
import SwiftUI

class CalendarManager: ObservableObject {
    @Published var currentDate = Date()
    @Published var selectedDate = Date()
    @Published var notes: [String: String] = [:] {
        didSet {
            saveNotes()
        }
    }

    init() {
        loadNotes()
    }

    func moveMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: currentDate) {
            currentDate = newDate
        }
    }

    func formattedMonthYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentDate)
    }

    func note(for date: Date) -> String {
        let key = dateKey(from: date)
        return notes[key] ?? ""
    }

    func updateNote(for date: Date, text: String) {
        let key = dateKey(from: date)
        notes[key] = text
    }

     func dateKey(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private func saveNotes() {
        UserDefaults.standard.set(notes, forKey: "calendarNotes")
    }

    private func loadNotes() {
        if let saved = UserDefaults.standard.dictionary(forKey: "calendarNotes") as? [String: String] {
            notes = saved
        }
    }

    func hasNote(for date: Date) -> Bool {
        return notes[dateKey(from: date)] != nil && !notes[dateKey(from: date)]!.isEmpty
    }
}
