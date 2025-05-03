import SwiftUI

struct QuickNotesView: View {
    @StateObject private var manager = QuickNotesManager()
    @State private var fontSize: CGFloat = 14

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                ForEach(0..<3, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 4) {
                        AttributedTextEditor(text: $manager.notes[index], fontSize: $fontSize) { updatedText in
                            manager.updateNote(at: index, with: updatedText)
                        }
                        .frame(height: 60)
                        .cornerRadius(8)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))

                        Text("Last edited: \(formattedDate(manager.lastEdited[index]))")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }

                Divider()

                HStack(spacing: 12) {
                    Text("Font Size")
                        .font(.caption)

                    Button(action: { fontSize = max(10, fontSize - 1) }) {
                        Image(systemName: "minus.circle")
                    }
                    Button(action: { fontSize = min(30, fontSize + 1) }) {
                        Image(systemName: "plus.circle")
                    }

                    Spacer()

                    Button(action: {
                        NotificationCenter.default.post(name: .formatAction, object: FormatAction.bold)
                    }) {
                        Image(systemName: "bold")
                    }

                    Button(action: {
                        NotificationCenter.default.post(name: .formatAction, object: FormatAction.italic)
                    }) {
                        Image(systemName: "italic")
                    }
                }
                .font(.caption)
                .padding(.top, 4)

                Text("Max 3 notes. Autosaved.")
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(.top, 4)
            }
            .padding()
            .frame(width: 300)
        }
        .onAppear {
            UITextView.appearance().tintColor = .systemBlue
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
