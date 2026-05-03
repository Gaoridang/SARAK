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
        VStack(alignment: .leading, spacing: UIConstants.Spacing.sm) {
            Text(StringConstants.Home.continueReading.uppercased())
                .font(UIConstants.Typography.captionUppercase)
                .tracking(UIConstants.Typography.trackingWide)
                .foregroundStyle(UIConstants.Colors.onDarkSoft)

            Text(book.title)
                .font(UIConstants.Typography.titleMD)
                .foregroundStyle(UIConstants.Colors.onDark)
                .lineLimit(2)
                .padding(.top, UIConstants.Spacing.xxs)

            Text(book.author)
                .font(UIConstants.Typography.bodySM)
                .foregroundStyle(UIConstants.Colors.onDarkMuted)
                .lineLimit(1)

            VStack(alignment: .leading, spacing: UIConstants.Spacing.sm) {
                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(UIConstants.Colors.darkTrack)
                        Capsule()
                            .fill(UIConstants.Colors.onDark)
                            .frame(width: proxy.size.width * min(max(book.progress, 0), 1))
                    }
                }
                .frame(height: UIConstants.Size.progressTrack)
                .padding(.top, UIConstants.Spacing.md)

                HStack {
                    Text(progressDetail(for: book))
                    Spacer()
                    Text(String(format: StringConstants.Home.progressFormat, Int(book.progress * 100)))
                }
                .font(.system(size: 11, weight: .regular))
                .foregroundStyle(UIConstants.Colors.onDarkMuted)
            }

            Button {
                onToggleSession()
            } label: {
                Text(isSessionActive ? StringConstants.Home.stopSession : StringConstants.Home.startSession)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(
                PillButtonStyle(
                    backgroundColor: isSessionActive ? UIConstants.Colors.accent : UIConstants.Colors.onDark,
                    pressedBackgroundColor: UIConstants.Colors.accent,
                    foregroundColor: UIConstants.Colors.ink,
                    minHeight: UIConstants.Size.buttonHeight,
                    horizontalPadding: UIConstants.Spacing.md
                )
            )
            .padding(.top, UIConstants.Spacing.sm)
        }
        .padding(.horizontal, UIConstants.Spacing.lgs)
        .padding(.vertical, UIConstants.Spacing.lgs)
        .background(UIConstants.Colors.ink)
        .clipShape(RoundedRectangle(cornerRadius: UIConstants.CornerRadius.hero, style: .continuous))
        .padding(.horizontal, UIConstants.Spacing.lg)
    }

    private func progressDetail(for book: HomeBookDisplayModel) -> String {
        if let currentPage = book.currentPage, let totalPages = book.totalPages, totalPages > 0 {
            return String(format: StringConstants.Home.pageProgressFormat, currentPage, totalPages)
        }
        return String(format: StringConstants.Home.progressFormat, Int(book.progress * 100))
    }

    private var emptyState: some View {
        EmptyStateCard(
            message: StringConstants.Home.noCurrentBook,
            actionTitle: StringConstants.Home.addBook,
            action: onAddBook
        )
            .padding(.horizontal, UIConstants.Spacing.lg)
    }
}
