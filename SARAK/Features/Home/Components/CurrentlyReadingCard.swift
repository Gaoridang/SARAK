// CurrentlyReadingCard.swift — SARAK
import SwiftUI

struct CurrentlyReadingCard: View {
    let book: HomeBookDisplayModel?

    var body: some View {
        if let book {
            bookCard(book)
        } else {
            emptyState
        }
    }

    private func bookCard(_ book: HomeBookDisplayModel) -> some View {
        HStack(spacing: UIConstants.Spacing.md) {
            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.sm)
                .fill(UIConstants.Colors.surfaceStrong)
                .frame(width: 72, height: 100)

            VStack(alignment: .leading, spacing: UIConstants.Spacing.sm) {
                Text(book.title)
                    .font(UIConstants.Typography.titleSM)
                    .foregroundStyle(UIConstants.Colors.ink)
                    .lineLimit(2)
                Text(book.author)
                    .font(UIConstants.Typography.bodySM)
                    .foregroundStyle(UIConstants.Colors.muted)
                Text(String(format: StringConstants.Home.progressFormat, Int(book.progress * 100)))
                    .font(UIConstants.Typography.caption)
                    .foregroundStyle(UIConstants.Colors.muted)
                Spacer()
                Button(StringConstants.Home.startSession) {}
                    .font(UIConstants.Typography.button)
                    .foregroundStyle(UIConstants.Colors.onPrimary)
                    .padding(.vertical, UIConstants.Spacing.sm)
                    .padding(.horizontal, UIConstants.Spacing.xl)
                    .frame(height: 44)
                    .background(UIConstants.Colors.primary)
                    .clipShape(Capsule())
            }

            Spacer()
        }
        .padding(UIConstants.Spacing.lg)
        .background(UIConstants.Colors.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: UIConstants.CornerRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.lg)
                .stroke(UIConstants.Colors.hairline, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.04), radius: 16, x: 0, y: 4)
        .padding(.horizontal, UIConstants.Spacing.md)
    }

    private var emptyState: some View {
        VStack(spacing: UIConstants.Spacing.sm) {
            Text(StringConstants.Home.noCurrentBook)
                .font(UIConstants.Typography.bodySM)
                .foregroundStyle(UIConstants.Colors.muted)
            Button(StringConstants.Home.addBook) {}
                .font(UIConstants.Typography.button)
                .foregroundStyle(UIConstants.Colors.ink)
                .padding(.vertical, UIConstants.Spacing.sm)
                .padding(.horizontal, UIConstants.Spacing.xl)
                .frame(height: 44)
                .background(.clear)
                .clipShape(Capsule())
                .overlay(Capsule().stroke(UIConstants.Colors.hairlineStrong, lineWidth: 1))
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
        .padding(.horizontal, UIConstants.Spacing.md)
    }
}
