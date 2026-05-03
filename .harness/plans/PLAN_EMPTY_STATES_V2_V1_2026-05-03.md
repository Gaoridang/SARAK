# Home V2 and Library V1 Empty States Plan

- **Date:** 2026-05-03
- **Branch:** `implement-empty-states-v2-v1`
- **Owner:** Codex
- **Last update:** 2026-05-03 22:41 KST
- **Scope:** Implement design handoff selected empty states: Home V2 and Library V1.

## Checklist

- [x] Read required docs: `CLAUDE.md`, constraints, off-limits, design quick guide.
- [x] Inspect design handoff and current Home/Library empty-state code.
- [x] Create dedicated task branch.
- [x] Snapshot relevant tree and create task log.
- [x] Add localized strings and missing UI tokens.
- [x] Implement Home V2 empty onboarding component.
- [x] Implement Library V1 empty component.
- [x] Wire empty-state selection into Home and Library.
- [x] Capture screenshots and refine UI.
- [x] Run build, SwiftLint, and tests.
- [x] Update task log and checklist before handoff.

## Decisions

- Use Korean localized copy.
- Avoid fake user identity; use a generic welcome.
- Keep Library `Scan ISBN` visual-only/disabled in this pass.
- Preserve existing populated-state behavior and prior uncommitted token work.
