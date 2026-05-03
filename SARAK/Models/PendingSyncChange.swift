// PendingSyncChange.swift — SARAK
import Foundation
import SwiftData

enum SyncEntityType: String, Codable {
    case book
    case readingSession
    case dailyGoal
}

enum SyncOperation: String, Codable {
    case create
    case update
    case delete
}

enum SyncStatus: String, Codable {
    case pending
    case uploading
    case failed
    case synced
}

@Model
final class PendingSyncChange {
    @Attribute(.unique) var id: UUID
    var entityTypeRawValue: String
    var entityID: UUID
    var operationRawValue: String
    var payload: String
    var statusRawValue: String
    var retryCount: Int
    var lastError: String?
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        entityType: SyncEntityType,
        entityID: UUID,
        operation: SyncOperation,
        payload: String,
        status: SyncStatus = .pending,
        retryCount: Int = 0,
        lastError: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.entityTypeRawValue = entityType.rawValue
        self.entityID = entityID
        self.operationRawValue = operation.rawValue
        self.payload = payload
        self.statusRawValue = status.rawValue
        self.retryCount = retryCount
        self.lastError = lastError
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
