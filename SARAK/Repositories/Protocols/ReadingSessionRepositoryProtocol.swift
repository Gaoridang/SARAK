// ReadingSessionRepositoryProtocol.swift — SARAK
import Foundation

@MainActor
protocol ReadingSessionRepositoryProtocol {
    func fetchSessions() async throws -> [ReadingSession]
    func fetchActiveSession() async throws -> ReadingSession?
    func startSession(bookID: UUID) async throws -> ReadingSession
    func stopSession(id: UUID) async throws -> ReadingSession
}

@MainActor
protocol SessionSyncMergeRepositoryProtocol {
    func mergeRemoteSessions(
        _ sessions: [ReadingSession],
        preservingPendingIDs pendingIDs: Set<UUID>
    ) async throws
}
