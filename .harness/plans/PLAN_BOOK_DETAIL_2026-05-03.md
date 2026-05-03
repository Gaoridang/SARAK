# Plan: Book Detail View — 2026-05-03

## Branch
`feat/book-detail`

## Goal
Add a `BookDetailView` pushed from the Library screen that lets users view and edit a book's status, reading progress, title/author, and delete the book.

## Architecture
```
LibraryView (NavigationStack)
  └─ NavigationLink (label: BookRowCard)
       └─ BookDetailView
            └─ BookDetailViewModel → BookRepositoryProtocol
                                   → SyncTriggerProtocol (optional)
```

## New Files
- `SARAK/Features/Books/BookDetailView.swift`
- `SARAK/Features/Books/BookDetailViewModel.swift`
- `SARAK/Features/Books/EditBookView.swift`
- `SARAKTests/BookDetailViewModelTests.swift`

## Modified Files
- `SARAK/Features/Library/LibraryViewModel.swift` — `makeDetailViewModel(for:)` factory
- `SARAK/Features/Library/LibraryView.swift` — NavigationLink + `.onAppear` refresh
- `SARAK/Constants/StringConstants.swift` — `BookDetail` enum
- `SARAK/Resources/Localizable.strings` — new string entries

## Task Checklist
- [x] Create this harness plan file
- [x] Snapshot working tree
- [x] Add `StringConstants.BookDetail` + Localizable.strings entries
- [x] Implement `BookDetailViewModel`
- [x] Add `makeDetailViewModel(for:)` to `LibraryViewModel`
- [x] Update `LibraryView` (NavigationLink + onAppear refresh)
- [x] Implement `BookDetailView`
- [x] Implement `EditBookView`
- [x] Write `BookDetailViewModelTests`
- [x] Build + SwiftLint + tests pass
- [x] Update agent log
