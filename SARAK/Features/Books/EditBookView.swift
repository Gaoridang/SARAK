// EditBookView.swift — SARAK
import SwiftUI

struct EditBookView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title: String
    @State private var author: String
    let onSave: (String, String) async -> Void

    init(currentTitle: String, currentAuthor: String, onSave: @escaping (String, String) async -> Void) {
        _title = State(initialValue: currentTitle)
        _author = State(initialValue: currentAuthor)
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(StringConstants.BookDetail.titleLabel) {
                    TextField(StringConstants.Book.titlePlaceholder, text: $title)
                }
                Section(StringConstants.BookDetail.authorLabel) {
                    TextField(StringConstants.Book.authorPlaceholder, text: $author)
                }
            }
            .navigationTitle(StringConstants.BookDetail.editTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(StringConstants.Common.cancel) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(StringConstants.Common.save) {
                        Task {
                            await onSave(title, author)
                            dismiss()
                        }
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
