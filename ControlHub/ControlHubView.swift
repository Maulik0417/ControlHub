import SwiftUI

enum Tool {
    case home
    case clipboard
    case systemStats
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
            }
        }
        .frame(width: 300, height: 400)
        .padding()
    }

    private var homeView: some View {
        VStack(spacing: 20) {
            Text("🛠️ ControlHub Tools")
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

            Spacer()
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
