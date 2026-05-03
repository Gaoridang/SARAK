# Task Log

- **Date:** 2026-05-03
- **Task:** Home and Library token refresh
- **Plan file:** `.harness/plans/PLAN_HOME_LIBRARY_TOKENS_2026-05-03.md`
- **Branch:** `refine-home-library-tokens`
- **Harness docs read:** `CLAUDE.md`, `.harness/constraints.md`, `.harness/off-limits.md`, `.harness/quick/design.quick.md`

## Decision Entries

### [12:55 UTC] Decision
- **Decision:** Scope the work to Home header cleanup and Library visual token alignment.
- **Why:** User requested removal of meaningless Home top controls and Library token refresh.
- **Constraints applied:** No hardcoded production strings, no off-limits files, use existing design tokens.
- **Files modified:** `HomeHeaderView.swift`, `LibraryView.swift`, `BookRowCard.swift`, token/string constants, debug tab screenshot hook.
- **Tests written/run:** `xcodebuild build`, `swiftlint --no-cache`, `xcodebuild test`.
- **Outcome:** Completed.
- **Notes:** Pre-existing untracked directories `UI/` and `reading tracker 3/` will be left untouched.

### [13:18 UTC] Decision
- **Decision:** Add a DEBUG-only `SARAK_SCREENSHOT_INITIAL_TAB` hook to select Library for simulator screenshots.
- **Why:** The app already gates auth screenshots with a DEBUG environment flag, and simulator automation did not provide a tap primitive.
- **Constraints applied:** DEBUG-only behavior; normal app launch defaults to Home.
- **Files modified:** `SARAK/Features/Root/MainTabView.swift`.
- **Tests written/run:** `xcodebuild -scheme SARAK -destination 'platform=iOS Simulator,name=iPhone 17,OS=26.2' build`; `swiftlint --no-cache`; `xcodebuild -scheme SARAK -destination 'platform=iOS Simulator,name=iPhone 17,OS=26.2' test`.
- **Outcome:** Completed.
- **Notes:** Screenshots saved under `.harness/screenshots/home_library_tokens_home_final.png` and `.harness/screenshots/home_library_tokens_library.png`.
