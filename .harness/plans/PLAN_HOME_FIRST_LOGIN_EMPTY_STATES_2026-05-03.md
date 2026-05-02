# PLAN_HOME_FIRST_LOGIN_EMPTY_STATES_2026-05-03

## Goal

Add reusable first-login empty states to Home. Home defaults should represent a new user: no current book, no daily goal, no queue, and 0 minutes.

## Branch

- [x] Created or switched to a dedicated branch for this task
- Branch name: `home-first-login-empty-states`

## Harness docs loaded

- [x] constraints.md
- [x] off-limits.md
- [x] architecture.md
- [x] conventions.md
- [x] testing.md
- [x] design.md

## Implementation

- Create a reusable `EmptyStateCard` SwiftUI component under `SARAK/Features/Shared/Components`.
- Update Home stub defaults to empty first-login values.
- Replace Home current-book and daily-goal empty layouts with `EmptyStateCard`.
- Show a queue empty state instead of hiding the section when the queue is empty.
- Add localized queue empty-state copy only; current book and goal strings already exist.

## Verification

- `swiftlint lint --quiet`
- `xcodebuild test -project SARAK.xcodeproj -scheme SARAK -destination 'platform=iOS Simulator,name=iPhone 17'`
- `bash .harness/scripts/capture-home-screenshot.sh --label first-login-empty`
