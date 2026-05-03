// BookRowCard.swift — SARAK
import SwiftUI

struct BookRowCard: View {
    let book: Book

    var body: some View {
        HStack(spacing: UIConstants.Spacing.smd) {
            coverPlaceholder
            bookInfo
            Spacer(minLength: 0)
            statusBadge
        }
        .compactCard(cornerRadius: UIConstants.CornerRadius.lg)
    }

    private var coverPlaceholder: some View {
        ZStack {
            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.md, style: .continuous)
                .fill(coverTone)
            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.md, style: .continuous)
                .stroke(UIConstants.Colors.hairlineSoft, lineWidth: 1)
            Image(systemName: "book.closed.fill")
                .font(UIConstants.Typography.bodyStrong)
                .foregroundStyle(book.status == .finished ? UIConstants.Colors.onDark : UIConstants.Colors.bodyStrong)
        }
        .frame(width: UIConstants.Size.bookRowCoverWidth, height: UIConstants.Size.bookRowCoverHeight)
    }

    private var bookInfo: some View {
        VStack(alignment: .leading, spacing: UIConstants.Spacing.sm) {
            Text(book.title)
                .font(UIConstants.Typography.bodyStrong)
                .foregroundStyle(UIConstants.Colors.ink)
                .lineLimit(2)
            Text(book.author)
                .font(UIConstants.Typography.caption)
                .foregroundStyle(UIConstants.Colors.muted)
                .lineLimit(1)
            if book.status == .reading {
                progressBar
            }
        }
    }

    private var progressBar: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(UIConstants.Colors.surfaceStrong)
                Capsule()
                    .fill(UIConstants.Colors.primary)
                    .frame(width: proxy.size.width * min(max(book.progress, 0), 1))
            }
        }
        .frame(height: UIConstants.Size.progressTrack)
        .padding(.top, UIConstants.Spacing.xxs)
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
            .frame(minWidth: UIConstants.Size.statusBadgeMinWidth)
            .padding(.horizontal, UIConstants.Spacing.sm)
            .padding(.vertical, UIConstants.Spacing.xxs)
            .background(background)
            .clipShape(Capsule())
    }

    private var coverTone: Color {
        switch book.status {
        case .reading:
            return UIConstants.Colors.coverWarm
        case .queued:
            return UIConstants.Colors.coverCool
        case .finished:
            return UIConstants.Colors.coverInk
        }
    }
}
