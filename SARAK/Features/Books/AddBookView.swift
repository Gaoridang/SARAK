// AddBookView.swift — SARAK
import SwiftUI

struct AddBookView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var author = ""
    let onSave: (String, String) async -> Void

    var body: some View {
        NavigationStack {
            Form {
                TextField(StringConstants.Book.titlePlaceholder, text: $title)
                TextField(StringConstants.Book.authorPlaceholder, text: $author)
            }
            .navigationTitle(StringConstants.Book.addTitle)
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
