// LibraryView.swift — SARAK
import SwiftUI

struct LibraryView: View {
    @StateObject private var viewModel: LibraryViewModel
    @State private var isShowingAddBook = false

    init(viewModel: LibraryViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                UIConstants.Colors.canvas
                    .ignoresSafeArea()
                scrollContent
                if !viewModel.books.isEmpty {
                    fab
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
        .onAppear { Task { await viewModel.load() } }
        .sheet(isPresented: $isShowingAddBook) {
            AddBookView { title, author, totalPages, genre in
                await viewModel.addBook(title: title, author: author, totalPages: totalPages, genre: genre)
            }
        }
    }

    private var scrollContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: UIConstants.Spacing.lg) {
                header(showsCount: !viewModel.books.isEmpty)

                if viewModel.books.isEmpty {
                    LibraryEmptyShelfView {
                        isShowingAddBook = true
                    }
                } else {
                    LazyVStack(spacing: UIConstants.Spacing.cardSpacingCompact) {
                        ForEach(viewModel.books, id: \.id) { book in
                            NavigationLink {
                                BookDetailView(viewModel: viewModel.makeDetailViewModel(for: book))
                            } label: {
                                BookRowCard(book: book)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, UIConstants.Spacing.lg)
                }
            }
            .padding(.top, UIConstants.Spacing.lg)
            .padding(.bottom, UIConstants.Spacing.section)
        }
    }

    private func header(showsCount: Bool) -> some View {
        VStack(alignment: .leading, spacing: UIConstants.Spacing.xxs) {
            Text(StringConstants.Tab.library)
                .font(UIConstants.Typography.displayMD)
                .foregroundStyle(UIConstants.Colors.ink)
            if showsCount {
                Text(String(format: StringConstants.Library.countFormat, viewModel.books.count))
                    .font(UIConstants.Typography.bodySM)
                    .foregroundStyle(UIConstants.Colors.muted)
            }
        }
        .padding(.horizontal, UIConstants.Spacing.lg)
    }

    private var fab: some View {
        Button { isShowingAddBook = true } label: {
            Image(systemName: "plus")
        }
        .buttonStyle(FABButtonStyle())
        .padding(UIConstants.Spacing.lg)
    }
}
