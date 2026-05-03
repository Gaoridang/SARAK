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
        VStack(spacing: UIConstants.Spacing.cardSpacingCompact) {
            Text(message)
                .font(UIConstants.Typography.bodySM)
                .foregroundStyle(UIConstants.Colors.muted)
                .multilineTextAlignment(.center)

            if let actionTitle {
                Button(actionTitle, action: action)
                    .buttonStyle(
                        PillButtonStyle(
                            backgroundColor: .clear,
                            pressedBackgroundColor: UIConstants.Colors.surfaceStrong,
                            foregroundColor: UIConstants.Colors.ink,
                            borderColor: UIConstants.Colors.hairlineStrong,
                            borderWidth: 1,
                            minHeight: UIConstants.Size.compactButtonHeight,
                            horizontalPadding: UIConstants.Spacing.md
                        )
                    )
            }
        }
        .frame(maxWidth: .infinity)
        .compactCard()
    }
}
