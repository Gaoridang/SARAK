// LocalBookRepository.swift — SARAK
import Foundation
import SwiftData

@MainActor
final class LocalBookRepository: BookRepositoryProtocol, BookSyncMergeRepositoryProtocol {
    private let modelContext: ModelContext
    private let encoder = JSONEncoder()

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchBooks() async throws -> [Book] {
        let descriptor = FetchDescriptor<Book>(
            predicate: #Predicate { $0.deletedAt == nil },
            sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }

    func addBook(title: String, author: String) async throws -> Book {
        let cleanTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanAuthor = author.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanTitle.isEmpty, !cleanAuthor.isEmpty else { throw LocalRepositoryError.invalidInput }
        let book = Book(title: cleanTitle, author: cleanAuthor)
        modelContext.insert(book)
        try queueChange(for: book, operation: .create)
        try modelContext.save()
        return book
    }

    func updateBook(_ book: Book) async throws {
        book.updatedAt = Date()
        try queueChange(for: book, operation: .update)
        try modelContext.save()
    }

    func deleteBook(id: UUID) async throws {
        let book = try fetchBook(id: id)
        book.deletedAt = Date()
        book.updatedAt = Date()
        try queueChange(for: book, operation: .delete)
        try modelContext.save()
    }

    private func fetchBook(id: UUID) throws -> Book {
        guard let book = try fetchBookIfExists(id: id) else {
            throw LocalRepositoryError.notFound
        }
        return book
    }

    func mergeRemoteBooks(_ books: [Book], preservingPendingIDs pendingIDs: Set<UUID>) async throws {
        let syncedAt = Date()
        for remoteBook in books where !pendingIDs.contains(remoteBook.id) {
            if let localBook = try fetchBookIfExists(id: remoteBook.id) {
                apply(remoteBook, to: localBook, syncedAt: syncedAt)
            } else {
                remoteBook.lastSyncedAt = syncedAt
                modelContext.insert(remoteBook)
            }
        }
        try modelContext.save()
    }

    private func fetchBookIfExists(id: UUID) throws -> Book? {
        var descriptor = FetchDescriptor<Book>(predicate: #Predicate { $0.id == id })
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }

    private func apply(_ remoteBook: Book, to localBook: Book, syncedAt: Date) {
        localBook.title = remoteBook.title
        localBook.author = remoteBook.author
        localBook.status = remoteBook.status
        localBook.progress = remoteBook.progress
        localBook.totalPages = remoteBook.totalPages
        localBook.currentPage = remoteBook.currentPage
        localBook.genre = remoteBook.genre
        localBook.notes = remoteBook.notes
        localBook.createdAt = remoteBook.createdAt
        localBook.updatedAt = remoteBook.updatedAt
        localBook.deletedAt = remoteBook.deletedAt
        localBook.lastSyncedAt = syncedAt
    }

    private func queueChange(for book: Book, operation: SyncOperation) throws {
        let payload = BookSyncPayload(
            id: book.id,
            title: book.title,
            author: book.author,
            status: book.status.rawValue,
            progress: book.progress,
            totalPages: book.totalPages,
            currentPage: book.currentPage,
            genre: book.genre,
            notes: book.notes,
            createdAt: book.createdAt,
            updatedAt: book.updatedAt,
            deletedAt: book.deletedAt
        )
        let payloadData = try encoder.encode(payload)
        guard let payloadString = String(data: payloadData, encoding: .utf8) else {
            throw LocalRepositoryError.encodingFailed
        }
        try LocalPendingSyncChangeCoalescer.enqueue(
            entityType: .book,
            entityID: book.id,
            operation: operation,
            payload: payloadString,
            in: modelContext
        )
    }
}
