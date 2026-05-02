# Execution plan — Harness checklist and runner rules
# Created: 2026-05-03
# Fill this out BEFORE writing any code. No coding without a plan.

---

## 1. Task summary
Update the agent and harness documentation so every task plan starts with a trackable checklist before work begins, and local lint/test verification runs without waiting for separate user approval.

## 2. Branch

- [x] Created or switched to a dedicated branch for this task
- Branch name: `harness-checklist-runner-rules`

## 3. Harness docs loaded
List every `.harness/*.md` file read for this task:
- [ ] architecture.md
- [ ] conventions.md
- [x] constraints.md
- [ ] sync.md (if touching data layer)
- [x] testing.md
- [ ] supabase.md (if touching remote)
- [x] off-limits.md
- [x] plans/PLAN_TEMPLATE.md
- [x] working-tree/TREE_TEMPLATE.md

## 4. Task checklist
- [x] Inspect existing `CLAUDE.md` guidance
- [x] Inspect plan and working-tree templates
- [x] Inspect testing and constraints harness rules
- [x] Update `CLAUDE.md`
- [x] Update `.harness/plans/PLAN_TEMPLATE.md`
- [x] Update `.harness/constraints.md`
- [x] Update `.harness/testing.md`
- [x] Add working-tree snapshot
- [x] Append agent log entry
- [x] Verify documentation references

## 5. Files to create
| File path | Purpose |
|-----------|---------|
| `.harness/plans/PLAN_HARNESS_CHECKLIST_RUNNER_RULES_2026-05-03.md` | Plan for this harness documentation update |
| `.harness/working-tree/TREE_HARNESS_CHECKLIST_RUNNER_RULES_2026-05-03.md` | Starting snapshot and final summary |

## 6. Files to modify
| File path | Change |
|-----------|--------|
| `CLAUDE.md` | Require checklist-first plans and clarify lint/test approval policy |
| `.harness/plans/PLAN_TEMPLATE.md` | Add a required task checklist near the top of every plan |
| `.harness/constraints.md` | Clarify that local lint/test/build do not need separate approval |
| `.harness/testing.md` | Clarify tests should be run without waiting for separate approval |
| `.harness/logs/agent.log.md` | Record this harness documentation decision |

## 7. Architecture check
- [x] View has zero business logic
- [x] ViewModel is `@MainActor`
- [x] Repository accessed via protocol only
- [x] No `import Supabase` outside allowed files
- [x] SyncCoordinator NOT touched (or approval obtained)

## 8. Step-by-step execution order
- [x] Create dedicated branch
- [x] Create this task plan before documentation edits
- [x] Create working-tree snapshot
- [x] Patch `CLAUDE.md`
- [x] Patch `.harness/plans/PLAN_TEMPLATE.md`
- [x] Patch `.harness/constraints.md`
- [x] Patch `.harness/testing.md`
- [x] Append log entry
- [x] Review diff

## 9. Risks and unknowns
No source code, project file, Supabase, sync, or data-layer changes are expected.

## 10. Definition of done
- [x] Plan template requires a trackable checklist before implementation
- [x] `CLAUDE.md` tells agents to make checklists before starting tasks
- [x] Harness docs say local lint/test/build do not require separate user approval
- [x] Agent log updated
- [x] Working tree snapshot taken
