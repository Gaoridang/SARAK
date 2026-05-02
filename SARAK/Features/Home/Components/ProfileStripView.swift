// ProfileStripView.swift — SARAK
import SwiftUI

struct ProfileStripView: View {
    let weeklyMinutes: Int

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: UIConstants.Spacing.xxs) {
                Text(StringConstants.Home.greeting)
                    .font(UIConstants.Typography.displaySM)
                    .foregroundStyle(UIConstants.Colors.ink)
                Text(String(format: StringConstants.Home.weeklyMinutesFormat, weeklyMinutes))
                    .font(UIConstants.Typography.caption)
                    .foregroundStyle(UIConstants.Colors.muted)
            }
            Spacer()
        }
        .padding(.horizontal, UIConstants.Spacing.md)
    }
}
