// ReadingSession.swift — SARAK
import Foundation
import SwiftData

@Model
final class ReadingSession {
    @Attribute(.unique) var id: UUID
    var bookID: UUID
    var startedAt: Date
    var endedAt: Date?
    var durationMinutes: Int
    var createdAt: Date
    var updatedAt: Date
    var lastSyncedAt: Date?
    var deletedAt: Date?

    var isActive: Bool { endedAt == nil }

    init(
        id: UUID = UUID(),
        bookID: UUID,
        startedAt: Date = Date(),
        endedAt: Date? = nil,
        durationMinutes: Int = 0,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        lastSyncedAt: Date? = nil,
        deletedAt: Date? = nil
    ) {
        self.id = id
        self.bookID = bookID
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.durationMinutes = durationMinutes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.lastSyncedAt = lastSyncedAt
        self.deletedAt = deletedAt
    }
}
