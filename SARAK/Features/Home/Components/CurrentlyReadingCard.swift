// CurrentlyReadingCard.swift — SARAK
import SwiftUI

struct CurrentlyReadingCard: View {
    let book: HomeBookDisplayModel?
    let isSessionActive: Bool
    let onAddBook: () -> Void
    let onToggleSession: () -> Void

    var body: some View {
        if let book {
            bookCard(book)
        } else {
            emptyState
        }
    }

    private func bookCard(_ book: HomeBookDisplayModel) -> some View {
        HStack(alignment: .center, spacing: UIConstants.Spacing.cardSpacingCompact) {
            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.sm)
                .fill(UIConstants.Colors.surfaceStrong)
                .frame(width: 78, height: 110)

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
                Button(isSessionActive ? StringConstants.Home.stopSession : StringConstants.Home.startSession) {
                    onToggleSession()
                }
                    .buttonStyle(
                        PillButtonStyle(
                            minHeight: UIConstants.Size.compactButtonHeight,
                            horizontalPadding: UIConstants.Spacing.md
                        )
                    )
                    .padding(.top, UIConstants.Spacing.xxs)
            }

            Spacer()
        }
        .compactCard()
        .padding(.horizontal, UIConstants.Spacing.md)
    }

    private var emptyState: some View {
        EmptyStateCard(
            message: StringConstants.Home.noCurrentBook,
            actionTitle: StringConstants.Home.addBook,
            action: onAddBook
        )
            .padding(.horizontal, UIConstants.Spacing.md)
    }
}
