# PLAN_HOME_SCREENSHOT_POLISH_2026-05-02

## Goal

Create a repeatable Home screenshot workflow, capture a baseline, apply a focused Home polish pass, and capture the result.

## Scope

- `.harness/visual-review.md`
- `.harness/scripts/capture-home-screenshot.sh`
- `.gitignore`
- `SARAK/Features/Auth/AuthViewModel.swift`
- `SARAK/Features/Home/HomeView.swift`
- `SARAK/Features/Home/Components/CurrentlyReadingCard.swift`
- `SARAK/Features/Home/Components/DailyGoalRing.swift`
- `SARAK/Features/Home/Components/ReadingQueueStrip.swift`

Out of scope: Supabase, sync, data model changes, project file edits, non-Home tabs.

## Implementation

- Add a DEBUG-only `SARAK_SCREENSHOT_AUTHENTICATED=1` auth bypass in `AuthViewModel`.
- Add a script that builds the app into `.harness/derived-data`, launches on iPhone 17, and writes screenshots under `.harness/screenshots/home`.
- Ignore generated screenshot and derived data directories.
- Capture `before`, then polish Home hierarchy and spacing using existing `UIConstants` and localized strings.
- Capture `after` and record findings.

## Verification

1. `bash .harness/scripts/capture-home-screenshot.sh --label before`
2. `bash .harness/scripts/capture-home-screenshot.sh --label after`
3. `swiftlint lint --quiet`
4. `xcodebuild test -project SARAK.xcodeproj -scheme SARAK -destination 'platform=iOS Simulator,name=iPhone 17'`
5. Confirm touched Swift files are under 200 lines and `SARAK.xcodeproj/project.pbxproj` is untouched.
