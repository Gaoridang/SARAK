// CompactDesignStyles.swift — SARAK
import SwiftUI

struct CompactCardModifier: ViewModifier {
    var cornerRadius: CGFloat = UIConstants.CornerRadius.cardCompact
    var padding: CGFloat = UIConstants.Spacing.cardPaddingCompact

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background(UIConstants.Colors.surfaceCard)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(UIConstants.Colors.hairline, lineWidth: 1)
            }
            .shadow(
                color: UIConstants.Shadow.smColor,
                radius: UIConstants.Shadow.smRadius,
                x: UIConstants.Shadow.smX,
                y: UIConstants.Shadow.smY
            )
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
            .clipShape(RoundedRectangle(cornerRadius: UIConstants.CornerRadius.lg, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: UIConstants.CornerRadius.lg, style: .continuous)
                    .stroke(borderColor, lineWidth: borderWidth)
            }
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(.easeOut(duration: UIConstants.Motion.fast), value: configuration.isPressed)
    }
}

struct IconCircleButtonStyle: ButtonStyle {
    var foregroundColor: Color = UIConstants.Colors.ink

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(UIConstants.Typography.button)
            .foregroundStyle(foregroundColor)
            .frame(width: UIConstants.Size.iconButton, height: UIConstants.Size.iconButton)
            .background(configuration.isPressed ? UIConstants.Colors.surfaceStrong : UIConstants.Colors.surface)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(UIConstants.Colors.hairline, lineWidth: 1)
            }
            .frame(width: UIConstants.Size.iconButtonHitTarget, height: UIConstants.Size.iconButtonHitTarget)
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.easeOut(duration: UIConstants.Motion.fast), value: configuration.isPressed)
    }
}

struct FABButtonStyle: ButtonStyle {
    var size: CGFloat = 56

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 22, weight: .semibold))
            .foregroundStyle(UIConstants.Colors.onPrimary)
            .frame(width: size, height: size)
            .background(
                configuration.isPressed
                    ? UIConstants.Colors.primaryActive
                    : UIConstants.Colors.primary
            )
            .clipShape(Circle())
            .shadow(color: UIConstants.Shadow.mdColor, radius: 8, x: 0, y: 3)
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .animation(.easeOut(duration: UIConstants.Motion.fast), value: configuration.isPressed)
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
