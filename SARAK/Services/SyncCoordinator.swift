// SyncCoordinator.swift — SARAK
// ⚠️ RESTRICTED — do not modify without explicit user approval.
// Only class allowed to touch both local and remote layers simultaneously.
// See .harness/sync.md for strategy.
import Foundation
import Supabase

@MainActor
final class SyncCoordinator: SyncTriggerProtocol {
    private let pendingRepository: any PendingSyncRepositoryProtocol
    private let decoder = JSONDecoder()

    init(pendingRepository: any PendingSyncRepositoryProtocol) {
        self.pendingRepository = pendingRepository
    }

    func syncPendingChanges() async {
        do {
            let changes = try await pendingRepository.pendingChanges()
            for change in changes {
                await upload(change)
            }
        } catch {
            // Pending-sync fetch failures are local persistence failures; the next trigger retries.
        }
    }

    private func upload(_ change: PendingSyncChange) async {
        do {
            try await pendingRepository.markUploading(id: change.id)
            let userID = try await currentUserID()
            try await upload(change, userID: userID)
            try await pendingRepository.markSynced(id: change.id)
        } catch {
            do {
                try await pendingRepository.markFailed(id: change.id, errorMessage: error.localizedDescription)
            } catch {
                // If marking failure itself fails, the durable pending row remains for the next trigger.
            }
        }
    }

    private func upload(_ change: PendingSyncChange, userID: UUID) async throws {
        guard let entityType = SyncEntityType(rawValue: change.entityTypeRawValue),
              let operation = SyncOperation(rawValue: change.operationRawValue),
              let payloadData = change.payload.data(using: .utf8) else {
            throw LocalRepositoryError.encodingFailed
        }

        switch (entityType, operation) {
        case (.book, .create), (.book, .update):
            let payload = try decoder.decode(BookSyncPayload.self, from: payloadData)
            try await upsertBook(payload, userID: userID)
        case (.book, .delete):
            let payload = try decoder.decode(BookSyncPayload.self, from: payloadData)
            try await deleteRow(table: APIConstants.Supabase.booksTable, id: payload.id, userID: userID)
        case (.readingSession, .create), (.readingSession, .update):
            let payload = try decoder.decode(ReadingSessionSyncPayload.self, from: payloadData)
            try await upsertSession(payload, userID: userID)
        case (.readingSession, .delete):
            let payload = try decoder.decode(ReadingSessionSyncPayload.self, from: payloadData)
            try await deleteRow(table: APIConstants.Supabase.sessionsTable, id: payload.id, userID: userID)
        case (.dailyGoal, .create), (.dailyGoal, .update):
            let payload = try decoder.decode(DailyGoalSyncPayload.self, from: payloadData)
            try await upsertGoal(payload, userID: userID)
        case (.dailyGoal, .delete):
            throw LocalRepositoryError.invalidInput
        }
    }

    private func upsertBook(_ payload: BookSyncPayload, userID: UUID) async throws {
        let dto = BookRemoteDTO(
            id: payload.id,
            userID: userID,
            title: payload.title,
            author: payload.author,
            status: payload.status,
            progress: payload.progress,
            createdAt: payload.createdAt,
            updatedAt: payload.updatedAt,
            deletedAt: payload.deletedAt
        )
        try await SupabaseService.client
            .from(APIConstants.Supabase.booksTable)
            .upsert(dto)
            .execute()
    }

    private func upsertSession(_ payload: ReadingSessionSyncPayload, userID: UUID) async throws {
        let dto = ReadingSessionRemoteDTO(
            id: payload.id,
            userID: userID,
            bookID: payload.bookID,
            startedAt: payload.startedAt,
            endedAt: payload.endedAt,
            durationMinutes: payload.durationMinutes,
            createdAt: payload.createdAt,
            updatedAt: payload.updatedAt,
            deletedAt: payload.deletedAt
        )
        try await SupabaseService.client
            .from(APIConstants.Supabase.sessionsTable)
            .upsert(dto)
            .execute()
    }

    private func upsertGoal(_ payload: DailyGoalSyncPayload, userID: UUID) async throws {
        let dto = DailyGoalRemoteDTO(
            id: payload.id,
            userID: userID,
            goalDate: payload.goalDate,
            targetMinutes: payload.targetMinutes,
            createdAt: payload.createdAt,
            updatedAt: payload.updatedAt
        )
        try await SupabaseService.client
            .from(APIConstants.Supabase.goalsTable)
            .upsert(dto, onConflict: "user_id,goal_date")
            .execute()
    }

    private func deleteRow(table: String, id: UUID, userID: UUID) async throws {
        try await SupabaseService.client
            .from(table)
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
