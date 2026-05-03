// StatsViewModelTests.swift — SARAK
import Testing
@testable import SARAK

@Suite("StatsViewModel")
@MainActor
struct StatsViewModelTests {

    @Test("load calculates summary from local repositories")
    func loadCalculatesSummary() async throws {
        let context = try TestModelContainerFactory.makeContext()
        let books = LocalBookRepository(modelContext: context)
        let sessions = LocalReadingSessionRepository(modelContext: context)
        let book = try await books.addBook(title: "Dune", author: "Frank Herbert")
        let active = try await sessions.startSession(bookID: book.id)
        _ = try await sessions.stopSession(id: active.id)
        let viewModel = StatsViewModel(bookRepository: books, sessionRepository: sessions)

        await viewModel.load()

        #expect(viewModel.summary.totalMinutes >= 1)
        #expect(viewModel.summary.sessionCount == 1)
    }
}
