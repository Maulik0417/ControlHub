import SwiftUI

struct ClipboardView: View {
    @StateObject private var manager = ClipboardManager()

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("📋 Clipboard History")
                    .font(.headline)

                Spacer()

                Button(action: {
                    manager.clearClipboard()
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                        .padding(6)
                        .background(Color.red.opacity(0.1))
                        .clipShape(Circle())
                }
                .buttonStyle(PlainButtonStyle())
                .help("Clear All")
            }

            if manager.history.isEmpty {
                VStack {
                    Spacer()
                    Text("No clipboard history yet.")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(manager.history, id: \.self) { item in
                            Button(action: {
                                manager.copyToClipboard(item)
                            }) {
                                Text(item)
                                    .lineLimit(2)
                                    .truncationMode(.tail)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color(NSColor.controlBackgroundColor))
                                    .cornerRadius(10)
                                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.trailing, 4) // Ensure space for scrollbar
                }
            }
        }
        .padding()
        .frame(width: 300, height: 360)
    }
}
