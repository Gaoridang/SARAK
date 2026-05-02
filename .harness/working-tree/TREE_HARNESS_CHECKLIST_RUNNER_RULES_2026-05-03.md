# Working tree — Harness checklist and runner rules
# Snapshot: 2026-05-03
# Purpose: debugging reference — state of relevant files at task start

---

## Current file tree (relevant paths only)
```
.
├── CLAUDE.md                            [EXISTS]
└── .harness/
    ├── constraints.md                   [EXISTS]
    ├── off-limits.md                    [EXISTS]
    ├── testing.md                       [EXISTS]
    ├── logs/
    │   └── agent.log.md                 [EXISTS]
    ├── plans/
    │   └── PLAN_TEMPLATE.md             [EXISTS]
    └── working-tree/
        └── TREE_TEMPLATE.md             [EXISTS]
```

## Key files in scope
| File | Status |
|------|--------|
| `CLAUDE.md` | Exists; top-level agent index |
| `.harness/plans/PLAN_TEMPLATE.md` | Exists; reusable task plan template |
| `.harness/constraints.md` | Exists; always-loaded hard limits |
| `.harness/testing.md` | Exists; test harness rules |
| `.harness/logs/agent.log.md` | Exists; task decision log |

## Current build status
- [ ] Build: not run before docs-only change
- [ ] SwiftLint: not run before docs-only change
- [ ] Tests: not run before docs-only change

## Known issues at snapshot time
None observed in the clean worktree before this task.

## Dependency state
Supabase-swift version: unchanged
SwiftLint version: unchanged

---
## Post-task diff summary
Fill this in after the task is complete.

### Files created
- `.harness/plans/PLAN_HARNESS_CHECKLIST_RUNNER_RULES_2026-05-03.md`
- `.harness/working-tree/TREE_HARNESS_CHECKLIST_RUNNER_RULES_2026-05-03.md`

### Files modified
- `CLAUDE.md`
- `.harness/plans/PLAN_TEMPLATE.md`
- `.harness/constraints.md`
- `.harness/testing.md`
- `.harness/logs/agent.log.md`

### Tests added
- None — documentation-only change.

### Build status after
- Build: not run — documentation-only change
- SwiftLint: not run — documentation-only change
- Tests: not run — documentation-only change
