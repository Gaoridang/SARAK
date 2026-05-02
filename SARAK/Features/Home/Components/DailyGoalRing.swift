// DailyGoalRing.swift — SARAK
import SwiftUI

struct DailyGoalRing: View {
    let todayReadMinutes: Int
    let todayGoalMinutes: Int

    private var progress: Double {
        guard todayGoalMinutes > 0 else { return 0 }
        return min(Double(todayReadMinutes) / Double(todayGoalMinutes), 1.0)
    }

    var body: some View {
        if todayGoalMinutes == 0 {
            emptyState
        } else {
            ringView
        }
    }

    private var ringView: some View {
        ZStack {
            Circle()
                .stroke(UIConstants.Colors.hairlineSoft, lineWidth: 12)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    UIConstants.Colors.primary,
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: progress)
            VStack(spacing: UIConstants.Spacing.xxs) {
                Text(
                    String(
                        format: StringConstants.Home.goalProgressFormat,
                        todayReadMinutes,
                        todayGoalMinutes
                    )
                )
                .font(UIConstants.Typography.bodyStrong)
                .foregroundStyle(UIConstants.Colors.ink)
                Text(StringConstants.Home.dailyGoalLabel)
                    .font(UIConstants.Typography.captionUppercase)
                    .foregroundStyle(UIConstants.Colors.muted)
            }
        }
        .frame(width: 120, height: 120)
    }

    private var emptyState: some View {
        VStack(spacing: UIConstants.Spacing.sm) {
            Text(StringConstants.Home.noGoalSet)
                .font(UIConstants.Typography.bodySM)
                .foregroundStyle(UIConstants.Colors.muted)
                .multilineTextAlignment(.center)
            Button(StringConstants.Home.setGoal) {}
                .font(UIConstants.Typography.button)
                .foregroundStyle(UIConstants.Colors.ink)
                .padding(.vertical, UIConstants.Spacing.sm)
                .padding(.horizontal, UIConstants.Spacing.md)
                .frame(height: 44)
                .background(.clear)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(UIConstants.Colors.hairlineStrong, lineWidth: 1))
        }
        .frame(width: 120, height: 120)
    }
}
