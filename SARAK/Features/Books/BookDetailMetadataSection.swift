// BookDetailMetadataSection.swift — SARAK
import SwiftUI

struct BookDetailMetadataSection: View {
    @ObservedObject var viewModel: BookDetailViewModel
    @Binding var localProgress: Double
    @Binding var localCurrentPage: Int

    var body: some View {
        VStack(spacing: UIConstants.Spacing.sm) {
            pagesRow
            if viewModel.book.totalPages == nil && viewModel.book.status == .reading {
                progressRow
            }
            if let genre = viewModel.book.genre {
                infoRow(label: StringConstants.BookDetail.genreLabel, value: genre)
            }
            if let notes = viewModel.book.notes {
                notesRow(notes)
            }
            addedRow
        }
        .compactCard()
    }

    @ViewBuilder
    private var pagesRow: some View {
        if let total = viewModel.book.totalPages {
            HStack {
                Text(StringConstants.BookDetail.pagesLabel)
                    .font(UIConstants.Typography.bodySM)
                    .foregroundStyle(UIConstants.Colors.muted)
                Spacer()
                HStack(spacing: UIConstants.Spacing.sm) {
                    Button {
                        if localCurrentPage > 0 {
                            localCurrentPage -= 1
                            Task { await viewModel.updateCurrentPage(localCurrentPage) }
                        }
                    } label: { Image(systemName: "minus") }
                    .buttonStyle(IconCircleButtonStyle())
                    .frame(width: UIConstants.Size.iconButton, height: UIConstants.Size.iconButton)

                    Text(String(format: StringConstants.BookDetail.pagesFormat, localCurrentPage, total))
                        .font(UIConstants.Typography.captionUppercase)
                        .foregroundStyle(UIConstants.Colors.ink)
                        .frame(minWidth: 80, alignment: .center)

                    Button {
                        if localCurrentPage < total {
                            localCurrentPage += 1
                            Task { await viewModel.updateCurrentPage(localCurrentPage) }
                        }
                    } label: { Image(systemName: "plus") }
                    .buttonStyle(IconCircleButtonStyle())
                    .frame(width: UIConstants.Size.iconButton, height: UIConstants.Size.iconButton)
                }
            }
        }
    }

    private var progressRow: some View {
        HStack {
            Text(StringConstants.BookDetail.progressLabel)
                .font(UIConstants.Typography.bodySM)
                .foregroundStyle(UIConstants.Colors.muted)
            Slider(value: $localProgress, in: 0...1) { editing in
                if !editing { Task { await viewModel.updateProgress(localProgress) } }
            }
            .tint(UIConstants.Colors.primary)
            Text("\(Int(localProgress * 100))%")
                .font(UIConstants.Typography.captionUppercase)
                .foregroundStyle(UIConstants.Colors.ink)
                .frame(width: 36, alignment: .trailing)
        }
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(UIConstants.Typography.bodySM)
                .foregroundStyle(UIConstants.Colors.muted)
            Spacer()
            Text(value)
                .font(UIConstants.Typography.bodySM)
                .foregroundStyle(UIConstants.Colors.ink)
        }
    }

    private func notesRow(_ notes: String) -> some View {
        VStack(alignment: .leading, spacing: UIConstants.Spacing.xxs) {
            Text(StringConstants.BookDetail.notesLabel)
                .font(UIConstants.Typography.bodySM)
                .foregroundStyle(UIConstants.Colors.muted)
            Text(notes)
                .font(UIConstants.Typography.bodySM)
                .foregroundStyle(UIConstants.Colors.ink)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var addedRow: some View {
        HStack {
            Text(StringConstants.BookDetail.addedLabel)
                .font(UIConstants.Typography.bodySM)
                .foregroundStyle(UIConstants.Colors.muted)
            Spacer()
            Text(viewModel.book.createdAt.formatted(date: .abbreviated, time: .omitted))
                .font(UIConstants.Typography.bodySM)
                .foregroundStyle(UIConstants.Colors.ink)
        }
    }
}
