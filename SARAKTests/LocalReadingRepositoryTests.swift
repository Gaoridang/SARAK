// LocalReadingRepositoryTests.swift — SARAK
import Foundation
import Testing
@testable import SARAK

@Suite("Local reading repositories")
@MainActor
struct LocalReadingRepositoryTests {

    @Test("addBook persists book and queues pending sync")
    func addBookQueuesPendingSync() async throws {
        let context = try TestModelContainerFactory.makeContext()
        let books = LocalBookRepository(modelContext: context)
        let pending = LocalPendingSyncRepository(modelContext: context)

        let book = try await books.addBook(title: "Dune", author: "Frank Herbert")

        #expect(try await books.fetchBooks().first?.id == book.id)
        #expect(try await pending.pendingChanges().count == 1)
    }

    @Test("setGoal creates and updates today's goal")
    func setGoalUpdatesExistingGoal() async throws {
        let context = try TestModelContainerFactory.makeContext()
        let goals = LocalDailyGoalRepository(modelContext: context)

        _ = try await goals.setGoal(minutes: 20, for: Date())
        let updated = try await goals.setGoal(minutes: 40, for: Date())

        #expect(updated.targetMinutes == 40)
        #expect(try await goals.goal(for: Date())?.targetMinutes == 40)
    }

    @Test("start and stop session records duration")
    func startStopSessionRecordsDuration() async throws {
        let context = try TestModelContainerFactory.makeContext()
        let books = LocalBookRepository(modelContext: context)
        let sessions = LocalReadingSessionRepository(modelContext: context)
        let book = try await books.addBook(title: "Dune", author: "Frank Herbert")

        let active = try await sessions.startSession(bookID: book.id)
        let stopped = try await sessions.stopSession(id: active.id)

        #expect(stopped.endedAt != nil)
        #expect(stopped.durationMinutes >= 1)
        #expect(try await sessions.fetchActiveSession() == nil)
    }
}
