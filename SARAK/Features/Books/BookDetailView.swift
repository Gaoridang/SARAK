// BookDetailView.swift — SARAK
import SwiftUI

struct BookDetailView: View {
    @StateObject private var viewModel: BookDetailViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var isShowingDeleteConfirm = false
    @State private var isShowingEditBook = false
    @State private var localProgress: Double = 0
    @State private var localCurrentPage: Int = 0

    init(viewModel: BookDetailViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: UIConstants.Spacing.md) {
                headerSection
                BookDetailMetadataSection(
                    viewModel: viewModel,
                    localProgress: $localProgress,
                    localCurrentPage: $localCurrentPage
                )
                actionsSection
            }
            .padding(.horizontal, UIConstants.Spacing.md)
            .padding(.bottom, UIConstants.Spacing.xxl)
        }
        .background(UIConstants.Colors.canvas)
        .navigationTitle(viewModel.book.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            localProgress = viewModel.book.progress
            localCurrentPage = viewModel.book.currentPage ?? 0
        }
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
                currentAuthor: viewModel.book.author,
                currentTotalPages: viewModel.book.totalPages,
                currentGenre: viewModel.book.genre,
                currentNotes: viewModel.book.notes
            ) { title, author, totalPages, genre, notes in
                await viewModel.updateBookInfo(
                    title: title, author: author,
                    totalPages: totalPages, genre: genre, notes: notes
                )
            }
        }
    }

    private var headerSection: some View {
        HStack(alignment: .top, spacing: UIConstants.Spacing.md) {
            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.lg, style: .continuous)
                .fill(UIConstants.Colors.surfaceStrong)
                .overlay(
                    Image(systemName: "book.closed.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(UIConstants.Colors.muted)
                )
                .frame(width: 110, height: 154)

            VStack(alignment: .leading, spacing: UIConstants.Spacing.xxs) {
                Text(viewModel.book.title)
                    .font(UIConstants.Typography.displayMD)
                    .foregroundStyle(UIConstants.Colors.ink)
                Text(viewModel.book.author)
                    .font(UIConstants.Typography.bodyMD)
                    .foregroundStyle(UIConstants.Colors.muted)
                Spacer(minLength: UIConstants.Spacing.sm)
                statusBadge
            }
            Spacer()
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
                      fg: UIConstants.Colors.onPrimary, bg: UIConstants.Colors.primary)
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
