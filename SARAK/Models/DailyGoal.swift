// DailyGoal.swift — SARAK
import Foundation
import SwiftData

@Model
final class DailyGoal {
    @Attribute(.unique) var id: UUID
    var goalDate: Date
    var targetMinutes: Int
    var createdAt: Date
    var updatedAt: Date
    var lastSyncedAt: Date?

    init(
        id: UUID = UUID(),
        goalDate: Date,
        targetMinutes: Int,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        lastSyncedAt: Date? = nil
    ) {
        self.id = id
        self.goalDate = Calendar.current.startOfDay(for: goalDate)
        self.targetMinutes = targetMinutes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.lastSyncedAt = lastSyncedAt
    }
}
