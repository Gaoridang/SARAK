// LocalDailyGoalRepository.swift — SARAK
import Foundation
import SwiftData

@MainActor
final class LocalDailyGoalRepository: DailyGoalRepositoryProtocol {
    private let modelContext: ModelContext
    private let encoder = JSONEncoder()

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func goal(for date: Date) async throws -> DailyGoal? {
        try fetchGoal(for: date)
    }

    func setGoal(minutes: Int, for date: Date) async throws -> DailyGoal {
        guard minutes > 0 else { throw LocalRepositoryError.invalidInput }
        let goalDate = Calendar.current.startOfDay(for: date)
        let goal = try fetchGoal(for: goalDate) ?? DailyGoal(goalDate: goalDate, targetMinutes: minutes)
        let operation: SyncOperation = goal.modelContext == nil ? .create : .update
        goal.targetMinutes = minutes
        goal.updatedAt = Date()
        if goal.modelContext == nil {
            modelContext.insert(goal)
        }
        try queueChange(for: goal, operation: operation)
        try modelContext.save()
        return goal
    }

    private func fetchGoal(for date: Date) throws -> DailyGoal? {
        let goalDate = Calendar.current.startOfDay(for: date)
        var descriptor = FetchDescriptor<DailyGoal>(predicate: #Predicate { $0.goalDate == goalDate })
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }

    private func queueChange(for goal: DailyGoal, operation: SyncOperation) throws {
        let payload = DailyGoalSyncPayload(
            id: goal.id,
            goalDate: goal.goalDate,
            targetMinutes: goal.targetMinutes,
            createdAt: goal.createdAt,
            updatedAt: goal.updatedAt
        )
        let payloadData = try encoder.encode(payload)
        guard let payloadString = String(data: payloadData, encoding: .utf8) else {
            throw LocalRepositoryError.encodingFailed
        }
        try LocalPendingSyncChangeCoalescer.enqueue(
            entityType: .dailyGoal,
            entityID: goal.id,
            operation: operation,
            payload: payloadString,
            in: modelContext
        )
    }
}
