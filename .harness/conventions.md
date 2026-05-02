# Conventions
# Load this when: naming files, types, variables, adding constants, errors, logs, or display models

## Purpose

This file defines naming and style conventions.

Use this file to keep the codebase predictable for both humans and agents.

---

## File naming

| Kind | Pattern | Example |
|---|---|---|
| View | `<Feature>View` | `BookListView` |
| ViewModel | `<Feature>ViewModel` | `BookListViewModel` |
| SwiftData model | `<Entity>` | `Book`, `ReadingSession` |
| Display model | `<Feature><Entity>DisplayModel` | `HomeBookDisplayModel` |
| Repository protocol | `<Entity>RepositoryProtocol` | `BookRepositoryProtocol` |
| Local repository | `Local<Entity>Repository` | `LocalBookRepository` |
| Remote repository | `Remote<Entity>Repository` | `RemoteBookRepository` |
| Service protocol | `<Name>ServiceProtocol` | `WeatherServiceProtocol` |
| Service implementation | `<Name>Service` | `WeatherService` |
| Extension | `<Type>+<Purpose>` | `Date+Formatting` |
| Constants | `<Domain>Constants` | `APIConstants`, `UIConstants` |
| Error enum | `<Domain>Error` | `SyncError`, `BookError` |
| DTO | `<Entity>RemoteDTO` | `BookRemoteDTO` |
| Test file | `<TypeName>Tests` | `BookRepositoryTests` |
| Preview file | `<ViewName>+Preview` | `HomeView+Preview` |

---

## Type naming

Use `PascalCase` for:

- types
- protocols
- enums
- structs
- classes
- actors

Examples:

- `Book`
- `HomeViewModel`
- `BookRepositoryProtocol`
- `WeatherServiceProtocol`
- `BookRemoteDTO`
- `HomeBookDisplayModel`

Avoid vague type names:

- `Manager`
- `Helper`
- `Data`
- `Info`
- `Thing`
- `Temp`
- `StubBook` in production files

Prefer names that describe responsibility:

- `ReadingSessionTimerService`
- `HomeBookDisplayModel`
- `BookSyncPayload`
- `PendingSyncChange`

---

## Variable and function naming

Use `camelCase` for:

- variables
- functions
- parameters
- computed properties

Booleans should use one of these prefixes:

- `is`
- `has`
- `can`
- `should`
- `needs`

Examples:

- `isLoading`
- `hasQueuedChanges`
- `canStartSession`
- `shouldShowEmptyState`
- `needsSync`

Avoid abbreviations.

Bad:

- `btn`
- `vc`
- `repo`
- `cfg`
- `tmp`

Good:

- `button`
- `viewController`
- `repository`
- `configuration`
- `temporaryValue`

Common allowed short names:

- `id`
- `url`
- `vm` only in tests or very small local scopes
- `x`, `y` only for geometry/math contexts

---

## View naming

Views should describe UI responsibility.

Examples:

- `HomeView`
- `CurrentlyReadingCard`
- `DailyGoalRing`
- `ReadingQueueStrip`
- `ProfileStripView`
- `WeatherHeaderView`

Avoid generic names:

- `CardView`
- `RowView`
- `CustomView`
- `MainView`
- `CommonView`

If a component is feature-specific, keep it inside that feature folder.

If a component is truly reusable across features, place it under a shared UI folder.

---

## ViewModel naming

One screen usually has one ViewModel.

Pattern:

- `<Feature>ViewModel`

Examples:

- `HomeViewModel`
- `BookSearchViewModel`
- `StatsViewModel`
- `GoalViewModel`

Do not create multiple ViewModels for one screen unless there is a clear ownership reason.

Shared app-state ViewModels, such as `AuthViewModel`, must have one owner and be injected into child views.

---

## Display model naming

Use display models when UI data differs from domain data.

Pattern:

- `<Feature><Entity>DisplayModel`

Examples:

- `HomeBookDisplayModel`
- `StatsReadingDisplayModel`
- `ProfileUserDisplayModel`

Use display models when:

- the View only needs a subset of fields
- multiple domain models are combined for one UI component
- formatting is screen-specific
- stub data is used before the real data layer exists
- the domain model is likely to change soon

Avoid temporary names like:

- `StubBook`
- `FakeBook`
- `TempBook`

Acceptable test-only names:

- `MockBookRepository`
- `FakeWeatherService`
- `StubAuthService`

---

## Repository naming

Every persisted data operation must go behind a protocol.

Patterns:

- `<Entity>RepositoryProtocol`
- `Local<Entity>Repository`
- `Remote<Entity>Repository`

Examples:

- `BookRepositoryProtocol`
- `LocalBookRepository`
- `RemoteBookRepository`
- `ReadingSessionRepositoryProtocol`
- `LocalReadingSessionRepository`
- `RemoteReadingSessionRepository`

Repository protocols should describe app-level operations, not database details.

Good:

- `fetchBooks()`
- `saveBook(_:)`
- `deleteBook(id:)`

Avoid:

- `selectFromBooksTable()`
- `upsertRow()`
- `executeQuery()`

---

## Service naming

Services handle non-entity or system/external operations.

Patterns:

- `<Name>ServiceProtocol`
- `<Name>Service`

Examples:

- `WeatherServiceProtocol`
- `WeatherService`
- `AuthServiceProtocol`
- `AuthService`
- `TimerServiceProtocol`
- `ReadingSessionTimerService`
- `ReachabilityServiceProtocol`

Services should be injected into ViewModels through protocols.

Views must not call services directly.

---

## DTO naming

Remote data transfer objects must be clearly marked.

Pattern:

- `<Entity>RemoteDTO`

Examples:

- `BookRemoteDTO`
- `ReadingSessionRemoteDTO`
- `UserProfileRemoteDTO`

DTOs are used inside remote repositories only.

Views and ViewModels must not depend on DTOs.

DTOs should map into domain models or display models before leaving the remote layer.

---

## Constants

No repeated magic values.

Use constants for:

- table names
- API keys names
- notification names
- repeated UI spacing
- repeated durations
- repeated limits
- storage keys
- route/deep link names

Example:

enum APIConstants {
    enum Supabase {
        static let booksTable = "books"
        static let sessionsTable = "reading_sessions"
    }
}

enum UIConstants {
    enum Spacing {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
    }
}

Avoid abbreviations such as `sm`, `md`, `lg` in production constants unless already established across the project.

**Approved exception — `UIConstants.Spacing` and `UIConstants.CornerRadius`:**
The names `sm`, `md`, `lg`, `xl` are used across all View files in this project and are considered established abbreviations. Do not rename them.

---

## User-facing strings

No hardcoded user-facing strings in production UI.

Use one of:

- `Localizable.strings`
- string constants that point to localization keys
- localized string helpers already established in the project

Allowed hardcoded strings:

- test fixture values
- SwiftUI preview sample values
- logger category strings
- localization keys
- temporary stub values in clearly marked stub-only PRs

Examples of user-facing strings:

- button titles
- labels
- empty-state messages
- alerts
- error messages
- tab names
- navigation titles

Examples of non-user-facing strings:

- localization keys
- table names
- logger categories
- test names
- accessibility identifiers

---

## Localization key naming

Use lowercase dot-separated keys.

Pattern:

- `<feature>.<component>.<meaning>`

Examples:

- `home.title`
- `home.currentlyReading.emptyTitle`
- `home.currentlyReading.addBookButton`
- `home.weather.mood.sunny`
- `auth.signIn.button`
- `profile.signOut.button`

Keep keys stable.
Changing keys can break existing localizations.

---

## Error naming

Use domain-specific error enums.

Pattern:

- `<Domain>Error`

Examples:

- `BookError`
- `AuthError`
- `SyncError`
- `WeatherError`

Errors that may reach the UI should conform to `LocalizedError`.

Example:

enum BookError: LocalizedError {
    case notFound(id: UUID)
    case saveFailed(underlying: Error)

    var errorDescription: String? {
        switch self {
        case .notFound:
            return String(localized: "book.error.notFound")
        case .saveFailed:
            return String(localized: "book.error.saveFailed")
        }
    }
}

Do not expose raw technical error messages directly to users.

---

## Error handling

Never silently swallow errors.

Avoid:

- `try?`
- empty `catch`
- generic `"Something went wrong"` everywhere

If `try?` is intentionally safe, add a comment:

- `// safe: failure only disables optional preview data`

ViewModels should convert errors into user-safe `errorMessage`.

Repositories and services should throw meaningful domain errors where possible.

---

## Logging

Use `Logger` from `os`.

Do not use `print()` in production code.

Pattern:

import os

private let logger = Logger(
    subsystem: "com.app.readingtracker",
    category: "Books"
)

Logger category should match the feature or domain.

Examples:

- `Books`
- `Home`
- `Auth`
- `Sync`
- `Weather`
- `Sessions`

Allowed:

- `print()` inside `#if DEBUG` only

---

## Empty folders

Never create placeholder files inside `SARAK/`.

Do not create:

- `README.md`
- `.gitkeep`
- `.txt`
- placeholder JSON files

Reason:

Xcode 16 synchronized groups auto-bundle files under `SARAK/`, which may create duplicate-resource or invalid-resource build errors.

Empty folders are fine.

Add the folder when a real Swift file lands.

---

## SwiftUI previews

Keep previews small.

If previews make a file approach the 200-line limit, move them to:

- `<ViewName>+Preview.swift`

Preview sample strings and sample data may be hardcoded.

Preview-only fake services should be named clearly:

- `PreviewWeatherService`
- `PreviewBookRepository`

Do not use production Supabase, production network calls, or real persistent stores in previews.

---

## Test naming

Test files:

- `<TypeName>Tests.swift`

Suites:

- `@Suite("<TypeName>")`

Test names should describe behavior.

Good:

- `shows error when save fails`
- `returns empty state when no current book`
- `does not start session without selected book`

Avoid:

- `test1`
- `works`
- `success`
- `failure`

Mock and fake names:

- `MockBookRepository`
- `FailingBookRepository`
- `FakeWeatherService`
- `InMemoryBookRepository`

---

## Checklist

Before finishing a PR, verify:

- [ ] File and type names follow patterns
- [ ] No vague names like `Manager`, `Helper`, or `Temp`
- [ ] No hardcoded user-facing strings in production UI
- [ ] Constants are used for repeated magic values
- [ ] Localization keys are stable and dot-separated
- [ ] Errors are domain-specific where useful
- [ ] Logging uses `Logger`, not production `print()`
- [ ] DTOs do not leak into Views or ViewModels
- [ ] Display models are used when UI data differs from domain data
- [ ] No placeholder files were added inside `SARAK/`
