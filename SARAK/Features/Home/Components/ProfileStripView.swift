// ProfileStripView.swift — SARAK
import SwiftUI

struct ProfileStripView: View {
    let weeklyMinutes: Int

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(StringConstants.Home.greeting)
                    .font(.title2)
                    .fontWeight(.bold)
                Text(String(format: StringConstants.Home.weeklyMinutesFormat, weeklyMinutes))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.horizontal, UIConstants.Spacing.md)
    }
}
