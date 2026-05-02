# PLAN_HARNESS_TASK_BRANCHES_2026-05-02

## Goal

Make the harness rule explicit: each task must have its own git branch.

## Branch

- [x] Created or switched to a dedicated branch for this task
- Branch name: `harness-task-branches`

## Harness docs loaded

- [x] constraints.md
- [x] plans/PLAN_TEMPLATE.md
- [x] logs/agent.log.md
- [x] CLAUDE.md

## Files to modify

| File path | Change |
|---|---|
| `CLAUDE.md` | Add branch step before planning and hard rule |
| `.harness/constraints.md` | Add Git workflow rule |
| `.harness/plans/PLAN_TEMPLATE.md` | Add branch field/checklist |
| `.harness/logs/agent.log.md` | Add branch field to log template |

## Definition of done

- [x] Branch rule appears in always-loaded harness guidance.
- [x] New plans require branch name.
- [x] Agent log template requires branch name.
