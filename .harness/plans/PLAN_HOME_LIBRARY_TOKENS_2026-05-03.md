# Home and Library Token Refresh Plan

- **Date:** 2026-05-03
- **Branch:** `refine-home-library-tokens`
- **Owner:** Codex
- **Last update:** 2026-05-03 22:18 KST
- **Scope:** Refresh Library UI with existing design tokens and remove non-functional top Home controls.

## Checklist

- [x] Read required harness docs: `CLAUDE.md`, constraints, off-limits, design quick guide.
- [x] Create dedicated task branch.
- [x] Snapshot relevant tree and create task log.
- [x] Inspect Home and Library SwiftUI components.
- [x] Update Library view and row treatment with tokenized spacing, colors, typography, and surfaces.
- [x] Remove meaningless onboarding progress, settings icon, and profile icon from Home header.
- [x] Capture screenshots and refine UI based on visible result.
- [x] Run build or relevant verification.
- [x] Update task log and checklist before handoff.

## Notes

- Avoid off-limits files.
- Keep production strings in `StringConstants`.
- Prefer existing `UIConstants` tokens and shared compact styles.
