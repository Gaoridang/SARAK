// DailyGoalRing.swift — SARAK
import SwiftUI

struct DailyGoalRing: View {
    let todayReadMinutes: Int
    let todayGoalMinutes: Int
    let onSetGoal: () -> Void

    private var progress: Double {
        guard todayGoalMinutes > 0 else { return 0 }
        return min(Double(todayReadMinutes) / Double(todayGoalMinutes), 1.0)
    }

    var body: some View {
        if todayGoalMinutes == 0 {
            emptyState
        } else {
            goalCard
        }
    }

    private var goalCard: some View {
        HStack(spacing: UIConstants.Spacing.md) {
            VStack(alignment: .leading, spacing: UIConstants.Spacing.xxs) {
                Text(StringConstants.Home.dailyGoalLabel)
                    .font(UIConstants.Typography.titleSM)
                    .foregroundStyle(UIConstants.Colors.ink)
                Text(
                    String(
                        format: StringConstants.Home.goalProgressFormat,
                        todayReadMinutes,
                        todayGoalMinutes
                    )
                )
                .font(UIConstants.Typography.caption)
                .foregroundStyle(UIConstants.Colors.muted)
            }

            Spacer()

            ringView
        }
        .padding(.horizontal, UIConstants.Spacing.smx)
        .padding(.vertical, UIConstants.Spacing.md)
        .background(UIConstants.Colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: UIConstants.CornerRadius.xl, style: .continuous))
    }

    private var ringView: some View {
        ZStack {
            Circle()
                .stroke(UIConstants.Colors.divider, lineWidth: 3)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    UIConstants.Colors.primary,
                    style: StrokeStyle(lineWidth: 3, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: progress)
            Text("\(Int(progress * 100))%")
                .font(UIConstants.Typography.captionUppercase)
                .foregroundStyle(UIConstants.Colors.ink)
        }
        .frame(width: UIConstants.Size.progressRing, height: UIConstants.Size.progressRing)
    }

    private var emptyState: some View {
        EmptyStateCard(
            message: StringConstants.Home.noGoalSet,
            actionTitle: StringConstants.Home.setGoal,
            action: onSetGoal
        )
    }
}
