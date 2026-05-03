// EditBookView.swift — SARAK
import SwiftUI

struct EditBookView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title: String
    @State private var author: String
    @State private var totalPagesText: String
    @State private var genre: String
    @State private var notes: String
    let onSave: (String, String, Int?, String?, String?) async -> Void

    init(
        currentTitle: String,
        currentAuthor: String,
        currentTotalPages: Int?,
        currentGenre: String?,
        currentNotes: String?,
        onSave: @escaping (String, String, Int?, String?, String?) async -> Void
    ) {
        _title = State(initialValue: currentTitle)
        _author = State(initialValue: currentAuthor)
        _totalPagesText = State(initialValue: currentTotalPages.map(String.init) ?? "")
        _genre = State(initialValue: currentGenre ?? "")
        _notes = State(initialValue: currentNotes ?? "")
        self.onSave = onSave
    }

    private var totalPages: Int? { Int(totalPagesText).flatMap { $0 > 0 ? $0 : nil } }

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
                Section(StringConstants.BookDetail.notesLabel) {
                    TextEditor(text: $notes)
                        .frame(minHeight: 80)
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
                            await onSave(
                                title, author, totalPages,
                                genre.isEmpty ? nil : genre,
                                notes.isEmpty ? nil : notes
                            )
                            dismiss()
                        }
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
