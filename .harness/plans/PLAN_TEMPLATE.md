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
- [ ] architecture.md
- [ ] conventions.md
- [ ] constraints.md
- [ ] sync.md (if touching data layer)
- [ ] testing.md
- [ ] supabase.md (if touching remote)
- [ ] off-limits.md

## 4. Task checklist
Create this checklist before implementation starts.
Keep it current so another agent can understand what is done, what is in progress, and what remains.

- [ ] Inspect relevant existing code
- [ ] Read required harness docs
- [ ] Create or switch to the dedicated task branch
- [ ] Snapshot relevant working tree state
- [ ] Implement scoped changes
- [ ] Add or update tests when required
- [ ] Run build, SwiftLint, and tests without waiting for separate user approval
- [ ] Update agent log
- [ ] Review final diff against off-limits and project safety rules

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
| `SARAK/SarakApp.swift` | Register new dependency if needed |

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

## 10. Definition of done
- [ ] Build passes with zero warnings
- [ ] SwiftLint passes with zero errors
- [ ] All new public ViewModel methods have tests
- [ ] Plan checklist is up to date
- [ ] Agent log updated
- [ ] Working tree snapshot taken
