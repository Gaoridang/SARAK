# Execution plan — [FEATURE NAME]
# Created: [DATE]
# Fill this out BEFORE writing any code. No coding without a plan.

---

## 1. Task summary
What exactly needs to be built or changed? One paragraph max.

## 2. Harness docs loaded
List every `.harness/*.md` file read for this task:
- [ ] architecture.md
- [ ] conventions.md
- [ ] constraints.md
- [ ] sync.md (if touching data layer)
- [ ] testing.md
- [ ] supabase.md (if touching remote)
- [ ] off-limits.md

## 3. Files to create
| File path | Purpose |
|-----------|---------|
| `SARAK/Features/<Feature>/XView.swift` | SwiftUI view |
| `SARAK/Features/<Feature>/XViewModel.swift` | ViewModel |
| `SARAK/Repositories/Protocols/XRepositoryProtocol.swift` | Protocol |
| `SARAK/Repositories/Local/LocalXRepository.swift` | SwiftData impl |
| `SARAK/Repositories/Remote/RemoteXRepository.swift` | Supabase impl |
| `SARAKTests/Unit/XViewModelTests.swift` | Swift Testing unit tests |

## 4. Files to modify
| File path | Change |
|-----------|--------|
| `SARAK/SarakApp.swift` | Register new dependency if needed |

## 5. Architecture check
- [ ] View has zero business logic
- [ ] ViewModel is `@MainActor`
- [ ] Repository accessed via protocol only
- [ ] No `import Supabase` outside allowed files
- [ ] SyncCoordinator NOT touched (or approval obtained)

## 6. Step-by-step execution order
1. Create protocol: `XRepositoryProtocol`
2. Create `LocalXRepository` (SwiftData)
3. Create `RemoteXRepository` (Supabase)
4. Create `XViewModel` — inject protocol
5. Create `XView` — bind to ViewModel
6. Write `XViewModelTests` with mock repository
7. Run build + SwiftLint + tests

## 7. Risks and unknowns
List anything ambiguous. If any item here is blocking, stop and ask user before coding.

## 8. Definition of done
- [ ] Build passes with zero warnings
- [ ] SwiftLint passes with zero errors
- [ ] All new public ViewModel methods have tests
- [ ] Agent log updated
- [ ] Working tree snapshot taken
