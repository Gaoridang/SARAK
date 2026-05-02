# PLAN: SwiftLint Setup
**Date:** 2026-05-02  
**Feature:** SwiftLint configuration

## Goal
Add `.swiftlint.yml` to the project root to enforce the hard rules defined in `constraints.md`.

## Steps
1. Read `CLAUDE.md` and `constraints.md` — done
2. Read `off-limits.md` — done
3. Inspect existing Swift source files (3 files) for anticipated violations — done
4. Create `.swiftlint.yml` with rules matching `constraints.md`
5. Run `swiftlint lint --config .swiftlint.yml`
6. Fix any **errors** found (not warnings)
7. Append entry to `.harness/logs/agent.log.md`

## Files to create
- `.swiftlint.yml` (project root)

## Files NOT to touch
- `SARAK.xcodeproj/` (off-limits)
- `SARAKTests/`, `SARAKUITests/` (excluded from lint)
- Any `.harness/` file except `agent.log.md`

## Constraints applied
- `force_unwrapping: error`
- `file_length: error 200`
- `line_length: error 130`
- `identifier_name: min_length 2`
- Custom rule: no bare `print()` statements
