// ReadingQueueStrip.swift — SARAK
import SwiftUI

struct ReadingQueueStrip: View {
    let books: [HomeBookDisplayModel]

    var body: some View {
        if !books.isEmpty {
            content
        }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: UIConstants.Spacing.sm) {
            Text(StringConstants.Home.readingQueue)
                .font(UIConstants.Typography.titleSM)
                .foregroundStyle(UIConstants.Colors.ink)
                .padding(.horizontal, UIConstants.Spacing.md)

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
                .frame(width: 80)
        }
    }
}
