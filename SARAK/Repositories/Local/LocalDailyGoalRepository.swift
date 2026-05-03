// LocalDailyGoalRepository.swift — SARAK
import Foundation
import SwiftData

@MainActor
final class LocalDailyGoalRepository: DailyGoalRepositoryProtocol, DailyGoalSyncMergeRepositoryProtocol {
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

    func mergeRemoteGoals(_ goals: [DailyGoal], preservingPendingIDs pendingIDs: Set<UUID>) async throws {
        let syncedAt = Date()
        for remoteGoal in goals {
            let localGoal = try fetchGoal(id: remoteGoal.id) ?? fetchGoal(for: remoteGoal.goalDate)
            if let localGoal {
                guard !pendingIDs.contains(localGoal.id) else { continue }
                apply(remoteGoal, to: localGoal, syncedAt: syncedAt)
            } else if !pendingIDs.contains(remoteGoal.id) {
                remoteGoal.lastSyncedAt = syncedAt
                modelContext.insert(remoteGoal)
            }
        }
        try modelContext.save()
    }

    private func fetchGoal(id: UUID) throws -> DailyGoal? {
        var descriptor = FetchDescriptor<DailyGoal>(predicate: #Predicate { $0.id == id })
        descriptor.fetchLimit = 1
        return try modelContext.fetch(descriptor).first
    }

    private func apply(_ remoteGoal: DailyGoal, to localGoal: DailyGoal, syncedAt: Date) {
        localGoal.goalDate = Calendar.current.startOfDay(for: remoteGoal.goalDate)
        localGoal.targetMinutes = remoteGoal.targetMinutes
        localGoal.createdAt = remoteGoal.createdAt
        localGoal.updatedAt = remoteGoal.updatedAt
        localGoal.lastSyncedAt = syncedAt
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
