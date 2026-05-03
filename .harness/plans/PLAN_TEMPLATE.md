# Execution plan — [FEATURE NAME]
# Created: [DATE]
# Fill this out BEFORE writing any code. No coding without a plan.

---

## 1. Task summary
What exactly needs to be built or changed? One paragraph max.

## 2. Branch

- [ ] Created or switched to a dedicated branch for this task
- Branch name: `<branch-name>`

## 3. Harness docs loaded
List every `.harness/*.md` file read for this task:
- [ ] constraints.md
- [ ] off-limits.md
- [ ] quick guide used: `<file>`
- [ ] full guide loaded (if needed): `<file>`

## 4. Task checklist (handoff-friendly)
Create this checklist before implementation starts.
Keep it current so another agent can continue without re-discovery.

### Status legend
- [ ] Not started
- [-] In progress
- [x] Done
- [!] Blocked

### Execution checklist
- [ ] Inspect relevant existing code
- [ ] Read required harness docs
- [ ] Create or switch to the dedicated task branch
- [ ] Snapshot relevant working tree state
- [ ] Implement scoped changes
- [ ] Add or update tests when required
- [ ] Run build, SwiftLint, and tests without waiting for separate user approval
- [ ] Update task log file (`.harness/logs/YYYY-MM-DD/<TASK_SLUG>.md`)
- [ ] Review final diff against off-limits and project safety rules

### Progress table (required for handoff)
| Item | Status (`[ ]`/`[-]`/`[x]`/`[!]`) | Owner | Last update (UTC) | Notes |
|---|---|---|---|---|
| Example: Create HomeViewModel | [ ] | agent-name | YYYY-MM-DD HH:MM | |

## 5. Files to create
| File path | Purpose |
|-----------|---------|
| `SARAK/Features/<Feature>/XView.swift` | SwiftUI view |
| `SARAK/Features/<Feature>/XViewModel.swift` | ViewModel |
| `SARAK/Repositories/Protocols/XRepositoryProtocol.swift` | Protocol |
| `SARAK/Repositories/Local/LocalXRepository.swift` | SwiftData impl |
| `SARAK/Repositories/Remote/RemoteXRepository.swift` | Supabase impl |
| `SARAKTests/Unit/XViewModelTests.swift` | Swift Testing unit tests |

## 6. Files to modify
| File path | Change |
|-----------|--------|
| `SARAK/SARAKApp.swift` | Register new dependency if needed |

## 7. Architecture check
- [ ] View has zero business logic
- [ ] ViewModel is `@MainActor`
- [ ] Repository accessed via protocol only
- [ ] No `import Supabase` outside allowed files
- [ ] SyncCoordinator NOT touched (or approval obtained)

## 8. Step-by-step execution order
- [ ] Create protocol: `XRepositoryProtocol`
- [ ] Create `LocalXRepository` (SwiftData)
- [ ] Create `RemoteXRepository` (Supabase)
- [ ] Create `XViewModel` — inject protocol
- [ ] Create `XView` — bind to ViewModel
- [ ] Write `XViewModelTests` with mock repository
- [ ] Run build + SwiftLint + tests

## 9. Risks and unknowns
List anything ambiguous. If any item here is blocking, stop and ask user before coding.

## 10. Handoff notes (required)
- Current step:
- Next immediate step:
- Blockers/decisions pending user input:
- Commands already run:

## 11. Definition of done
- [ ] Build passes with zero warnings
- [ ] SwiftLint passes with zero errors
- [ ] All new public ViewModel methods have tests
- [ ] Plan checklist is up to date
- [ ] Task log updated
- [ ] Working tree snapshot taken
