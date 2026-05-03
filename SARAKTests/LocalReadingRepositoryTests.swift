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

    @Test("stopping an already-ended session returns existing values unchanged")
    func repeatedStopSessionDoesNotMutateEndedSession() async throws {
        let context = try TestModelContainerFactory.makeContext()
        let books = LocalBookRepository(modelContext: context)
        let sessions = LocalReadingSessionRepository(modelContext: context)
        let pending = LocalPendingSyncRepository(modelContext: context)
        let book = try await books.addBook(title: "Dune", author: "Frank Herbert")
        let active = try await sessions.startSession(bookID: book.id)
        let stopped = try await sessions.stopSession(id: active.id)
        let endedAt = stopped.endedAt
        let durationMinutes = stopped.durationMinutes

        let stoppedAgain = try await sessions.stopSession(id: active.id)

        #expect(stoppedAgain.endedAt == endedAt)
        #expect(stoppedAgain.durationMinutes == durationMinutes)
        #expect(try await pending.pendingChanges().filter { $0.entityID == active.id }.count == 1)
    }

    @Test("update replaces prior pending update payload for same entity")
    func updateCoalescesPriorPendingUpdate() async throws {
        let context = try TestModelContainerFactory.makeContext()
        let books = LocalBookRepository(modelContext: context)
        let pending = LocalPendingSyncRepository(modelContext: context)
        let book = try await books.addBook(title: "Dune", author: "Frank Herbert")
        for change in try await pending.pendingChanges() {
            try await pending.markSynced(id: change.id)
        }

        book.title = "Dune Messiah"
        try await books.updateBook(book)
        book.title = "Children of Dune"
        try await books.updateBook(book)

        let changes = try await pending.pendingChanges().filter { $0.entityID == book.id }
        #expect(changes.count == 1)
        #expect(changes.first?.operationRawValue == SyncOperation.update.rawValue)
        #expect(try decodeBookPayload(changes[0]).title == "Children of Dune")
    }

    @Test("create plus update stays one create with latest payload")
    func createThenUpdateCoalescesToCreate() async throws {
        let context = try TestModelContainerFactory.makeContext()
        let books = LocalBookRepository(modelContext: context)
        let pending = LocalPendingSyncRepository(modelContext: context)
        let book = try await books.addBook(title: "Dune", author: "Frank Herbert")

        book.title = "Dune Messiah"
        try await books.updateBook(book)

        let changes = try await pending.pendingChanges().filter { $0.entityID == book.id }
        #expect(changes.count == 1)
        #expect(changes.first?.operationRawValue == SyncOperation.create.rawValue)
        #expect(try decodeBookPayload(changes[0]).title == "Dune Messiah")
    }

    @Test("delete supersedes earlier pending changes for same entity")
    func deleteSupersedesEarlierPendingChanges() async throws {
        let context = try TestModelContainerFactory.makeContext()
        let books = LocalBookRepository(modelContext: context)
        let pending = LocalPendingSyncRepository(modelContext: context)
        let book = try await books.addBook(title: "Dune", author: "Frank Herbert")
        book.title = "Dune Messiah"
        try await books.updateBook(book)

        try await books.deleteBook(id: book.id)

        let changes = try await pending.pendingChanges().filter { $0.entityID == book.id }
        #expect(changes.count == 1)
        #expect(changes.first?.operationRawValue == SyncOperation.delete.rawValue)
        #expect(try decodeBookPayload(changes[0]).deletedAt != nil)
    }

    @Test("remote book merge inserts and updates clean local rows")
    func remoteBookMergeImportsCleanRows() async throws {
        let context = try TestModelContainerFactory.makeContext()
        let books = LocalBookRepository(modelContext: context)
        let pending = LocalPendingSyncRepository(modelContext: context)
        let local = try await books.addBook(title: "Dune", author: "Frank Herbert")
        for change in try await pending.pendingChanges() {
            try await pending.markSynced(id: change.id)
        }

        let remoteUpdated = Book(id: local.id, title: "Dune Messiah", author: "Frank Herbert")
        let remoteInserted = Book(title: "Children of Dune", author: "Frank Herbert")
        try await books.mergeRemoteBooks([remoteUpdated, remoteInserted], preservingPendingIDs: [])

        let imported = try await books.fetchBooks()
        #expect(imported.contains { $0.id == local.id && $0.title == "Dune Messiah" })
        #expect(imported.contains { $0.id == remoteInserted.id })
        #expect(imported.allSatisfy { $0.lastSyncedAt != nil })
    }

    @Test("remote book merge preserves pending local rows")
    func remoteBookMergePreservesPendingRows() async throws {
        let context = try TestModelContainerFactory.makeContext()
        let books = LocalBookRepository(modelContext: context)
        let pending = LocalPendingSyncRepository(modelContext: context)
        let local = try await books.addBook(title: "Local Title", author: "Frank Herbert")
        let pendingIDs = try await pending.pendingEntityIDs(for: .book)

        let remote = Book(id: local.id, title: "Remote Title", author: "Frank Herbert")
        try await books.mergeRemoteBooks([remote], preservingPendingIDs: pendingIDs)

        #expect(try await books.fetchBooks().first?.title == "Local Title")
    }

    @Test("remote session and goal merges import rows")
    func remoteSessionAndGoalMergesImportRows() async throws {
        let context = try TestModelContainerFactory.makeContext()
        let sessions = LocalReadingSessionRepository(modelContext: context)
        let goals = LocalDailyGoalRepository(modelContext: context)
        let session = ReadingSession(bookID: UUID(), durationMinutes: 12)
        let goal = DailyGoal(goalDate: Date(), targetMinutes: 30)

        try await sessions.mergeRemoteSessions([session], preservingPendingIDs: [])
        try await goals.mergeRemoteGoals([goal], preservingPendingIDs: [])

        #expect(try await sessions.fetchSessions().first?.id == session.id)
        #expect(try await goals.goal(for: Date())?.targetMinutes == 30)
    }

    private func decodeBookPayload(_ change: PendingSyncChange) throws -> BookSyncPayload {
        let data = try #require(change.payload.data(using: .utf8))
        return try JSONDecoder().decode(BookSyncPayload.self, from: data)
    }
}
