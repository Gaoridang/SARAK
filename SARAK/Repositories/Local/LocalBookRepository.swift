// LocalBookRepository.swift — SARAK
import Foundation
import SwiftData

@MainActor
final class LocalBookRepository: BookRepositoryProtocol {
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
        var descriptor = FetchDescriptor<Book>(predicate: #Predicate { $0.id == id })
        descriptor.fetchLimit = 1
        guard let book = try modelContext.fetch(descriptor).first else {
            throw LocalRepositoryError.notFound
        }
        return book
    }

    private func queueChange(for book: Book, operation: SyncOperation) throws {
        let payload = BookSyncPayload(
            id: book.id,
            title: book.title,
            author: book.author,
            status: book.status.rawValue,
            progress: book.progress,
            createdAt: book.createdAt,
            updatedAt: book.updatedAt,
            deletedAt: book.deletedAt
        )
        let payloadData = try encoder.encode(payload)
        guard let payloadString = String(data: payloadData, encoding: .utf8) else {
            throw LocalRepositoryError.encodingFailed
        }
        modelContext.insert(
            PendingSyncChange(entityType: .book, entityID: book.id, operation: operation, payload: payloadString)
        )
    }
}
