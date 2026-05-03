// PendingSyncRepositoryProtocol.swift — SARAK
import Foundation

@MainActor
protocol PendingSyncRepositoryProtocol {
    func pendingChanges() async throws -> [PendingSyncChange]
    func pendingEntityIDs(for entityType: SyncEntityType) async throws -> Set<UUID>
    func markUploading(id: UUID) async throws
    func markSynced(id: UUID) async throws
    func markFailed(id: UUID, errorMessage: String) async throws
}
