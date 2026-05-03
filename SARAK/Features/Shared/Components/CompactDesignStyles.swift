// CompactDesignStyles.swift — SARAK
import SwiftUI

struct CompactCardModifier: ViewModifier {
    var cornerRadius: CGFloat = UIConstants.CornerRadius.cardCompact
    var padding: CGFloat = UIConstants.Spacing.cardPaddingCompact

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(UIConstants.Colors.surfaceCompact)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(UIConstants.Colors.hairlineSoft, lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.025), radius: 8, x: 0, y: 3)
    }
}

struct PillButtonStyle: ButtonStyle {
    var backgroundColor: Color = UIConstants.Colors.primary
    var pressedBackgroundColor: Color = UIConstants.Colors.primaryActive
    var foregroundColor: Color = UIConstants.Colors.onPrimary
    var borderColor: Color = .clear
    var borderWidth: CGFloat = 0
    var minHeight: CGFloat = UIConstants.Size.buttonHeight
    var horizontalPadding: CGFloat = UIConstants.Spacing.buttonHorizontal

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(UIConstants.Typography.button)
            .foregroundStyle(foregroundColor)
            .frame(minHeight: minHeight)
            .padding(.horizontal, horizontalPadding)
            .background(configuration.isPressed ? pressedBackgroundColor : backgroundColor)
            .clipShape(Capsule())
            .overlay {
                Capsule().stroke(borderColor, lineWidth: borderWidth)
            }
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

struct IconCircleButtonStyle: ButtonStyle {
    var foregroundColor: Color = UIConstants.Colors.ink

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(UIConstants.Typography.button)
            .foregroundStyle(foregroundColor)
            .frame(width: UIConstants.Size.iconButton, height: UIConstants.Size.iconButton)
            .background(
                configuration.isPressed
                    ? UIConstants.Colors.surfaceStrong
                    : UIConstants.Colors.canvasSoft
            )
            .clipShape(Circle())
            .overlay {
                Circle().stroke(UIConstants.Colors.hairlineSoft, lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.02), radius: 6, x: 0, y: 2)
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

extension View {
    func compactCard(
        cornerRadius: CGFloat = UIConstants.CornerRadius.cardCompact,
        padding: CGFloat = UIConstants.Spacing.cardPaddingCompact
    ) -> some View {
        modifier(CompactCardModifier(cornerRadius: cornerRadius, padding: padding))
    }
}
