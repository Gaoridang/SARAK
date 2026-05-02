# Constraints — hard limits that block PRs
# Load this when: before any code change
# This file defines non-negotiable engineering limits.

## Purpose

These rules are PR blockers.

If a change violates this file, stop and fix the violation before continuing.
Do not bypass these rules to finish faster.

---

## Git workflow

Each task must have its own git branch.

- Create or switch to a branch dedicated to the current task before code or harness edits.
- Record the branch in the plan and agent log.
- Do not mix unrelated tasks on the same branch.

---

## Active SwiftLint rules

These are errors, not warnings.

| Rule | Limit |
|---|---|
| force_unwrapping | error |
| file_length | 200 lines max |
| identifier_name | minimum length 2 |
| line_length | 130 characters max |

Additional interpretation:

- No force unwraps.
- No implicitly unwrapped optionals unless required by a framework and justified with a comment.
- Split files before they approach 200 lines.
- Do not add large SwiftUI previews to production view files if that pushes the file near the limit.
- Put large previews in separate files named `<ViewName>+Preview.swift`.

---

## Swift 6 strict concurrency

Build setting:

SWIFT_STRICT_CONCURRENCY = complete

Rules:

- All ViewModels must be `@MainActor`.
- Use `async/await` for asynchronous work.
- Use structured concurrency where possible.
- Do not use semaphores.
- Do not use blocking `.sync` calls.
- Do not use `DispatchQueue.main.async` for ViewModel updates.
- Prefer `@MainActor` isolation over manual main-thread switching.
- Use `await MainActor.run` only when updating UI state from a non-main-isolated context.
- Do not use `@unchecked Sendable` without an explanatory comment.

Preferred ViewModel pattern:

- Mark the ViewModel as `@MainActor`.
- Keep published UI state inside the ViewModel.
- Start async work from ViewModel methods.
- Convert thrown errors into user-safe `errorMessage` values.

---

## Architecture constraints

These are enforced by custom SwiftLint rules and code review.

Views must not:

- import Supabase
- reference any `*Repository` type directly
- call Supabase directly
- call SwiftData `ModelContext` directly
- perform network requests
- contain business logic

ViewModels must not:

- import Supabase
- depend on concrete repositories
- depend on concrete services
- access SwiftData `ModelContext` directly
- perform direct network calls

ViewModels may depend on:

- repository protocols
- service protocols
- lightweight injected protocols

Supabase may only be imported by:

- `Remote*Repository`
- `AuthService`
- `SupabaseService`
- `SyncCoordinator`

---

## File size

Maximum file length: 200 lines.

Rules:

- Split files before they hit the limit.
- Prefer small SwiftUI components.
- Prefer separate component files under `Components/`.
- Prefer separate preview files when needed.
- Do not hide multiple unrelated types in one file to avoid creating new files.

Suggested split points:

- Large View → subviews/components
- Large ViewModel → helper service or private extension
- Large repository → mapper/DTO/helper type
- Large test file → separate suite per type or behavior

---

## Strings and constants

No hardcoded user-facing strings in production UI.

Allowed:

- localization keys
- test fixture strings
- SwiftUI preview sample strings
- logger category strings
- temporary stub values inside clearly marked stub-only PRs

Production user-facing text should use localization or string constants according to `conventions.md`.

Table names, API names, and repeated magic values must use constants.

---

## Offline handling

Network-dependent code must handle offline state gracefully.

Rules:

- UI must not block waiting for remote operations.
- Local reads and local writes should continue where possible.
- Remote failures should be converted into safe user-facing errors.
- Offline state should not crash the app.
- Do not assume the network is available.

Expected pattern:

- Local repository handles immediate persistence.
- Remote repository uses `async throws`.
- Sync work is queued when offline.
- ViewModel exposes `errorMessage` or non-blocking status where appropriate.
- Sync behavior follows `sync.md`.

---

## Supabase calls

All Supabase calls must be:

- inside approved files only
- `async throws`
- non-blocking
- free of semaphores
- free of synchronous waiting
- using table constants from `APIConstants.Supabase`

Never disable RLS from app code.

Never bypass user scoping from app code.

---

## Error handling

Do not silently swallow errors.

Rules:

- Avoid `try?`.
- If `try?` is intentionally safe, add a comment explaining why.
- Convert domain errors into `LocalizedError` where useful.
- ViewModels expose `errorMessage: String?` for user-visible failures.
- Do not expose raw technical errors directly to the UI.

---

## Logging

Do not use `print()` in production code.

Use `Logger` from `os`.

Allowed exception:

- `print()` may be used inside `#if DEBUG` blocks only.

Logger categories should match the feature or domain.

---

## Tests

Tests are required for:

- new ViewModel public methods
- repository logic
- service logic
- business logic
- error handling paths
- meaningful edge cases

Stub-only PRs require at minimum:

- smoke tests
- empty-state tests when the UI supports empty states

Use Swift Testing for unit tests.

Use XCTest only for UI tests and critical user journeys.

Do not use the real SwiftData container in tests.
Use an in-memory container.

---

## Xcode project safety

Do not manually edit:

- `SARAK.xcodeproj/project.pbxproj`

This project uses Xcode 16 synchronized folder groups.

Rules:

- Add Swift files directly under `SARAK/`.
- Do not add placeholder files inside `SARAK/`.
- Do not add `README.md`, `.gitkeep`, `.txt`, or other non-source files inside `SARAK/` subfolders.
- Empty folders are acceptable.
- Xcode will auto-discover Swift files.

---

## Commit format

Use Conventional Commits.

Examples:

- `feat: add reading session timer`
- `fix: sync conflict resolution on launch`
- `refactor: extract book repository protocol`
- `test: add goal view model unit tests`
- `chore: update SwiftLint config`

---

## Stop conditions

Stop and ask before continuing if:

- a required change touches an off-limits file
- the architecture boundary is unclear
- two possible implementations have different long-term tradeoffs
- a change requires modifying sync behavior
- a change requires schema, migration, entitlement, or project configuration updates
