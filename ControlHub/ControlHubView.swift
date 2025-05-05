import SwiftUI

enum Tool {
    case home
    case clipboard
    case systemStats
    case quickNotes
    case calendar
}

struct ControlHubView: View {
    @State private var selectedTool: Tool = .home

    var body: some View {
        Group {
            switch selectedTool {
            case .home:
                homeView
            case .clipboard:
                clipboardView
            case .systemStats:
                systemStatsView
            case .quickNotes:
                quickNotesView
            case .calendar:
                calendarView
            }
        }
        .frame(width: 300, height: 400)
        .padding()
    }

    private var homeView: some View {
        VStack(spacing: 20) {
            Text("ControlHub")
                .font(.title2)
                .bold()

            Button(action: {
                selectedTool = .clipboard
            }) {
                HStack {
                    Image(systemName: "doc.on.clipboard")
                    Text("Clipboard Manager")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.accentColor.opacity(0.1))
                .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())

            Button(action: {
                selectedTool = .systemStats
            }) {
                HStack {
                    Image(systemName: "gauge")
                    Text("System Statistics")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.accentColor.opacity(0.1))
                .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())

            Button(action: {
                selectedTool = .quickNotes
            }) {
                HStack {
                    Image(systemName: "note.text")
                    Text("Quick Notes")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.accentColor.opacity(0.1))
                .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())

            Button(action: {
                selectedTool = .calendar
            }) {
                HStack {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.accentColor.opacity(0.1))
                .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())

            Spacer()

            Button(action: {
                NSApplication.shared.terminate(nil)
            }) {
                HStack {
                    Image(systemName: "xmark.circle")
                    Text("Quit App")
                }
                .foregroundColor(.black)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red.opacity(0.2))
                .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }

    private var clipboardView: some View {
        VStack(spacing: 0) {
            toolHeader(title: "📋 Clipboard Manager") {
                selectedTool = .home
            }

            Divider()
            ClipboardView()
                .padding(.top, 6)
        }
    }

    private var systemStatsView: some View {
        VStack(spacing: 0) {
            toolHeader(title: "📊 System Statistics") {
                selectedTool = .home
            }

            Divider()
            SystemStatisticsView()
                .padding(.top, 6)
        }
    }

    private var quickNotesView: some View {
        VStack(spacing: 0) {
            toolHeader(title: "📝 Quick Notes") {
                selectedTool = .home
            }

            Divider()
            QuickNotesView()
                .padding(.top, 6)
        }
    }

    private var calendarView: some View {
        VStack(spacing: 0) {
            toolHeader(title: "📅 Quick Calendar") {
                selectedTool = .home
            }

            Divider()
            CalendarView()
                .padding(.top, 6)
        }
    }

    private func toolHeader(title: String, backAction: @escaping () -> Void) -> some View {
        HStack {
            Button(action: backAction) {
                Image(systemName: "chevron.left")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .padding(10)
                    .background(Color.clear)
                    .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())

            Spacer()

            Text(title)
                .font(.headline)

            Spacer()

            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 32, height: 32)
        }
        .padding(.horizontal)
        .padding(.top, 20)
        .padding(.bottom, 8)
    }
}
