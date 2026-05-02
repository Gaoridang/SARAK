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
                .fill(Color.secondary.opacity(0.2))
                .frame(width: 72, height: 100)

            VStack(alignment: .leading, spacing: UIConstants.Spacing.sm) {
                Text(book.title)
                    .font(.headline)
                    .lineLimit(2)
                Text(book.author)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(String(format: StringConstants.Home.progressFormat, Int(book.progress * 100)))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Button(StringConstants.Home.startSession) {}
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
            }

            Spacer()
        }
        .padding(UIConstants.Spacing.md)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: UIConstants.CornerRadius.md))
        .padding(.horizontal, UIConstants.Spacing.md)
    }

    private var emptyState: some View {
        VStack(spacing: UIConstants.Spacing.sm) {
            Text(StringConstants.Home.noCurrentBook)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Button(StringConstants.Home.addBook) {}
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity)
        .padding(UIConstants.Spacing.lg)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: UIConstants.CornerRadius.md))
        .padding(.horizontal, UIConstants.Spacing.md)
    }
}
