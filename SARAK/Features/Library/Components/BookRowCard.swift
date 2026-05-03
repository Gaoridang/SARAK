// BookRowCard.swift — SARAK
import SwiftUI

struct BookRowCard: View {
    let book: Book

    var body: some View {
        HStack(spacing: UIConstants.Spacing.md) {
            coverPlaceholder
            bookInfo
            Spacer(minLength: 0)
            statusBadge
        }
        .compactCard()
    }

    private var coverPlaceholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.sm, style: .continuous)
                .fill(UIConstants.Colors.surfaceStrong)
                .frame(width: 44, height: 60)
            Image(systemName: "book.closed.fill")
                .foregroundStyle(UIConstants.Colors.muted)
        }
    }

    private var bookInfo: some View {
        VStack(alignment: .leading, spacing: UIConstants.Spacing.xxs) {
            Text(book.title)
                .font(UIConstants.Typography.bodyStrong)
                .foregroundStyle(UIConstants.Colors.ink)
                .lineLimit(2)
            Text(book.author)
                .font(UIConstants.Typography.caption)
                .foregroundStyle(UIConstants.Colors.muted)
                .lineLimit(1)
        }
    }

    private var statusBadge: some View {
        Group {
            switch book.status {
            case .reading:
                badge(
                    label: "\(Int(book.progress * 100))%",
                    foreground: UIConstants.Colors.primary,
                    background: UIConstants.Colors.surfaceStrong
                )
            case .queued:
                badge(
                    label: StringConstants.Library.statusQueued,
                    foreground: UIConstants.Colors.muted,
                    background: UIConstants.Colors.surfaceCompact
                )
            case .finished:
                badge(
                    label: StringConstants.Library.statusFinished,
                    foreground: UIConstants.Colors.semanticSuccess,
                    background: UIConstants.Colors.surfaceCompact
                )
            }
        }
    }

    private func badge(label: String, foreground: Color, background: Color) -> some View {
        Text(label)
            .font(UIConstants.Typography.captionUppercase)
            .foregroundStyle(foreground)
            .padding(.horizontal, UIConstants.Spacing.sm)
            .padding(.vertical, UIConstants.Spacing.xxs)
            .background(background)
            .clipShape(Capsule())
    }
}
