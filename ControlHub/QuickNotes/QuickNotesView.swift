import SwiftUI

struct QuickNotesView_Previews: PreviewProvider {
    static var previews: some View {
        QuickNotesView()
    }
}

struct QuickNotesView: View {
    @StateObject private var manager = QuickNotesManager()
    @State private var selectedFontSize: CGFloat = 13
    @State private var isBold = false
    @State private var isItalic = false
    @FocusState private var focusedNote: Int?
    @State private var selectedNoteIndex: Int = 0

    var body: some View {
        VStack(spacing: 10) {
            // Tab Switcher
            HStack(spacing: 6) {
                ForEach(0..<3, id: \.self) { index in
                    Button(action: {
                        selectedNoteIndex = index
                        focusedNote = index
                    }) {
                        Text("Note \(index + 1)")
                            .font(.caption)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(
                                selectedNoteIndex == index
                                ? Color.accentColor.opacity(0.15)
                                : Color.gray.opacity(0.5)
                            )
                            .foregroundColor(.primary)
                            .cornerRadius(6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(selectedNoteIndex == index ? Color.accentColor : Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                Spacer()
            }

            // Editor
            VStack(alignment: .leading, spacing: 6) {
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(NSColor.textBackgroundColor))
                        .shadow(color: Color.black.opacity(0.04), radius: 1, x: 0, y: 1)

                    TextEditor(text: Binding(
                        get: { manager.notes[selectedNoteIndex] },
                        set: { manager.updateNote(at: selectedNoteIndex, with: $0) }
                    ))
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
                    .padding(8)
                    .focused($focusedNote, equals: selectedNoteIndex)
                    .background(Color.clear)

                    if manager.notes[selectedNoteIndex].isEmpty {
                        Text("Write something...")
                            .foregroundColor(.gray)
                            .padding(.top, 10)
                            .padding(.leading, 14)
                    }
                }
                .frame(height: 250)

                Text("Last edited: \(manager.lastEdited[selectedNoteIndex], formatter: dateFormatter)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }

            Spacer(minLength: 6)

            Divider()

            // Footer
            Text("Max 3 notes · Autosaved")
                .font(.caption2)
                .foregroundColor(.secondary)

            Color.clear
                .frame(height: 1)
                .contentShape(Rectangle())
                .onTapGesture {
                    focusedNote = nil
                }
        }
        .padding(12)
        .frame(width: 300)
    }


    private func toggleButton(systemName: String, isOn: Binding<Bool>) -> some View {
        Button(action: {
            isOn.wrappedValue.toggle()
        }) {
            Image(systemName: systemName)
                .foregroundColor(isOn.wrappedValue ? .accentColor : .gray)
                .frame(width: 24, height: 24)
                .background(Color(NSColor.controlBackgroundColor))
                .cornerRadius(6)
                .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: 1)
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
