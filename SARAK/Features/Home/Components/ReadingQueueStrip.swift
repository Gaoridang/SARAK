// ReadingQueueStrip.swift — SARAK
import SwiftUI

struct ReadingQueueStrip: View {
    let books: [HomeBookDisplayModel]

    var body: some View {
        VStack(alignment: .leading, spacing: UIConstants.Spacing.sm) {
            Text(StringConstants.Home.readingQueue)
                .font(UIConstants.Typography.titleSM)
                .foregroundStyle(UIConstants.Colors.ink)
                .padding(.horizontal, UIConstants.Spacing.md)

            if books.isEmpty {
                EmptyStateCard(
                    message: StringConstants.Home.emptyQueue,
                    actionTitle: StringConstants.Home.addBook
                )
                    .padding(.horizontal, UIConstants.Spacing.md)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: UIConstants.Spacing.md) {
                        ForEach(books, id: \.title) { book in
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
                .frame(width: 80, height: 112)
            Text(book.title)
                .font(UIConstants.Typography.caption)
                .foregroundStyle(UIConstants.Colors.bodyStrong)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 88)
        }
        .frame(width: 112, height: 168)
        .background(UIConstants.Colors.surfaceCard)
        .clipShape(RoundedRectangle(cornerRadius: UIConstants.CornerRadius.lg))
        .overlay(
            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.lg)
                .stroke(UIConstants.Colors.hairline, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.03), radius: 10, x: 0, y: 3)
    }
}
