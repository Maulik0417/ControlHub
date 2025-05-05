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
                let dayViews = generateCurrentMonthDays().enumerated().map { index, date -> AnyView in
                    if let date = date {
                        return AnyView(
                            VStack(spacing: 2) {
                                Text("\(Calendar.current.component(.day, from: date))")
                                    .font(.body)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .padding(1)
                                    .background(
                                        Circle()
                                            .fill(circleColor(for: date))
                                    )
                                    .onTapGesture {
                                        manager.selectedDate = date
                                    }
                                            .contextMenu {
                                                Button("Clear Note") {
                                                    manager.updateNote(for: date, text: "")
                                                }
                                            
                                    }

                                if manager.hasNote(for: date) {
                                    Circle()
                                        .fill(Color.accentColor)
                                        .frame(width: 5, height: 5)
                                }
                            }
                        )
                    } else {
                        return AnyView(Color.clear.frame(height: 30))
                    }
                }

                ForEach(0..<dayViews.count, id: \.self) { index in
                    dayViews[index]
                }
            }
            .frame(maxHeight: 160)

            // Notes Section
            VStack(alignment: .leading) {
                Text("Note for \(manager.dateKey(from: manager.selectedDate)):")
                    .font(.caption)
            
                ZStack(alignment: .topLeading) {
                    if manager.note(for: manager.selectedDate).isEmpty {
                        Text("Write something here... Right click on the date to clear note")
                            .foregroundColor(.gray)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 8)
                            .font(.footnote)
                    }

                    TextEditor(text: Binding(
                        get: { manager.note(for: manager.selectedDate) },
                        set: { manager.updateNote(for: manager.selectedDate, text: $0) }
                    ))
                    .frame(height: 60)
                    .padding(6)
                    .opacity(manager.note(for: manager.selectedDate).isEmpty ? 0.1 : 1)
                }
                .background(Color.white)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.gray.opacity(0.2))
                )
                
                
            }
        }
        .padding(12)
        .frame(width: 300)
    }

    private func generateCurrentMonthDays() -> [Date?] {
        let calendar = Calendar.current
        guard let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: manager.currentDate)),
              let range = calendar.range(of: .day, in: .month, for: manager.currentDate) else {
            return []
        }

        var days: [Date?] = []

        // Determine what weekday the month starts on (1 = Sunday, 7 = Saturday)
        let weekday = calendar.component(.weekday, from: monthStart)

        // Add nils to pad the first row
        let paddingDays = (weekday + 6) % 7 // Convert to 0-indexed starting from Monday
        days.append(contentsOf: Array(repeating: nil, count: paddingDays))

        // Add actual dates
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: monthStart) {
                days.append(date)
            }
        }

        return days
    }

    private func circleColor(for date: Date) -> Color {
        if Calendar.current.isDateInToday(date) {
            return .green.opacity(0.4)
        } else if Calendar.current.isDate(date, inSameDayAs: manager.selectedDate) {
            return .blue.opacity(0.4)
        } else {
            return .clear
        }
    }
}


