// BookRepositoryProtocol.swift — SARAK
import Foundation

@MainActor
protocol BookRepositoryProtocol {
    func fetchBooks() async throws -> [Book]
    func addBook(title: String, author: String) async throws -> Book
    func updateBook(_ book: Book) async throws
    func deleteBook(id: UUID) async throws
}
