# Execution plan — MVP Reading Interactions + Supabase Schema
# Created: 2026-05-03

---

## 1. Task summary
Build the first real reading-tracker data slice: local-first book, daily goal, and reading-session interactions backed by SwiftData, plus typed Supabase remote repositories and a generated SQL schema/RLS file for manual database setup.

## 2. Branch

- [x] Created or switched to a dedicated branch for this task
- Branch name: `feat/mvp-reading-interactions-supabase`

## 3. Harness docs loaded
- [x] architecture.md
- [x] conventions.md
- [x] constraints.md
- [x] sync.md
- [x] testing.md
- [x] supabase.md
- [x] off-limits.md
- [x] CLAUDE.md

## 4. Task checklist
- [x] Inspect relevant existing code
- [x] Read required harness docs
- [x] Create or switch to the dedicated task branch
- [x] Snapshot relevant working tree state
- [x] Generate Supabase SQL schema/RLS file outside `SARAK/`
- [x] Add SwiftData models and pending sync model
- [x] Add repository protocols and local SwiftData implementations
- [x] Add remote Supabase DTOs and repositories
- [x] Add Home, Library, Stats, Add Book, Goal, and Session interactions
- [x] Wire SwiftData `ModelContainer` and dependency factories
- [x] Request approval before editing `SARAK/Services/SyncCoordinator.swift`
- [x] Add or update tests
- [x] Run build, SwiftLint, and tests
- [x] Update agent log with final status
- [x] Review final diff against off-limits and project safety rules

## 5. Files to create
| File path | Purpose |
|-----------|---------|
| `.harness/supabase/SCHEMA_MVP_READING_2026-05-03.sql` | Manual Supabase schema/RLS setup |
| `SARAK/Models/Book.swift` | SwiftData book model |
| `SARAK/Models/ReadingSession.swift` | SwiftData reading-session model |
| `SARAK/Models/DailyGoal.swift` | SwiftData daily goal model |
| `SARAK/Models/PendingSyncChange.swift` | Durable offline sync queue model |
| `SARAK/Repositories/Protocols/*RepositoryProtocol.swift` | Repository boundaries for ViewModels |
| `SARAK/Repositories/Local/Local*Repository.swift` | SwiftData local source-of-truth implementations |
| `SARAK/Repositories/Remote/Remote*Repository.swift` | Supabase remote implementations and DTOs |
| `SARAK/Features/Library/LibraryViewModel.swift` | Library state and actions |
| `SARAK/Features/Stats/StatsViewModel.swift` | Stats state and calculations |
| `SARAK/Features/Books/AddBookView.swift` | Add-book interaction sheet |
| `SARAK/Features/Goals/SetGoalView.swift` | Daily-goal interaction sheet |
| `SARAKTests/*RepositoryTests.swift` | Local repository tests |
| `SARAKTests/*ViewModelTests.swift` | Interaction ViewModel tests |

## 6. Files to modify
| File path | Change |
|-----------|--------|
| `SARAK/SARAKApp.swift` | Register SwiftData model container |
| `SARAK/Features/Home/HomeViewModel.swift` | Replace stubs with repository-backed display state |
| `SARAK/Features/Home/HomeView.swift` | Trigger add-book, set-goal, and session interactions |
| `SARAK/Features/Root/MainTabView.swift` | Inject shared repository dependencies |
| `SARAK/Features/Library/LibraryView.swift` | Render real library data |
| `SARAK/Features/Stats/StatsView.swift` | Render real reading stats |
| `SARAK/Constants/StringConstants.swift` | Add localized keys for new UI |
| `SARAK/Resources/Localizable.strings` | Add localized Korean strings |
| `SARAK/Services/SyncCoordinator.swift` | Sync pending changes, only after explicit approval |

## 7. Architecture check
- [x] Views have zero business logic
- [x] ViewModels are `@MainActor`
- [x] ViewModels depend on protocols only
- [x] No `import Supabase` outside allowed files
- [x] Local write succeeds before remote sync
- [x] Pending sync changes are durable
- [x] SyncCoordinator not touched until approval is obtained

## 8. Step-by-step execution order
- [x] Generate SQL schema/RLS file
- [x] Add models and enums under `SARAK/Models`
- [x] Add repository protocols
- [x] Add local SwiftData repositories
- [x] Add remote Supabase DTOs/repositories
- [x] Add dependency factory wiring
- [x] Update Home/Library/Stats ViewModels and Views
- [x] Add tests for repositories and ViewModels
- [x] Stop and request SyncCoordinator approval before sync implementation
- [x] Run SwiftLint, build, and tests

## 9. Risks and unknowns
- Existing compact design changes were already uncommitted when this branch was created; they are preserved and must not be reverted.
- `SyncCoordinator.swift` is off-limits and required for complete background upload/pull sync.
- Generated Supabase SQL is not executed by Codex; the user will run it manually.

## 10. Definition of done
- [x] App builds
- [x] SwiftLint passes with zero errors
- [x] Full test suite passes
- [x] SQL schema file exists and uses user-scoped RLS
- [x] New interactions work locally before remote sync
- [x] Plan checklist is current
- [x] Agent log updated
- [x] No protected file was modified without approval
