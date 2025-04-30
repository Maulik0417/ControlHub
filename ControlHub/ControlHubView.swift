import SwiftUI

enum Tool {
    case home
    case clipboard
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

            Spacer()
        }
    }

    private var clipboardView: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    selectedTool = .home
                }) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 12, height: 12) // Keep icon small
                        .padding(10) // Enlarge tappable area
                        .background(Color.clear)
                        .contentShape(Rectangle()) // Ensures the padding area is clickable
                }
                .buttonStyle(PlainButtonStyle())

                Spacer()

                Text("📋 Clipboard Manager")
                    .font(.headline)

                Spacer()

                // Balancer for layout symmetry
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 32, height: 32)
            }
            .padding(.horizontal)
            .padding(.top, 20) // Increased top padding
            .padding(.bottom, 8)

            Divider()

            ClipboardView()
                .padding(.top, 6)
        }
    }
}
