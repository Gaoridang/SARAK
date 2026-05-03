// AddBookView.swift — SARAK
import SwiftUI

struct AddBookView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var author = ""
    @State private var totalPagesText = ""
    @State private var genre = ""
    let onSave: (String, String, Int?, String?) async -> Void

    private var totalPages: Int? { Int(totalPagesText).flatMap { $0 > 0 ? $0 : nil } }
    private var isSaveDisabled: Bool { title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

    var body: some View {
        NavigationStack {
            Form {
                Section(StringConstants.BookDetail.titleLabel) {
                    TextField(StringConstants.Book.titlePlaceholder, text: $title)
                }
                Section(StringConstants.BookDetail.authorLabel) {
                    TextField(StringConstants.Book.authorPlaceholder, text: $author)
                }
                Section(StringConstants.BookDetail.totalPagesLabel) {
                    TextField(StringConstants.Book.totalPagesPlaceholder, text: $totalPagesText)
                        .keyboardType(.numberPad)
                }
                Section(StringConstants.BookDetail.genreLabel) {
                    TextField(StringConstants.Book.genrePlaceholder, text: $genre)
                }
            }
            .navigationTitle(StringConstants.Book.addTitle)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(StringConstants.Common.cancel) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(StringConstants.Common.save) {
                        Task {
                            await onSave(title, author, totalPages, genre.isEmpty ? nil : genre)
                            dismiss()
                        }
                    }
                    .disabled(isSaveDisabled)
                }
            }
        }
    }
}
