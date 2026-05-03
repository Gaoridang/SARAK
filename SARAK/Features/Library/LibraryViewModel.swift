// LibraryViewModel.swift — SARAK
import Foundation
import Combine

@MainActor
final class LibraryViewModel: ObservableObject {
    @Published private(set) var books: [Book] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let bookRepository: any BookRepositoryProtocol
    private let syncTrigger: (any SyncTriggerProtocol)?

    init(bookRepository: any BookRepositoryProtocol, syncTrigger: (any SyncTriggerProtocol)? = nil) {
        self.bookRepository = bookRepository
        self.syncTrigger = syncTrigger
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            books = try await bookRepository.fetchBooks()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func addBook(title: String, author: String, totalPages: Int? = nil, genre: String? = nil) async {
        isLoading = true
        errorMessage = nil
        do {
            let book = try await bookRepository.addBook(title: title, author: author)
            if totalPages != nil || genre != nil {
                book.totalPages = totalPages
                book.genre = genre.flatMap { $0.isEmpty ? nil : $0 }
                try await bookRepository.updateBook(book)
            }
            books = try await bookRepository.fetchBooks()
            triggerSync()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func makeDetailViewModel(for book: Book) -> BookDetailViewModel {
        BookDetailViewModel(book: book, bookRepository: bookRepository, syncTrigger: syncTrigger)
    }

    private func triggerSync() {
        guard let syncTrigger else { return }
        Task { await syncTrigger.syncPendingChanges() }
    }
}
