// HomeEmptyOnboardingView.swift — SARAK
import SwiftUI

struct HomeEmptyOnboardingView: View {
    let onAddBook: () -> Void

    private var dateDayString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.setLocalizedDateFormatFromTemplate("EEEEMMMMd")
        return String(format: StringConstants.Home.emptyDayFormat, formatter.string(from: Date()))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: UIConstants.Spacing.lg) {
            header
            heroCard
            setupSection
        }
        .padding(.horizontal, UIConstants.Spacing.lg)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: UIConstants.Spacing.sm) {
            Text(StringConstants.Home.emptyWelcome)
                .font(UIConstants.Typography.caption)
                .foregroundStyle(UIConstants.Colors.muted)
            Text(StringConstants.Tab.home)
                .font(UIConstants.Typography.displayMD)
                .foregroundStyle(UIConstants.Colors.ink)
            Text(dateDayString)
                .font(UIConstants.Typography.caption)
                .foregroundStyle(UIConstants.Colors.muted)
                .padding(.top, UIConstants.Spacing.xxs)
        }
    }

    private var heroCard: some View {
        VStack(alignment: .leading, spacing: UIConstants.Spacing.sm) {
            Text(StringConstants.Home.emptyStepLabel.uppercased())
                .font(UIConstants.Typography.captionUppercase)
                .tracking(UIConstants.Typography.trackingWide)
                .foregroundStyle(UIConstants.Colors.onDarkSoft)
            Text(StringConstants.Home.emptyHeroTitle)
                .font(UIConstants.Typography.titleMD)
                .foregroundStyle(UIConstants.Colors.onDark)
            Text(StringConstants.Home.emptyHeroBody)
                .font(UIConstants.Typography.bodySM)
                .foregroundStyle(UIConstants.Colors.onDarkMuted)
                .lineSpacing(3)
            dashedProgress
            .padding(.top, UIConstants.Spacing.sm)
            Button(action: onAddBook) {
                Text(StringConstants.Home.emptyAddBookCTA)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(
                PillButtonStyle(
                    backgroundColor: UIConstants.Colors.onDark,
                    pressedBackgroundColor: UIConstants.Colors.accent,
                    foregroundColor: UIConstants.Colors.ink
                )
            )
            .padding(.top, UIConstants.Spacing.sm)
        }
        .padding(.horizontal, UIConstants.Spacing.lgs)
        .padding(.vertical, UIConstants.Spacing.lgs)
        .background(UIConstants.Colors.ink)
        .clipShape(RoundedRectangle(cornerRadius: UIConstants.CornerRadius.hero, style: .continuous))
    }

    private var dashedProgress: some View {
        Text(StringConstants.Home.emptySetupProgress)
            .font(.system(size: 11, weight: .regular))
            .foregroundStyle(UIConstants.Colors.onDarkMuted)
            .tracking(0.3)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, UIConstants.Spacing.md)
            .padding(.vertical, UIConstants.Spacing.xs)
            .overlay {
                RoundedRectangle(cornerRadius: UIConstants.CornerRadius.xs, style: .continuous)
                    .stroke(
                        UIConstants.Colors.darkDashedBorder,
                        style: StrokeStyle(lineWidth: 1.5, dash: [5, 4])
                    )
            }
    }

    private var setupSection: some View {
        VStack(alignment: .leading, spacing: UIConstants.Spacing.sm) {
            HStack(alignment: .firstTextBaseline) {
                Text(StringConstants.Home.emptySetupTitle)
                    .font(UIConstants.Typography.titleSM)
                    .foregroundStyle(UIConstants.Colors.ink)
                Spacer()
                Text(StringConstants.Home.emptySetupCount)
                    .font(UIConstants.Typography.caption)
                    .foregroundStyle(UIConstants.Colors.muted)
            }
            setupRow(number: 1, title: StringConstants.Home.emptyStepOneTitle,
                     subtitle: StringConstants.Home.emptyStepOneSubtitle, isActive: true)
            setupRow(number: 2, title: StringConstants.Home.emptyStepTwoTitle,
                     subtitle: StringConstants.Home.emptyStepTwoSubtitle, isActive: false)
            setupRow(number: 3, title: StringConstants.Home.emptyStepThreeTitle,
                     subtitle: StringConstants.Home.emptyStepThreeSubtitle, isActive: false)
        }
    }

    private func setupRow(number: Int, title: String, subtitle: String, isActive: Bool) -> some View {
        Button {
            if isActive { onAddBook() }
        } label: {
            HStack(spacing: UIConstants.Spacing.smd) {
                stepBadge(number: number, isActive: isActive)
                VStack(alignment: .leading, spacing: UIConstants.Spacing.xxs) {
                    Text(title)
                        .font(UIConstants.Typography.bodyStrong)
                        .foregroundStyle(UIConstants.Colors.ink)
                    Text(subtitle)
                        .font(UIConstants.Typography.caption)
                        .foregroundStyle(UIConstants.Colors.muted)
                }
                .opacity(isActive ? 1 : 0.55)
                Spacer()
                if isActive {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(UIConstants.Colors.ink)
                }
            }
            .padding(.horizontal, UIConstants.Spacing.md)
            .padding(.vertical, UIConstants.Spacing.smd)
            .background(UIConstants.Colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: UIConstants.CornerRadius.lg, style: .continuous))
        }
        .buttonStyle(.plain)
        .allowsHitTesting(isActive)
    }

    private func stepBadge(number: Int, isActive: Bool) -> some View {
        Text("\(number)")
            .font(.system(size: 12, weight: .bold))
            .foregroundStyle(isActive ? UIConstants.Colors.onDark : UIConstants.Colors.muted)
            .frame(width: UIConstants.Size.setupStepBadge, height: UIConstants.Size.setupStepBadge)
            .background(isActive ? UIConstants.Colors.ink : UIConstants.Colors.divider)
            .clipShape(Circle())
    }
}
