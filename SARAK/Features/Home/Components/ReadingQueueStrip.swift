// ReadingQueueStrip.swift — SARAK
import SwiftUI

struct ReadingQueueStrip: View {
    let books: [HomeBookDisplayModel]
    let onAddBook: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: UIConstants.Spacing.sm) {
            Text(StringConstants.Home.readingQueue)
                .font(UIConstants.Typography.titleSM)
                .foregroundStyle(UIConstants.Colors.ink)
                .padding(.horizontal, UIConstants.Spacing.md)

            if books.isEmpty {
                EmptyStateCard(
                    message: StringConstants.Home.emptyQueue,
                    actionTitle: StringConstants.Home.addBook,
                    action: onAddBook
                )
                    .padding(.horizontal, UIConstants.Spacing.md)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: UIConstants.Spacing.md) {
                        ForEach(books, id: \.id) { book in
                            bookCard(book)
                        }
                    }
                    .padding(.horizontal, UIConstants.Spacing.md)
                }
            }
        }
    }

    private func bookCard(_ book: HomeBookDisplayModel) -> some View {
        VStack(spacing: UIConstants.Spacing.sm) {
            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.sm)
                .fill(UIConstants.Colors.surfaceStrong)
                .frame(width: 72, height: 102)
            Text(book.title)
                .font(UIConstants.Typography.caption)
                .foregroundStyle(UIConstants.Colors.bodyStrong)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 84)
        }
        .frame(width: 104, height: 152)
        .compactCard(padding: UIConstants.Spacing.cardPaddingTight)
    }
}
