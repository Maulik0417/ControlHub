import SwiftUI

struct QuickNotesView: View {
    @StateObject private var manager = QuickNotesManager()
    @State private var selectedFontSize: CGFloat = 13
    @State private var isBold = false
    @State private var isItalic = false
    @FocusState private var focusedNote: Int?

    var body: some View {
        VStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { index in
                VStack(alignment: .leading, spacing: 2) {
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: Binding(
                            get: { manager.notes[index] },
                            set: { manager.updateNote(at: index, with: $0) }
                        ))
                        .focused($focusedNote, equals: index)
                        .frame(height: 60)
                        .font(styleFont())
                        .foregroundColor(.primary)
                        .background(Color(NSColor.textBackgroundColor))
                        .cornerRadius(6)
                        .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray.opacity(0.2)))

                        if manager.notes[index].isEmpty {
                            Text("Write something...")
                                .foregroundColor(.gray)
                                .padding(6)
                        }
                    }

                    Text("Last edited: \(manager.lastEdited[index], formatter: dateFormatter)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }

            Spacer(minLength: 6)

            Divider()

            HStack(spacing: 12) {
                HStack(spacing: 4) {
                    Text("Font Size:")
                        .font(.caption)
                    Stepper("", value: $selectedFontSize, in: 10...20)
                        .labelsHidden()
                }

                toggleButton(systemName: "bold", isOn: $isBold)
                toggleButton(systemName: "italic", isOn: $isItalic)
            }
            .padding(.vertical, 4)

            Text("📝 Max 3 notes · Autosaved")
                .font(.caption2)
                .foregroundColor(.secondary)

            Color.clear
                .frame(height: 1)
                .contentShape(Rectangle())
                .onTapGesture {
                    focusedNote = nil // Clears focus and selection properly
                }
        }
        .padding(12)
        .frame(width: 290)
    }

    private func styleFont() -> Font {
        var font = Font.system(size: selectedFontSize, weight: isBold ? .bold : .regular)
        return isItalic ? font.italic() : font
    }

    private func toggleButton(systemName: String, isOn: Binding<Bool>) -> some View {
        Button(action: {
            isOn.wrappedValue.toggle()
        }) {
            Image(systemName: systemName)
                .foregroundColor(isOn.wrappedValue ? .accentColor : .gray)
                .frame(width: 24, height: 24)
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(4)
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .short
        return f
    }
}
