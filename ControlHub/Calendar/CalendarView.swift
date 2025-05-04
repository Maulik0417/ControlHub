import SwiftUI

struct CalendarView: View {
    @StateObject private var manager = CalendarManager()
    private let columns = Array(repeating: GridItem(.flexible()), count: 7)

    var body: some View {
        VStack(spacing: 10) {
            // Header
            HStack {
                Button(action: { manager.moveMonth(by: -1) }) {
                    Image(systemName: "chevron.left")
                }
                .focusable(false)
                .accessibilityHidden(true)
                .buttonStyle(BorderlessButtonStyle())
                .padding(.horizontal, 8)

                Spacer()

                Text(manager.formattedMonthYear())
                    .font(.headline)

                Spacer()

                Button(action: { manager.moveMonth(by: 1) }) {
                    Image(systemName: "chevron.right")
                }
                .focusable(false)
                .accessibilityHidden(true)
                .buttonStyle(BorderlessButtonStyle())
                .padding(.horizontal, 8)
            }

            // Weekday headers
            let weekdays = Calendar.current.shortWeekdaySymbols
            HStack {
                ForEach(weekdays, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .frame(maxWidth: .infinity)
                }
            }

            // Calendar grid
            LazyVGrid(columns: columns, spacing: 10) {
                let days = generateDays()
                ForEach(days, id: \.self) { date in
                    VStack(spacing: 2) {
                        Text("\(Calendar.current.component(.day, from: date))")
                            .font(.body)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding(6)
                            .background(
                                Circle()
                                    .fill(isToday(date) ? Color.accentColor.opacity(0.3) : Color.clear)
                            )
                            .onTapGesture {
                                manager.selectedDate = date
                            }

                        if manager.hasNote(for: date) {
                            Circle()
                                .fill(Color.accentColor)
                                .frame(width: 5, height: 5)
                        }
                    }
                }
            }
            .frame(maxHeight: 240)

            // Notes Section
            VStack(alignment: .leading) {
                Text("Note for \(manager.dateKey(from: manager.selectedDate)):")
                    .font(.caption)

                TextEditor(text: Binding(
                    get: { manager.note(for: manager.selectedDate) },
                    set: { manager.updateNote(for: manager.selectedDate, text: $0) }
                ))
                .frame(height: 60)
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray.opacity(0.2)))
            }
        }
        .padding(12)
        .frame(width: 300)
    }

    private func isToday(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }

    private func generateDays() -> [Date] {
        let calendar = Calendar.current
        guard let monthInterval = calendar.dateInterval(of: .month, for: manager.currentDate),
              let firstWeekday = calendar.date(from: calendar.dateComponents([.year, .month], from: monthInterval.start)) else {
            return []
        }

        let weekdayOffset = calendar.component(.weekday, from: firstWeekday) - calendar.firstWeekday
        let startDate = calendar.date(byAdding: .day, value: -weekdayOffset, to: firstWeekday)!

        return (0..<42).compactMap { calendar.date(byAdding: .day, value: $0, to: startDate) }
    }
}
