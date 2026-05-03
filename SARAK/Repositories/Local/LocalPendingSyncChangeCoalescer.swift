// LocalPendingSyncChangeCoalescer.swift — SARAK
import Foundation
import SwiftData

@MainActor
enum LocalPendingSyncChangeCoalescer {
    static func enqueue(
        entityType: SyncEntityType,
        entityID: UUID,
        operation: SyncOperation,
        payload: String,
        in modelContext: ModelContext
    ) throws {
        let existingChanges = try queuedChanges(entityType: entityType, entityID: entityID, in: modelContext)
        guard let firstChange = existingChanges.first else {
            modelContext.insert(
                PendingSyncChange(entityType: entityType, entityID: entityID, operation: operation, payload: payload)
            )
            return
        }

        firstChange.operationRawValue = coalescedOperation(existing: firstChange, next: operation).rawValue
        firstChange.payload = payload
        firstChange.statusRawValue = SyncStatus.pending.rawValue
        firstChange.retryCount = 0
        firstChange.lastError = nil
        firstChange.updatedAt = Date()
        existingChanges.dropFirst().forEach { modelContext.delete($0) }
    }

    private static func queuedChanges(
        entityType: SyncEntityType,
        entityID: UUID,
        in modelContext: ModelContext
    ) throws -> [PendingSyncChange] {
        let entityTypeRawValue = entityType.rawValue
        let pendingStatus = SyncStatus.pending.rawValue
        let failedStatus = SyncStatus.failed.rawValue
        let descriptor = FetchDescriptor<PendingSyncChange>(
            predicate: #Predicate {
                $0.entityTypeRawValue == entityTypeRawValue &&
                    $0.entityID == entityID &&
                    ($0.statusRawValue == pendingStatus || $0.statusRawValue == failedStatus)
            },
            sortBy: [SortDescriptor(\.createdAt)]
        )
        return try modelContext.fetch(descriptor)
    }

    private static func coalescedOperation(existing: PendingSyncChange, next: SyncOperation) -> SyncOperation {
        if next == .delete {
            return .delete
        }
        if existing.operationRawValue == SyncOperation.create.rawValue {
            return .create
        }
        return next
    }
}
