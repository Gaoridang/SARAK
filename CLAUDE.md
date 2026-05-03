# CLAUDE.md
# Reading Tracker iOS — Agent Index

This file is a concise router, not a manual.
Load only the minimum files needed for the current task.

## Stack

Swift 6 · SwiftUI · SwiftData · Supabase v2+ · Swift Testing · SPM · Xcode 16 synchronized groups

## Token budget policy (read this first)

- **Do not recursively read `.harness/`**.
- **Never read historical artifacts by default**: `.harness/logs/archive/`, `.harness/plans/`, `.harness/working-tree/`, `.harness/audits/`, `.harness/tasks/`.
- Read at most:
  1. `CLAUDE.md`
  2. `.harness/constraints.md`
  3. `.harness/off-limits.md`
  4. One `quick` guide from the table below
  5. The paired full guide only when required
- Only open additional files when the task explicitly requires them.
- When checking prior work, read only the single most relevant file, not entire folders.

## Always load first

- `.harness/constraints.md`
- `.harness/off-limits.md`

## Load exactly one quick guide first (then full guide only if needed)

| Task | Read |
|---|---|
| Adding features, screens, ViewModels, repositories, services | `.harness/quick/architecture.quick.md` → `.harness/architecture.md` |
| Naming files, types, variables, constants, errors | `.harness/quick/conventions.quick.md` → `.harness/conventions.md` |
| Writing or reviewing tests | `.harness/quick/testing.quick.md` → `.harness/testing.md` |
| Touching auth, Supabase, remote repositories, DTOs | `.harness/quick/supabase.quick.md` → `.harness/supabase.md` |
| Touching writes, offline behavior, repositories, sync | `.harness/quick/sync.quick.md` → `.harness/sync.md` |
| Styling views, components, or visual treatments | `.harness/quick/design.quick.md` → `.harness/design.md` |

## Before coding

1. Inspect relevant existing code.
2. Read only required harness docs from the list above.
3. Create or switch to a dedicated git branch for this task.
4. Write a plan to `.harness/plans/PLAN_<FEATURE>_<YYYY-MM-DD>.md`.
5. Include a handoff-friendly task checklist in the plan (with explicit status markers, owner, and last-update time) so another agent can track and continue the work.
6. Keep the checklist updated as task steps are completed.
7. Snapshot relevant tree/state to `.harness/working-tree/TREE_<FEATURE>_<YYYY-MM-DD>.md`.
8. Create or update a per-task log file: `.harness/logs/YYYY-MM-DD/<TASK_SLUG>.md` (use `.harness/logs/TEMPLATE_TASK_LOG.md`).

## Hard rules

- No force unwraps.
- No `import Supabase` in Views or ViewModels.
- No hardcoded user-facing strings in production UI.
- All ViewModels are `@MainActor`.
- ViewModels depend on injected protocols, not concrete implementations.
- Views do not call repositories, services, SwiftData, Supabase, or networking.
- Keep files under 200 lines.
- Tests are required for new ViewModel methods, repository logic, services, and business logic.
- Never touch off-limits files without explicit user approval.
- Never manually edit `SARAK.xcodeproj/project.pbxproj`.
- Never add placeholder files such as `README.md` or `.gitkeep` inside `SARAK/`.
- Each task must have its own git branch.

## Architecture summary

Default flow:

View → ViewModel → injected Protocol → Repository or Service

`SyncCoordinator` is the only component allowed to coordinate local and remote stores together.

Shared app state must have one owner. For example, `RootView` may own `AuthViewModel`; child views must receive it, not create duplicates.

## Xcode 16 note

Files under `SARAK/` are auto-discovered by synchronized groups.

- Add Swift files directly.
- Do not hand-edit the project file.
- Do not place non-source files inside `SARAK/`.

## Stuck protocol

If blocked:

1. Stop.
2. State the ambiguity.
3. Propose two options with tradeoffs.
4. Wait for user approval.

Do not bypass the harness to finish faster.

## Harness compliance audit mode

When asked to fix existing code against the harness:

1. Do not immediately refactor.
2. Create `.harness/audits/AUDIT_<AREA>_<YYYY-MM-DD>.md`.
3. List inspected files, violations, severity, proposed fixes, off-limits risk, and PR slices.
4. Wait for approval before code changes.

## Before commit

- Re-read the plan.
- Confirm the plan checklist reflects current task status.
- Check changed files against off-limits.
- Run build.
- Run SwiftLint.
- Run tests.
- Do not wait for separate user approval before running local build, SwiftLint, or test commands that are already part of the task.
- Confirm no manual `project.pbxproj` edits.
- Confirm no placeholder files inside `SARAK/`.
- Confirm agent log was updated.

## Commit format

Use Conventional Commits.

Examples:

- `feat: add reading session timer`
- `fix: remove duplicate auth view model ownership`
- `refactor: inject book repository protocol`
- `test: add goal view model tests`
- `chore: update harness docs`
