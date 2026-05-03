// RemoteReadingSessionRepository.swift — SARAK
import Foundation
import Supabase

final class RemoteReadingSessionRepository: ReadingSessionRepositoryProtocol {
    func fetchSessions() async throws -> [ReadingSession] {
        let userID = try await currentUserID()
        let rows: [ReadingSessionRemoteDTO] = try await SupabaseService.client
            .from(APIConstants.Supabase.sessionsTable)
            .select()
            .eq("user_id", value: userID.uuidString)
            .execute()
            .value
        return rows.map { $0.toDomain() }
    }

    func fetchActiveSession() async throws -> ReadingSession? {
        try await fetchSessions().first { $0.endedAt == nil && $0.deletedAt == nil }
    }

    func startSession(bookID: UUID) async throws -> ReadingSession {
        let userID = try await currentUserID()
        let session = ReadingSession(bookID: bookID)
        try await upsert(session, userID: userID)
        return session
    }

    func stopSession(id: UUID) async throws -> ReadingSession {
        guard let session = try await fetchSessions().first(where: { $0.id == id }) else {
            throw LocalRepositoryError.notFound
        }
        let now = Date()
        session.endedAt = now
        session.durationMinutes = max(Int(now.timeIntervalSince(session.startedAt) / 60), 1)
        session.updatedAt = now
        try await upsert(session, userID: try await currentUserID())
        return session
    }

    private func upsert(_ session: ReadingSession, userID: UUID) async throws {
        let dto = ReadingSessionRemoteDTO(
            id: session.id,
            userID: userID,
            bookID: session.bookID,
            startedAt: session.startedAt,
            endedAt: session.endedAt,
            durationMinutes: session.durationMinutes,
            createdAt: session.createdAt,
            updatedAt: session.updatedAt,
            deletedAt: session.deletedAt
        )
        try await SupabaseService.client
            .from(APIConstants.Supabase.sessionsTable)
            .upsert(dto)
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
