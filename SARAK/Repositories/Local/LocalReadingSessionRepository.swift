// LocalReadingSessionRepository.swift — SARAK
import Foundation
import SwiftData

@MainActor
final class LocalReadingSessionRepository: ReadingSessionRepositoryProtocol, SessionSyncMergeRepositoryProtocol {
    private let modelContext: ModelContext
    private let encoder = JSONEncoder()

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchSessions() async throws -> [ReadingSession] {
        let descriptor = FetchDescriptor<ReadingSession>(
            predicate: #Predicate { $0.deletedAt == nil },
            sortBy: [SortDescriptor(\.startedAt, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }

    func fetchActiveSession() async throws -> ReadingSession? {
        var descriptor = FetchDescriptor<ReadingSession>(
            predicate: #Predicate { $0.endedAt == nil && $0.deletedAt == nil }
        )
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }

    func startSession(bookID: UUID) async throws -> ReadingSession {
        if let activeSession = try await fetchActiveSession() {
            return activeSession
        }
        let session = ReadingSession(bookID: bookID)
        modelContext.insert(session)
        try queueChange(for: session, operation: .create)
        try modelContext.save()
        return session
    }

    func stopSession(id: UUID) async throws -> ReadingSession {
        let session = try fetchSession(id: id)
        if session.endedAt != nil {
            return session
        }
        let now = Date()
        session.endedAt = now
        session.durationMinutes = max(Int(now.timeIntervalSince(session.startedAt) / 60), 1)
        session.updatedAt = now
        try queueChange(for: session, operation: .update)
        try modelContext.save()
        return session
    }

    private func fetchSession(id: UUID) throws -> ReadingSession {
        guard let session = try fetchSessionIfExists(id: id) else {
            throw LocalRepositoryError.notFound
        }
        return session
    }

    func mergeRemoteSessions(
        _ sessions: [ReadingSession],
        preservingPendingIDs pendingIDs: Set<UUID>
    ) async throws {
        let syncedAt = Date()
        for remoteSession in sessions where !pendingIDs.contains(remoteSession.id) {
            if let localSession = try fetchSessionIfExists(id: remoteSession.id) {
                apply(remoteSession, to: localSession, syncedAt: syncedAt)
            } else {
                remoteSession.lastSyncedAt = syncedAt
                modelContext.insert(remoteSession)
            }
        }
        try modelContext.save()
    }

    private func fetchSessionIfExists(id: UUID) throws -> ReadingSession? {
        var descriptor = FetchDescriptor<ReadingSession>(predicate: #Predicate { $0.id == id })
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }

    private func apply(_ remoteSession: ReadingSession, to localSession: ReadingSession, syncedAt: Date) {
        localSession.bookID = remoteSession.bookID
        localSession.startedAt = remoteSession.startedAt
        localSession.endedAt = remoteSession.endedAt
        localSession.durationMinutes = remoteSession.durationMinutes
        localSession.createdAt = remoteSession.createdAt
        localSession.updatedAt = remoteSession.updatedAt
        localSession.deletedAt = remoteSession.deletedAt
        localSession.lastSyncedAt = syncedAt
    }

    private func queueChange(for session: ReadingSession, operation: SyncOperation) throws {
        let payload = ReadingSessionSyncPayload(
            id: session.id,
            bookID: session.bookID,
            startedAt: session.startedAt,
            endedAt: session.endedAt,
            durationMinutes: session.durationMinutes,
            createdAt: session.createdAt,
            updatedAt: session.updatedAt,
            deletedAt: session.deletedAt
        )
        let payloadData = try encoder.encode(payload)
        guard let payloadString = String(data: payloadData, encoding: .utf8) else {
            throw LocalRepositoryError.encodingFailed
        }
        try LocalPendingSyncChangeCoalescer.enqueue(
            entityType: .readingSession,
            entityID: session.id,
            operation: operation,
            payload: payloadString,
            in: modelContext
        )
    }
}
