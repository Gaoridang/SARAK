# Constraints — hard limits that block PRs
# Load this when: before any code change

## Active SwiftLint rules (errors, not warnings)
```yaml
force_unwrapping: error
file_length:
  error: 200
identifier_name:
  min_length: 2
line_length:
  error: 130
```

## Swift 6 strict concurrency
- Build setting: `SWIFT_STRICT_CONCURRENCY = complete`
- All ViewModels: `@MainActor`
- Background work: `async/await`, `Task`, `TaskGroup`
- No `DispatchQueue.main.async` — use `await MainActor.run {}`
- No `@unchecked Sendable` without an explanatory comment

## Architecture constraints (enforced by custom SwiftLint rule)
- Views cannot `import Supabase`
- Views cannot reference any `*Repository` type directly
- Only `Remote*Repository`, `AuthService`, `SyncCoordinator` may import Supabase

## File size
- 200 lines max — hard limit. Split before adding to a file near the limit.

## Concurrency
- All Supabase calls: `async throws` — no semaphores, no `.sync`
- Network-dependent code must handle offline state gracefully

## Commit format (Conventional Commits)
```
feat: add reading session timer
fix: sync conflict resolution on launch
refactor: extract BookRepository protocol
test: add GoalViewModel unit tests
chore: update SwiftLint config
```
