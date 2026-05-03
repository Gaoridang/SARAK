# Task Log

- **Date:** 2026-05-03
- **Task:** Supabase login sync
- **Plan file:** `.harness/plans/PLAN_SUPABASE_LOGIN_SYNC_2026-05-03.md`
- **Branch:** `feat/supabase-login-sync`
- **Harness docs read:** `CLAUDE.md`, `.harness/constraints.md`, `.harness/off-limits.md`, `.harness/quick/supabase.quick.md`, `.harness/supabase.md`, `.harness/quick/architecture.quick.md`, `.harness/architecture.md`, `.harness/quick/sync.quick.md`, `.harness/sync.md`

## Decision Entries

### [13:50 UTC] Decision
- **Decision:** Implement local-first login sync instead of wiring logged-in views directly to remote repositories.
- **Why:** Existing app architecture uses SwiftData as the UI source of truth and pending changes for offline writes.
- **Constraints applied:** Supabase stays out of Views/ViewModels; only `SyncCoordinator` coordinates local and remote stores.
- **Files modified:** Auth flow, root wiring, sync protocols, local repositories, `SyncCoordinator`, schema SQL, tests.
- **Tests written/run:** `AuthViewModelTests`, `LocalReadingRepositoryTests`; full `xcodebuild test`; SwiftLint.
- **Outcome:** Completed
- **Notes:** User selected local-first sync and schema update for current book fields.

### [14:04 UTC] Decision
- **Decision:** Split remote import into `SyncCoordinator+RemoteImport.swift`.
- **Why:** Keep `SyncCoordinator.swift` below SwiftLint file-length threshold after adding login sync.
- **Constraints applied:** `SyncCoordinator` remains the only local/remote coordination owner.
- **Files modified:** `SARAK/Services/SyncCoordinator.swift`, `SARAK/Services/SyncCoordinator+RemoteImport.swift`.
- **Tests written/run:** `xcodebuild test -project SARAK.xcodeproj -scheme SARAK -destination 'platform=iOS Simulator,name=iPhone 17,OS=26.2' -derivedDataPath .harness/derived-data`; `swiftlint lint --no-cache`.
- **Outcome:** Completed
- **Notes:** SwiftLint still reports one warning in pre-existing UI work: `CurrentlyReadingCard.swift` function body length.
