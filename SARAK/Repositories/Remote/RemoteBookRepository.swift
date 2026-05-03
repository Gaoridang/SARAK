// RemoteBookRepository.swift — SARAK
import Foundation
import Supabase

final class RemoteBookRepository: BookRepositoryProtocol {
    func fetchBooks() async throws -> [Book] {
        let userID = try await currentUserID()
        let rows: [BookRemoteDTO] = try await SupabaseService.client
            .from(APIConstants.Supabase.booksTable)
            .select()
            .eq("user_id", value: userID.uuidString)
            .execute()
            .value
        return rows.map { $0.toDomain() }
    }

    func addBook(title: String, author: String) async throws -> Book {
        let userID = try await currentUserID()
        let now = Date()
        let book = Book(title: title, author: author, createdAt: now, updatedAt: now)
        let dto = BookRemoteDTO(
            id: book.id,
            userID: userID,
            title: book.title,
            author: book.author,
            status: book.status.rawValue,
            progress: book.progress,
            totalPages: nil,
            currentPage: nil,
            genre: nil,
            notes: nil,
            createdAt: book.createdAt,
            updatedAt: book.updatedAt,
            deletedAt: book.deletedAt
        )
        try await SupabaseService.client
            .from(APIConstants.Supabase.booksTable)
            .upsert(dto)
            .execute()
        return book
    }

    func updateBook(_ book: Book) async throws {
        let userID = try await currentUserID()
        let dto = BookRemoteDTO(
            id: book.id,
            userID: userID,
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
        try await SupabaseService.client
            .from(APIConstants.Supabase.booksTable)
            .upsert(dto)
            .execute()
    }

    func deleteBook(id: UUID) async throws {
        let userID = try await currentUserID()
        try await SupabaseService.client
            .from(APIConstants.Supabase.booksTable)
            .delete()
            .eq("id", value: id.uuidString)
            .eq("user_id", value: userID.uuidString)
            .execute()
    }

    private func currentUserID() async throws -> UUID {
        do {
            return try await SupabaseService.client.auth.session.user.id
        } catch {
            throw RemoteRepositoryError.signedOut
        }
    }
}
