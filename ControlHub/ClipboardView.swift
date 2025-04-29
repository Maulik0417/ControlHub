import SwiftUI

struct ClipboardView: View {
    @StateObject var manager = ClipboardManager()

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("📋 Clipboard History")
                .font(.title2)
                .bold()

            if manager.history.isEmpty {
                Spacer()
                Text("No clipboard history yet.")
                    .foregroundColor(.gray)
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(manager.history, id: \.self) { item in
                            Button(action: {
                                manager.copyToClipboard(item)
                            }) {
                                HStack {
                                    Image(systemName: iconName(for: item))
                                        .foregroundColor(.blue)
                                    Text(item.displayName)
                                        .lineLimit(2)
                                        .truncationMode(.tail)
                                    Spacer()
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(NSColor.controlBackgroundColor))
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }

                Button("Clear History") {
                    manager.clearClipboard()
                }
                .padding(.top)
            }
        }
        .padding()
        .frame(width: 300, height: 400)
    }

    func iconName(for item: ClipboardItem) -> String {
        switch item {
        case .text:
            return "doc.on.clipboard"
        case .file(let url):
            return url.hasDirectoryPath ? "folder.fill" : "doc.fill"
        }
    }
}
