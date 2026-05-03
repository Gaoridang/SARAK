// BookDetailViewModel.swift — SARAK
import Foundation
import Combine

@MainActor
final class BookDetailViewModel: ObservableObject {
    private(set) var book: Book
    @Published private(set) var isDeleted = false
    @Published var errorMessage: String?

    private let bookRepository: any BookRepositoryProtocol
    private let syncTrigger: (any SyncTriggerProtocol)?

    init(
        book: Book,
        bookRepository: any BookRepositoryProtocol,
        syncTrigger: (any SyncTriggerProtocol)? = nil
    ) {
        self.book = book
        self.bookRepository = bookRepository
        self.syncTrigger = syncTrigger
    }

    func updateStatus(_ status: BookStatus) async {
        book.status = status
        do {
            try await bookRepository.updateBook(book)
            objectWillChange.send()
            triggerSync()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func updateProgress(_ progress: Double) async {
        book.progress = min(max(progress, 0), 1)
        do {
            try await bookRepository.updateBook(book)
            objectWillChange.send()
            triggerSync()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func updateCurrentPage(_ page: Int) async {
        book.currentPage = max(0, page)
        if let total = book.totalPages, total > 0 {
            book.progress = min(Double(page) / Double(total), 1.0)
        }
        do {
            try await bookRepository.updateBook(book)
            objectWillChange.send()
            triggerSync()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func updateBookInfo(
        title: String,
        author: String,
        totalPages: Int? = nil,
        genre: String? = nil,
        notes: String? = nil
    ) async {
        book.title = title
        book.author = author
        book.totalPages = totalPages
        book.genre = genre.flatMap { $0.trimmingCharacters(in: .whitespaces).isEmpty ? nil : $0 }
        book.notes = notes.flatMap { $0.trimmingCharacters(in: .whitespaces).isEmpty ? nil : $0 }
        if let total = totalPages, total > 0, let page = book.currentPage {
            book.progress = min(Double(page) / Double(total), 1.0)
        }
        do {
            try await bookRepository.updateBook(book)
            objectWillChange.send()
            triggerSync()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func deleteBook() async {
        do {
            try await bookRepository.deleteBook(id: book.id)
            isDeleted = true
            triggerSync()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func triggerSync() {
        guard let syncTrigger else { return }
        Task { await syncTrigger.syncPendingChanges() }
    }
}
