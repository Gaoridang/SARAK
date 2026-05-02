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
        HStack(alignment: .center, spacing: UIConstants.Spacing.md) {
            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.sm)
                .fill(UIConstants.Colors.surfaceStrong)
                .frame(width: 88, height: 124)

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
                Button(StringConstants.Home.startSession) {}
                    .font(UIConstants.Typography.button)
                    .foregroundStyle(UIConstants.Colors.onPrimary)
                    .padding(.vertical, UIConstants.Spacing.sm)
                    .padding(.horizontal, UIConstants.Spacing.lg)
                    .frame(height: 44)
                    .background(UIConstants.Colors.primary)
                    .clipShape(Capsule())
                    .padding(.top, UIConstants.Spacing.sm)
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
        EmptyStateCard(
            message: StringConstants.Home.noCurrentBook,
            actionTitle: StringConstants.Home.addBook
        )
            .padding(.horizontal, UIConstants.Spacing.md)
    }
}
