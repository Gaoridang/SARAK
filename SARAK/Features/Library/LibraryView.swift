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
                scrollContent
                fab
            }
            .navigationTitle(StringConstants.Tab.library)
        }
        .task { await viewModel.load() }
        .sheet(isPresented: $isShowingAddBook) {
            AddBookView { title, author in
                await viewModel.addBook(title: title, author: author)
            }
        }
    }

    private var scrollContent: some View {
        ScrollView {
            LazyVStack(spacing: UIConstants.Spacing.cardSpacingCompact) {
                if viewModel.books.isEmpty {
                    EmptyStateCard(
                        message: StringConstants.Library.empty,
                        actionTitle: StringConstants.Library.addBook
                    ) { isShowingAddBook = true }
                } else {
                    ForEach(viewModel.books, id: \.id) { book in
                        BookRowCard(book: book)
                    }
                }
            }
            .padding(.horizontal, UIConstants.Spacing.md)
            .padding(.top, UIConstants.Spacing.sm)
            .padding(.bottom, UIConstants.Spacing.xxl)
        }
    }

    private var fab: some View {
        Button { isShowingAddBook = true } label: {
            Image(systemName: "plus")
        }
        .buttonStyle(FABButtonStyle())
        .padding(UIConstants.Spacing.lg)
    }
}
