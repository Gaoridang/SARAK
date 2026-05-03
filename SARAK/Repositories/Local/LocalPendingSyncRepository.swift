// LocalPendingSyncRepository.swift — SARAK
import Foundation
import SwiftData

@MainActor
final class LocalPendingSyncRepository: PendingSyncRepositoryProtocol {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func pendingChanges() async throws -> [PendingSyncChange] {
        let pendingStatus = SyncStatus.pending.rawValue
        let failedStatus = SyncStatus.failed.rawValue
        let descriptor = FetchDescriptor<PendingSyncChange>(
            predicate: #Predicate {
                $0.statusRawValue == pendingStatus || $0.statusRawValue == failedStatus
            },
            sortBy: [SortDescriptor(\.createdAt)]
        )
        return try modelContext.fetch(descriptor)
    }

    func markUploading(id: UUID) async throws {
        let change = try fetchChange(id: id)
        change.statusRawValue = SyncStatus.uploading.rawValue
        change.updatedAt = Date()
        try modelContext.save()
    }

    func markSynced(id: UUID) async throws {
        let change = try fetchChange(id: id)
        change.statusRawValue = SyncStatus.synced.rawValue
        change.updatedAt = Date()
        try modelContext.save()
    }

    func markFailed(id: UUID, errorMessage: String) async throws {
        let change = try fetchChange(id: id)
        change.statusRawValue = SyncStatus.failed.rawValue
        change.retryCount += 1
        change.lastError = errorMessage
        change.updatedAt = Date()
        try modelContext.save()
    }

    private func fetchChange(id: UUID) throws -> PendingSyncChange {
        var descriptor = FetchDescriptor<PendingSyncChange>(predicate: #Predicate { $0.id == id })
        descriptor.fetchLimit = 1
        guard let change = try modelContext.fetch(descriptor).first else {
            throw LocalRepositoryError.notFound
        }
        return change
    }
}
