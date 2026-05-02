# Conventions
# Load this when: naming files, types, variables, adding constants or errors

## File naming
| Kind                | Pattern                    | Example                    |
|---------------------|----------------------------|----------------------------|
| View                | `<Feature>View`            | `BookListView`             |
| ViewModel           | `<Feature>ViewModel`       | `BookListViewModel`        |
| SwiftData model     | `<Entity>`                 | `Book`, `ReadingSession`   |
| Repository protocol | `<Entity>RepositoryProtocol` | `BookRepositoryProtocol` |
| Local repository    | `Local<Entity>Repository`  | `LocalBookRepository`      |
| Remote repository   | `Remote<Entity>Repository` | `RemoteBookRepository`     |
| Service             | `<Name>Service`            | `AuthService`              |
| Extension           | `<Type>+<Purpose>`         | `Date+Formatting`          |
| Constants           | `<Domain>Constants`        | `APIConstants`             |
| Error enum          | `<Domain>Error`            | `SyncError`, `BookError`   |

## Variable conventions
- `camelCase` for variables/functions/parameters
- `PascalCase` for types, protocols, enums
- Booleans: `is`, `has`, `can`, `should` prefix
- Never abbreviate: `btn` → `button`, `vc` → wrong pattern (no UIKit)

## Constants — no hardcoded strings
```swift
enum APIConstants {
    enum Supabase {
        static let booksTable = "books"
        static let sessionsTable = "reading_sessions"
    }
}
enum UIConstants {
    enum Spacing {
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
    }
}
```

## Error handling
```swift
enum BookError: LocalizedError {
    case notFound(id: UUID)
    case saveFailed(underlying: Error)
    var errorDescription: String? { ... }
}
```
- Never swallow with `try?` without a `// safe: <reason>` comment.
- ViewModels expose: `@Published var errorMessage: String?`

## Logging (no print())
```swift
import os
private let logger = Logger(subsystem: "com.app.readingtracker", category: "Books")
logger.info("Book added: \(book.id)")
```
- `print()` only inside `#if DEBUG` blocks.
- Logger categories match feature names.
