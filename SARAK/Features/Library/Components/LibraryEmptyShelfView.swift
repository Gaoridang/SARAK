// LibraryEmptyShelfView.swift — SARAK
import SwiftUI

struct LibraryEmptyShelfView: View {
    let onAddBook: () -> Void

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: UIConstants.Spacing.smd),
        count: 3
    )

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: UIConstants.Spacing.lgs) {
                tabStrip
                skeletonGrid
                Spacer(minLength: UIConstants.Spacing.section)
            }
            .padding(.horizontal, UIConstants.Spacing.lg)

            promptCard
                .padding(.horizontal, UIConstants.Spacing.lg)
                .offset(y: 150)
        }
    }

    private var tabStrip: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: UIConstants.Spacing.smd) {
                tab(StringConstants.Library.tabAll, isActive: true)
                tab(StringConstants.Library.tabReading, isActive: false)
                tab(StringConstants.Library.tabFinished, isActive: false)
                tab(StringConstants.Library.tabWantToRead, isActive: false)
            }
        }
    }

    private func tab(_ title: String, isActive: Bool) -> some View {
        Text(title)
            .font(.system(size: 13, weight: .medium))
            .foregroundStyle(isActive ? UIConstants.Colors.ink : UIConstants.Colors.muted)
            .padding(.bottom, UIConstants.Spacing.sm)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(isActive ? UIConstants.Colors.ink : .clear)
                    .frame(height: 2)
            }
    }

    private var skeletonGrid: some View {
        LazyVGrid(columns: columns, spacing: UIConstants.Spacing.smd) {
            ForEach(0..<6, id: \.self) { index in
                skeletonCell(isShort: index % 2 == 1)
            }
        }
        .blur(radius: 0.5)
        .opacity(0.45)
        .allowsHitTesting(false)
    }

    private func skeletonCell(isShort: Bool) -> some View {
        VStack(alignment: .leading, spacing: UIConstants.Spacing.sm) {
            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.sm, style: .continuous)
                .fill(UIConstants.Colors.surface)
                .aspectRatio(3 / 4, contentMode: .fit)
            skeletonLine(width: 0.85)
            skeletonLine(width: isShort ? 0.45 : 0.60)
        }
    }

    private func skeletonLine(width: CGFloat) -> some View {
        GeometryReader { proxy in
            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.sm, style: .continuous)
                .fill(UIConstants.Colors.border)
                .frame(width: proxy.size.width * width)
        }
        .frame(height: UIConstants.Size.skeletonLineHeight)
    }

    private var promptCard: some View {
        VStack(spacing: UIConstants.Spacing.sm) {
            Text(StringConstants.Library.emptyTitle)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(UIConstants.Colors.onDark)
            Text(StringConstants.Library.emptyBody)
                .font(UIConstants.Typography.bodySM)
                .foregroundStyle(UIConstants.Colors.onDarkMuted)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
            actionRow
                .padding(.top, UIConstants.Spacing.sm)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, UIConstants.Spacing.lgs)
        .padding(.vertical, UIConstants.Spacing.lgs)
        .background(UIConstants.Colors.ink)
        .clipShape(RoundedRectangle(cornerRadius: UIConstants.CornerRadius.hero, style: .continuous))
        .shadow(
            color: UIConstants.Shadow.promptColor,
            radius: UIConstants.Shadow.promptRadius,
            x: UIConstants.Shadow.promptX,
            y: UIConstants.Shadow.promptY
        )
    }

    private var actionRow: some View {
        HStack(spacing: UIConstants.Spacing.sm) {
            Button(action: onAddBook) {
                Text(StringConstants.Library.addBook)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(
                PillButtonStyle(
                    backgroundColor: UIConstants.Colors.onDark,
                    pressedBackgroundColor: UIConstants.Colors.accent,
                    foregroundColor: UIConstants.Colors.ink,
                    minHeight: UIConstants.Size.compactButtonHeight
                )
            )

            scanButton
        }
    }

    private var scanButton: some View {
        HStack(spacing: UIConstants.Spacing.xxs) {
            Image(systemName: "barcode.viewfinder")
                .font(.system(size: UIConstants.Size.scanIcon, weight: .semibold))
            Text(StringConstants.Library.scanISBN)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .font(.system(size: 13, weight: .semibold))
        .foregroundStyle(UIConstants.Colors.onDark)
        .frame(maxWidth: .infinity, minHeight: UIConstants.Size.compactButtonHeight)
        .overlay {
            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.lg, style: .continuous)
                .stroke(UIConstants.Colors.darkBorder, lineWidth: 1)
        }
        .opacity(0.9)
    }
}
