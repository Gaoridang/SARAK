# CLAUDE.md
# Reading Tracker iOS — Agent Index
# This file is a map, not a manual. Read the relevant doc before acting.

## Stack
- Swift 6 · SwiftUI · SwiftData · Supabase v2+ · Swift Testing · SPM

## Before every task
1. Read the relevant `.harness/` doc for the domain you're touching.
2. Write an execution plan → `.harness/plans/PLAN_<FEATURE>_<DATE>.md`
3. Snapshot the working tree → `.harness/working-tree/TREE_<FEATURE>_<DATE>.md`
4. Log your decision → `.harness/logs/agent.log.md` (append only)

## Harness docs (load only what you need)
| Domain              | Doc                              |
|---------------------|----------------------------------|
| Architecture        | `.harness/architecture.md`       |
| Naming conventions  | `.harness/conventions.md`        |
| Hard constraints    | `.harness/constraints.md`        |
| Sync strategy       | `.harness/sync.md`               |
| Testing rules       | `.harness/testing.md`            |
| Supabase usage      | `.harness/supabase.md`           |
| Off-limits files    | `.harness/off-limits.md`         |

## Hard rules (always active, no exceptions)
- No force unwraps `!`
- No `import Supabase` in Views
- No hardcoded strings — use constants
- Swift 6 strict concurrency — `@MainActor` on all ViewModels
- 200-line file limit — split before adding
- Tests required for every new feature
- Never touch off-limits files without explicit user approval

## Stuck protocol
Stop. State the ambiguity. Propose two options with tradeoffs. Wait for approval.
Never violate architecture boundaries to finish faster.

## PR checklist
- [ ] Build passes
- [ ] SwiftLint passes (zero errors)
- [ ] Tests written and passing
- [ ] Plan file created
- [ ] Agent log updated
- [ ] No off-limits files modified
