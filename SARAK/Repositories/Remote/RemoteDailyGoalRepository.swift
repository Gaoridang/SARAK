// RemoteDailyGoalRepository.swift — SARAK
import Foundation
import Supabase

final class RemoteDailyGoalRepository: DailyGoalRepositoryProtocol {
    func goal(for date: Date) async throws -> DailyGoal? {
        let userID = try await currentUserID()
        let goalDate = Calendar.current.startOfDay(for: date)
        let rows: [DailyGoalRemoteDTO] = try await SupabaseService.client
            .from(APIConstants.Supabase.goalsTable)
            .select()
            .eq("user_id", value: userID.uuidString)
            .eq("goal_date", value: goalDate.formatted(.iso8601.year().month().day()))
            .execute()
            .value
        return rows.first?.toDomain()
    }

    func setGoal(minutes: Int, for date: Date) async throws -> DailyGoal {
        let userID = try await currentUserID()
        let goal = DailyGoal(goalDate: date, targetMinutes: minutes)
        let dto = DailyGoalRemoteDTO(
            id: goal.id,
            userID: userID,
            goalDate: goal.goalDate,
            targetMinutes: goal.targetMinutes,
            createdAt: goal.createdAt,
            updatedAt: goal.updatedAt
        )
        try await SupabaseService.client
            .from(APIConstants.Supabase.goalsTable)
            .upsert(dto, onConflict: "user_id,goal_date")
            .execute()
        return goal
    }

    private func currentUserID() async throws -> UUID {
        do {
            return try await SupabaseService.client.auth.session.user.id
        } catch {
            throw RemoteRepositoryError.signedOut
        }
    }
}
