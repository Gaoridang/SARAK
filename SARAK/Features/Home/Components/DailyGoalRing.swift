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
                .stroke(Color.secondary.opacity(0.2), lineWidth: 12)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.accentColor,
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: progress)
            VStack(spacing: 2) {
                Text(
                    String(
                        format: StringConstants.Home.goalProgressFormat,
                        todayReadMinutes,
                        todayGoalMinutes
                    )
                )
                .font(.system(.callout, design: .rounded))
                .fontWeight(.semibold)
                Text(StringConstants.Home.dailyGoalLabel)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 120, height: 120)
    }

    private var emptyState: some View {
        VStack(spacing: UIConstants.Spacing.sm) {
            Text(StringConstants.Home.noGoalSet)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button(StringConstants.Home.setGoal) {}
                .font(.subheadline)
        }
        .frame(width: 120, height: 120)
    }
}
