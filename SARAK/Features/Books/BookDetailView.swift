// BookDetailView.swift — SARAK
import SwiftUI

struct BookDetailView: View {
    @StateObject private var viewModel: BookDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingDeleteConfirm = false
    @State private var isShowingEditBook = false
    @State private var localProgress: Double = 0

    init(viewModel: BookDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: UIConstants.Spacing.md) {
                heroCover
                infoSection
                metadataSection
                actionsSection
            }
            .padding(.horizontal, UIConstants.Spacing.md)
            .padding(.bottom, UIConstants.Spacing.xxl)
        }
        .navigationTitle(viewModel.book.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { localProgress = viewModel.book.progress }
        .onChange(of: viewModel.isDeleted) { _, deleted in
            if deleted { dismiss() }
        }
        .alert(StringConstants.BookDetail.deleteConfirmTitle, isPresented: $isShowingDeleteConfirm) {
            Button(StringConstants.BookDetail.delete, role: .destructive) {
                Task { await viewModel.deleteBook() }
            }
            Button(StringConstants.Common.cancel, role: .cancel) {}
        } message: {
            Text(StringConstants.BookDetail.deleteConfirmMessage)
        }
        .sheet(isPresented: $isShowingEditBook) {
            EditBookView(
                currentTitle: viewModel.book.title,
                currentAuthor: viewModel.book.author
            ) { title, author in
                await viewModel.updateBookInfo(title: title, author: author)
            }
        }
    }

    private var heroCover: some View {
        ZStack {
            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.lg, style: .continuous)
                .fill(UIConstants.Colors.surfaceStrong)
                .frame(maxWidth: .infinity)
                .frame(height: 180)
            Image(systemName: "book.closed.fill")
                .font(.system(size: 48))
                .foregroundStyle(UIConstants.Colors.muted)
        }
    }

    private var infoSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: UIConstants.Spacing.xxs) {
                Text(viewModel.book.title)
                    .font(UIConstants.Typography.displayMD)
                    .foregroundStyle(UIConstants.Colors.ink)
                Text(viewModel.book.author)
                    .font(UIConstants.Typography.bodyMD)
                    .foregroundStyle(UIConstants.Colors.muted)
            }
            Spacer(minLength: UIConstants.Spacing.sm)
            statusBadge
        }
        .compactCard()
    }

    private var statusBadge: some View {
        Group {
            switch viewModel.book.status {
            case .queued:
                badge(StringConstants.Library.statusQueued,
                      fg: UIConstants.Colors.muted, bg: UIConstants.Colors.surfaceCompact)
            case .reading:
                badge("\(Int(viewModel.book.progress * 100))%",
                      fg: UIConstants.Colors.primary, bg: UIConstants.Colors.surfaceStrong)
            case .finished:
                badge(StringConstants.Library.statusFinished,
                      fg: UIConstants.Colors.semanticSuccess, bg: UIConstants.Colors.surfaceCompact)
            }
        }
    }

    private func badge(_ label: String, fg: Color, bg: Color) -> some View {
        Text(label)
            .font(UIConstants.Typography.captionUppercase)
            .foregroundStyle(fg)
            .padding(.horizontal, UIConstants.Spacing.sm)
            .padding(.vertical, UIConstants.Spacing.xxs)
            .background(bg)
            .clipShape(Capsule())
    }

    private var metadataSection: some View {
        VStack(spacing: UIConstants.Spacing.sm) {
            if viewModel.book.status == .reading {
                HStack {
                    Text(StringConstants.BookDetail.progressLabel)
                        .font(UIConstants.Typography.bodySM)
                        .foregroundStyle(UIConstants.Colors.muted)
                    Slider(value: $localProgress, in: 0...1) { isEditing in
                        if !isEditing { Task { await viewModel.updateProgress(localProgress) } }
                    }
                    .tint(UIConstants.Colors.primary)
                    Text("\(Int(localProgress * 100))%")
                        .font(UIConstants.Typography.captionUppercase)
                        .foregroundStyle(UIConstants.Colors.primary)
                        .frame(width: 36, alignment: .trailing)
                }
            }
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
        .compactCard()
    }

    private var actionsSection: some View {
        VStack(spacing: UIConstants.Spacing.sm) {
            Button(primaryActionTitle) {
                Task { await viewModel.updateStatus(nextStatus) }
            }
            .buttonStyle(PillButtonStyle())
            .frame(maxWidth: .infinity)
            HStack {
                Button(StringConstants.BookDetail.editInfo) { isShowingEditBook = true }
                    .buttonStyle(PillButtonStyle(
                        backgroundColor: .clear,
                        pressedBackgroundColor: UIConstants.Colors.surfaceStrong,
                        foregroundColor: UIConstants.Colors.ink,
                        borderColor: UIConstants.Colors.hairlineStrong,
                        borderWidth: 1,
                        minHeight: UIConstants.Size.compactButtonHeight,
                        horizontalPadding: UIConstants.Spacing.md
                    ))
                Spacer()
                Button(StringConstants.BookDetail.deleteBook) { isShowingDeleteConfirm = true }
                    .font(UIConstants.Typography.button)
                    .foregroundStyle(UIConstants.Colors.semanticError)
            }
        }
    }

    private var primaryActionTitle: String {
        switch viewModel.book.status {
        case .queued: return StringConstants.BookDetail.startReading
        case .reading: return StringConstants.BookDetail.markFinished
        case .finished: return StringConstants.BookDetail.readAgain
        }
    }

    private var nextStatus: BookStatus {
        switch viewModel.book.status {
        case .queued: return .reading
        case .reading: return .finished
        case .finished: return .reading
        }
    }
}
