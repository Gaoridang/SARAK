// EmptyStateCard.swift — SARAK
import SwiftUI

struct EmptyStateCard: View {
    let message: String
    let actionTitle: String?
    let action: () -> Void

    init(
        message: String,
        actionTitle: String? = nil,
        action: @escaping () -> Void = {}
    ) {
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }

    var body: some View {
        VStack(spacing: UIConstants.Spacing.sm) {
            Text(message)
                .font(UIConstants.Typography.bodySM)
                .foregroundStyle(UIConstants.Colors.muted)
                .multilineTextAlignment(.center)

            if let actionTitle {
                Button(actionTitle, action: action)
                    .font(UIConstants.Typography.button)
                    .foregroundStyle(UIConstants.Colors.ink)
                    .padding(.vertical, UIConstants.Spacing.sm)
                    .padding(.horizontal, UIConstants.Spacing.lg)
                    .frame(height: 44)
                    .background(.clear)
                    .clipShape(Capsule())
                    .overlay(Capsule().stroke(UIConstants.Colors.hairlineStrong, lineWidth: 1))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(UIConstants.Spacing.lg)
        .background(UIConstants.Colors.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: UIConstants.CornerRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.lg)
                .stroke(UIConstants.Colors.hairline, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.04), radius: 16, x: 0, y: 4)
    }
}
