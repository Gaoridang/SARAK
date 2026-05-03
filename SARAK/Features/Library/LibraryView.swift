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
            List {
                if viewModel.books.isEmpty {
                    Text(StringConstants.Library.empty)
                        .foregroundStyle(UIConstants.Colors.muted)
                } else {
                    ForEach(viewModel.books, id: \.id) { book in
                        VStack(alignment: .leading, spacing: UIConstants.Spacing.xxs) {
                            Text(book.title)
                                .font(UIConstants.Typography.bodyStrong)
                            Text(book.author)
                                .font(UIConstants.Typography.caption)
                                .foregroundStyle(UIConstants.Colors.muted)
                        }
                    }
                }
            }
                .navigationTitle(StringConstants.Tab.library)
                .toolbar {
                    Button {
                        isShowingAddBook = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
        }
        .task { await viewModel.load() }
        .sheet(isPresented: $isShowingAddBook) {
            AddBookView { title, author in
                await viewModel.addBook(title: title, author: author)
            }
        }
    }
}
