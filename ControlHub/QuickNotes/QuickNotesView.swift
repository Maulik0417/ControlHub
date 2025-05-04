import SwiftUI

struct QuickNotesView: View {
    @StateObject private var manager = QuickNotesManager()
    @State private var selectedFontSize: CGFloat = 13
    @State private var isBold = false
    @State private var isItalic = false
    @FocusState private var focusedNote: Int?
    @State private var selectedNoteIndex: Int = 0

    var body: some View {
        VStack(spacing: 8) {
            // Tab-style header
            HStack(spacing: 8) {
                ForEach(0..<3, id: \.self) { index in
                    Button(action: {
                        selectedNoteIndex = index
                        focusedNote = index
                    }) {
                        Text("Note \(index + 1)")
                            .font(.caption)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(selectedNoteIndex == index ? Color.accentColor.opacity(0.15) : Color.clear)
                            .cornerRadius(6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(selectedNoteIndex == index ? Color.accentColor : Color.gray.opacity(0.2), lineWidth: 1)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                Spacer()
            }

            // Display selected note
            VStack(alignment: .leading, spacing: 4) {
                ZStack(alignment: .topLeading) {
                    TextEditor(text: Binding(
                        get: { manager.notes[selectedNoteIndex] },
                        set: { manager.updateNote(at: selectedNoteIndex, with: $0) }
                    ))
                    .focused($focusedNote, equals: selectedNoteIndex)
                    .frame(height: 120)
                    .font(styleFont())
                    .foregroundColor(.primary)
                    .background(Color(NSColor.textBackgroundColor))
                    .cornerRadius(6)
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray.opacity(0.2)))

                    if manager.notes[selectedNoteIndex].isEmpty {
                        Text("Write something...")
                            .foregroundColor(.gray)
                            .padding(6)
                    }
                }

                Text("Last edited: \(manager.lastEdited[selectedNoteIndex], formatter: dateFormatter)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Spacer(minLength: 8)

            Divider()

            // Style controls
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
                    focusedNote = nil // Clear selection
                }
        }
        .padding(12)
        .frame(width: 300)
    }

    private func styleFont() -> Font {
        let font = Font.system(size: selectedFontSize, weight: isBold ? .bold : .regular)
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
