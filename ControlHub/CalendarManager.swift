import Foundation
import SwiftUI

class CalendarManager: ObservableObject {
    @Published var selectedDate: Date = Date()

    private let calendar = Calendar.current

    func monthMetadata(for date: Date) -> (days: [Date], firstDay: Date)? {
        guard let monthInterval = calendar.dateInterval(of: .month, for: date),
              let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: date)) else {
            return nil
        }

        let days = (0..<calendar.range(of: .day, in: .month, for: firstDay)!.count).compactMap {
            calendar.date(byAdding: .day, value: $0, to: firstDay)
        }

        return (days, firstDay)
    }

    func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        calendar.isDate(date1, inSameDayAs: date2)
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}