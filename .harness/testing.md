# Testing rules
# Load this when: writing or reviewing tests

## Purpose

Tests protect architecture, behavior, and future refactors.

New logic should ship with tests in the same PR.

---

## Frameworks

Use Swift Testing for unit tests.

Use XCTest only for:

- UI tests
- launch tests
- critical user journey tests
- flows that require XCTest infrastructure

Unit test files should import:

import Testing
@testable import SARAK

Do not use XCTest for ordinary ViewModel, repository, service, or model tests unless there is a specific reason.

---

## What must be tested

Tests are required for:

- new ViewModel public methods
- ViewModel state transitions
- repository save/fetch/delete logic
- service success and failure behavior
- business logic
- error handling paths
- meaningful edge cases
- sync conflict logic when sync changes are approved

Tests are not required for:

- purely visual SwiftUI layout with no logic
- simple static placeholder views
- generated boilerplate
- code that is unreachable in the current PR

Stub-only PRs still require:

- smoke tests for new ViewModels
- empty-state tests when empty states are supported
- basic dependency injection tests when services are introduced

---

## Test file naming

Test files:

- `<TypeName>Tests.swift`

Examples:

- `HomeViewModelTests.swift`
- `BookRepositoryTests.swift`
- `WeatherServiceTests.swift`
- `AuthViewModelTests.swift`

Suites:

- `@Suite("<TypeName>")`

Example:

@Suite("HomeViewModel")
struct HomeViewModelTests {
}

---

## Test naming

Test names should describe behavior.

Good:

- `loads current book successfully`
- `shows empty state when no current book exists`
- `sets error message when repository fails`
- `does not start session without selected book`
- `creates pending change after local write`

Avoid:

- `test1`
- `works`
- `success`
- `failure`
- `viewModelTest`

---

## Recommended test structure

Use Given / When / Then comments for non-trivial tests.

Example:

@Test("sets error message when save fails")
func saveFailure() async throws {
    // Given
    let repository = FailingBookRepository()
    let viewModel = BookSearchViewModel(bookRepository: repository)

    // When
    await viewModel.saveBook(title: "Dune")

    // Then
    #expect(viewModel.errorMessage != nil)
}

Small obvious tests may omit comments.

---

## ViewModel tests

ViewModel tests should verify:

- initial state
- loading state
- success state
- failure state
- empty state
- dependency calls when relevant
- user intent methods

Common expectations:

- `isLoading` becomes false after work completes
- `errorMessage` is nil on success
- `errorMessage` is set on failure
- displayed items match repository/service output
- no duplicate work is started if that is part of the design

All ViewModels must be `@MainActor`.

If needed, mark the test suite or test method with `@MainActor`.

Example:

@MainActor
@Suite("HomeViewModel")
struct HomeViewModelTests {
}

---

## Repository tests

Repository tests should cover:

- save
- fetch
- update
- delete
- empty results
- not found cases
- persistence errors
- mapping errors where relevant

Local repository tests:

- use in-memory SwiftData only
- never use the real app container
- never depend on existing user data

Remote repository tests:

- do not use production Supabase
- do not use real user credentials
- prefer mocks or approved integration test setup
- must not require hidden local secrets to pass in CI unless explicitly documented

---

## Service tests

Service tests should cover:

- success result
- failure result
- permission-denied path where relevant
- unavailable/offline path where relevant
- cancellation behavior where relevant

Examples:

- `WeatherServiceTests`
- `AuthServiceTests`
- `ReadingSessionTimerServiceTests`
- `ReachabilityServiceTests`

External/system services should usually be wrapped behind protocols so ViewModels can use fakes in tests.

---

## Mocking and fakes

Use protocol-based mocks and fakes.

Naming:

- `MockBookRepository`
- `FailingBookRepository`
- `FakeWeatherService`
- `InMemoryBookRepository`
- `SpyAuthService`

Use:

- mock for behavior verification
- fake for lightweight working implementation
- spy for recording calls
- failing fake for error paths

Avoid using real network, real Supabase, or real persistent stores in unit tests.

---

## Swift 6 concurrency-safe mocks

Mocks must satisfy Swift 6 strict concurrency.

Allowed patterns:

- `@MainActor final class` mocks for testing `@MainActor` ViewModels
- `actor` mocks for concurrent repository/service tests
- immutable `struct` fakes for simple return values

Examples:

@MainActor
final class MockBookRepository: BookRepositoryProtocol {
    var books: [Book] = []
    var shouldFail = false

    func fetchBooks() async throws -> [Book] {
        if shouldFail {
            throw BookError.fetchFailed
        }
        return books
    }
}

For repositories used across concurrency domains, prefer actor-backed mocks.

Do not use `@unchecked Sendable` in tests unless unavoidable and explained with a comment.

---

## SwiftData in-memory tests

Never use the real app ModelContainer in tests.

Use an in-memory configuration.

Example:

let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
let container = try ModelContainer(
    for: Book.self,
    ReadingSession.self,
    configurations: configuration
)

Rules:

- create fresh containers per test or per isolated suite
- do not share mutable persistent state across tests
- avoid relying on test execution order

---

## Supabase tests

Do not run unit tests against production Supabase.

Do not commit:

- real credentials
- service role keys
- real user tokens
- test account passwords

ViewModel tests must mock repository/service protocols.

Remote repository integration tests require an approved test backend or explicit plan.

---

## Sync tests

Sync-related tests should cover:

- local write succeeds while remote is offline
- pending change is created
- failed upload records error and retry count
- retry succeeds when remote becomes available
- delete creates tombstone
- tombstoned item is hidden from normal UI
- local-wins conflict
- remote-wins conflict
- duplicate upload is avoided after successful sync

Do not modify `SyncCoordinator.swift` without approval.

If sync behavior cannot be tested without touching restricted files, document this in the plan and stop.

---

## Empty-state tests

If a ViewModel or component supports empty states, tests or previews must cover them.

Examples:

- no current book
- no reading goal
- empty reading queue
- no search results
- no notes
- logged-out state
- offline state

For UI-only components, SwiftUI previews may be enough if there is no logic.

For ViewModel-driven empty states, write unit tests.

---

## Stub-only PRs

Stub-only PRs are allowed when clearly scoped.

Minimum tests:

- ViewModel initializes
- stub values are available
- empty-state configuration is possible
- injected services can be replaced with fakes

Do not over-test constants.

Do test that the stub design can support the real implementation later.

---

## Error-state tests

For each meaningful user-facing operation, test at least one failure path.

Verify:

- `errorMessage` is set
- loading state resets
- existing good data is not destroyed unnecessarily
- user can retry if retry is part of the design

Avoid exposing raw technical errors directly to UI state.

---

## UI tests

Use XCTest for UI tests.

UI tests should cover only critical user journeys, such as:

- sign in
- sign out
- add book
- start reading session
- complete reading session
- recover from app launch

Do not use UI tests for every visual component.

Prefer unit tests for ViewModel logic.

---

## Test data

Keep test data small and explicit.

Good:

- one book
- one session
- one failure case
- one empty case

Avoid:

- huge fixture files
- hidden dependencies
- network-loaded fixtures
- order-dependent data

Test fixture strings may be hardcoded.

---

## Checklist

Before finishing a PR, verify:

- [ ] New ViewModel public methods are tested
- [ ] Repository logic is tested
- [ ] Service logic is tested
- [ ] Failure paths are tested
- [ ] Empty states are tested or previewed
- [ ] SwiftData tests use in-memory containers
- [ ] Unit tests do not hit production Supabase
- [ ] Mocks are safe under Swift 6 strict concurrency
- [ ] Tests do not depend on execution order
- [ ] UI tests are limited to critical user journeys
