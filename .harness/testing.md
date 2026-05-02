# Testing rules
# Load this when: writing or reviewing tests

## Framework
- Unit tests: Swift Testing (`import Testing`) — required for all new features
- UI tests: XCTest — auth flows and critical user journeys only

## Unit test template
```swift
import Testing
@testable import ReadingTracker

@Suite("BookListViewModel")
struct BookListViewModelTests {

    @Test("adds book successfully")
    func addBook() async throws {
        let repo = MockBookRepository()
        let vm = BookListViewModel(repository: repo)
        await vm.addBook(title: "Dune", author: "Herbert")
        #expect(vm.books.count == 1)
        #expect(vm.errorMessage == nil)
    }

    @Test("shows error on save failure")
    func addBookFailure() async throws {
        let repo = MockBookRepository(shouldFail: true)
        let vm = BookListViewModel(repository: repo)
        await vm.addBook(title: "Dune", author: "Herbert")
        #expect(vm.books.isEmpty)
        #expect(vm.errorMessage != nil)
    }
}
```

## Mocking pattern
```swift
final class MockBookRepository: BookRepositoryProtocol {
    var books: [Book] = []
    var shouldFail = false

    func save(_ book: Book) async throws {
        if shouldFail { throw BookError.saveFailed(underlying: MockError()) }
        books.append(book)
    }
    func fetchAll() async throws -> [Book] { books }
}
```

## SwiftData in-memory store for tests
```swift
let config = ModelConfiguration(isStoredInMemoryOnly: true)
let container = try ModelContainer(for: Book.self, configurations: config)
```
Never use the real ModelContainer in tests.

## Coverage requirements
- ViewModels: all public methods tested
- Repositories: save, fetch, delete, error cases
- SyncCoordinator: conflict resolution logic
- Auth: covered by UI tests
