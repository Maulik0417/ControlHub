import SwiftUI

struct CalendarView: View {
    @StateObject private var manager = CalendarManager()

    private let columns = Array(repeating: GridItem(.flexible()), count: 7)

    var body: some View {
        VStack(spacing: 16) {
            Text("\(monthTitle(for: manager.selectedDate))")
                .font(.title2)
                .bold()

            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \ .self) { day in
                    Text(day)
                        .font(.caption)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                }

                if let metadata = manager.monthMetadata(for: manager.selectedDate) {
                    ForEach(metadata.days, id: \.self) { date in
                        Text("\(Calendar.current.component(.day, from: date))")
                            .frame(maxWidth: .infinity, minHeight: 30)
                            .background(manager.isSameDay(date, manager.selectedDate) ? Color.accentColor.opacity(0.3) : Color.clear)
                            .clipShape(Circle())
                            .onTapGesture {
                                manager.selectedDate = date
                            }
                    }
                }
            }

            Text("Selected: \(manager.formattedDate(manager.selectedDate))")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(width: 300)
    }

    private func monthTitle(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLLL yyyy"
        return formatter.string(from: date)
    }
}