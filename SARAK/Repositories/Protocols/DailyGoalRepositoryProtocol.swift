// DailyGoalRepositoryProtocol.swift — SARAK
import Foundation

@MainActor
protocol DailyGoalRepositoryProtocol {
    func goal(for date: Date) async throws -> DailyGoal?
    func setGoal(minutes: Int, for date: Date) async throws -> DailyGoal
}
