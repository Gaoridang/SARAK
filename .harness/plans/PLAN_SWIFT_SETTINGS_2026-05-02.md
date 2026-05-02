# PLAN_SWIFT_SETTINGS_2026-05-02

## Goal

Resolve the harness mismatch discovered during project analysis:

- Harness expects Swift 6.
- Harness expects complete strict concurrency.
- Current Xcode build settings show `SWIFT_VERSION = 5.0`.
- `SWIFT_STRICT_CONCURRENCY` was not found in `SARAK.xcodeproj/project.pbxproj`.

## Approval requirement

Implementation likely requires editing `SARAK.xcodeproj/project.pbxproj`.

That file is off-limits under `.harness/off-limits.md`, so implementation must stop until the user explicitly approves the project settings edit.

## Intended change after approval

- Set the SARAK app and test targets to Swift 6.
- Set strict concurrency checking to complete if Xcode does not infer it from existing settings.
- Re-run build, SwiftLint, and tests.

## Out of scope

- No source refactors.
- No package changes.
- No manual project edits without approval.
