// BookDetailViewModelTests.swift — SARAK
import Foundation
import SwiftData
import Testing
@testable import SARAK

@Suite("BookDetailViewModel")
@MainActor
struct BookDetailViewModelTests {

    @Test("updateStatus changes book status and does not set errorMessage")
    func updateStatusChangesStatus() async throws {
        let (viewModel, _) = try makeViewModel(status: .queued)
        await viewModel.updateStatus(.reading)
        #expect(viewModel.book.status == .reading)
        #expect(viewModel.errorMessage == nil)
    }

    @Test("updateProgress clamps value to 0...1 and persists")
    func updateProgressClamps() async throws {
        let (viewModel, _) = try makeViewModel(status: .reading)
        await viewModel.updateProgress(1.5)
        #expect(viewModel.book.progress == 1.0)
        await viewModel.updateProgress(-0.5)
        #expect(viewModel.book.progress == 0.0)
    }

    @Test("updateBookInfo updates title and author")
    func updateBookInfoUpdates() async throws {
        let (viewModel, _) = try makeViewModel()
        await viewModel.updateBookInfo(title: "New Title", author: "New Author")
        #expect(viewModel.book.title == "New Title")
        #expect(viewModel.book.author == "New Author")
        #expect(viewModel.errorMessage == nil)
    }

    @Test("deleteBook sets isDeleted to true")
    func deleteBookSetsIsDeleted() async throws {
        let (viewModel, _) = try makeViewModel()
        await viewModel.deleteBook()
        #expect(viewModel.isDeleted == true)
        #expect(viewModel.errorMessage == nil)
    }

    @Test("updateStatus on repository failure sets errorMessage")
    func updateStatusFailureSetsErrorMessage() async throws {
        let (viewModel, repo) = try makeViewModel()
        repo.shouldFail = true
        await viewModel.updateStatus(.reading)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.isDeleted == false)
    }

    private func makeViewModel(
        status: BookStatus = .queued
    ) throws -> (BookDetailViewModel, MockBookRepository) {
        let context = try TestModelContainerFactory.makeContext()
        let book = Book(title: "Test Book", author: "Test Author", status: status)
        context.insert(book)
        let repo = MockBookRepository()
        let viewModel = BookDetailViewModel(book: book, bookRepository: repo)
        return (viewModel, repo)
    }
}

@MainActor
private final class MockBookRepository: BookRepositoryProtocol {
    var shouldFail = false

    func fetchBooks() async throws -> [Book] {
        if shouldFail { throw MockRepositoryError.intentional }
        return []
    }

    func addBook(title: String, author: String) async throws -> Book {
        throw MockRepositoryError.intentional
    }

    func updateBook(_ book: Book) async throws {
        if shouldFail { throw MockRepositoryError.intentional }
    }

    func deleteBook(id: UUID) async throws {
        if shouldFail { throw MockRepositoryError.intentional }
    }
}

private enum MockRepositoryError: LocalizedError {
    case intentional
    var errorDescription: String? { "Mock failure" }
}
