// ReadingQueueStrip.swift — SARAK
import SwiftUI

struct ReadingQueueStrip: View {
    let books: [HomeBookDisplayModel]
    let onAddBook: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: UIConstants.Spacing.sm) {
            Text(String(format: StringConstants.Home.upNextFormat, books.count))
                .font(UIConstants.Typography.titleSM)
                .foregroundStyle(UIConstants.Colors.ink)
                .padding(.horizontal, UIConstants.Spacing.lg)

            if books.isEmpty {
                EmptyStateCard(
                    message: StringConstants.Home.emptyQueue,
                    actionTitle: StringConstants.Home.addBook,
                    action: onAddBook
                )
                    .padding(.horizontal, UIConstants.Spacing.lg)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: UIConstants.Spacing.xs) {
                        ForEach(Array(books.enumerated()), id: \.element.id) { index, book in
                            bookCard(book, tone: coverTone(at: index), isDark: index % 4 == 2)
                        }
                    }
                    .padding(.horizontal, UIConstants.Spacing.lg)
                }
            }
        }
    }

    private func bookCard(_ book: HomeBookDisplayModel, tone: Color, isDark: Bool) -> some View {
        VStack(spacing: UIConstants.Spacing.sm) {
            ZStack {
                RoundedRectangle(cornerRadius: UIConstants.CornerRadius.md, style: .continuous)
                    .fill(tone)
                Text(initials(for: book))
                    .font(.system(size: 12, weight: .bold))
                    .tracking(1)
                    .foregroundStyle(isDark ? UIConstants.Colors.onDark : UIConstants.Colors.ink)
            }
                .frame(width: 72, height: 102)
            Text(book.title)
                .font(UIConstants.Typography.caption)
                .foregroundStyle(UIConstants.Colors.bodyStrong)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 84)
        }
        .frame(width: 84)
    }

    private func coverTone(at index: Int) -> Color {
        let tones = [
            UIConstants.Colors.coverWarm,
            UIConstants.Colors.coverCool,
            UIConstants.Colors.coverInk,
            UIConstants.Colors.coverSage
        ]
        return tones[index % tones.count]
    }

    private func initials(for book: HomeBookDisplayModel) -> String {
        book.title
            .split(separator: " ")
            .prefix(2)
            .compactMap { $0.first }
            .map(String.init)
            .joined()
            .uppercased()
    }
}
