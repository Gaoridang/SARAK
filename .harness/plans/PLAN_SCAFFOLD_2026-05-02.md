# Execution plan — Xcode Project Scaffold
# Created: 2026-05-02

---

## 1. Task summary
Create the SARAK/ source directory structure and stub Swift files. No feature code — structure only. Establish folder hierarchy for Features, Repositories, Services, Models, Constants, and Resources. Create AuthService, SyncCoordinator, APIConstants, UIConstants, and Localizable.strings stubs. Add README.md placeholders to all empty Features/ subfolders so Git tracks them.

## 2. Harness docs loaded
- [x] architecture.md
- [x] conventions.md
- [ ] constraints.md (not needed — no code logic)
- [ ] sync.md (not touching data layer)
- [ ] testing.md (no tests — scaffold only)
- [ ] supabase.md (not touching remote)
- [x] off-limits.md

## 3. Files to create
| File path | Purpose |
|-----------|---------|
| `SARAK/Features/BookSearch/README.md` | Git placeholder |
| `SARAK/Features/Session/README.md` | Git placeholder |
| `SARAK/Features/Progress/README.md` | Git placeholder |
| `SARAK/Features/Goals/README.md` | Git placeholder |
| `SARAK/Features/Notes/README.md` | Git placeholder |
| `SARAK/Features/Stats/README.md` | Git placeholder |
| `SARAK/Features/Auth/README.md` | Git placeholder |
| `SARAK/Features/Social/README.md` | Git placeholder |
| `SARAK/Repositories/Protocols/README.md` | Git placeholder |
| `SARAK/Repositories/Local/README.md` | Git placeholder |
| `SARAK/Repositories/Remote/README.md` | Git placeholder |
| `SARAK/Services/AuthService.swift` | Auth stub |
| `SARAK/Services/SyncCoordinator.swift` | Sync stub (restricted) |
| `SARAK/Constants/APIConstants.swift` | API constant enum |
| `SARAK/Constants/UIConstants.swift` | UI constant enum |
| `SARAK/Resources/Localizable.strings` | Localization strings |

## 4. Files to modify
None — scaffold only.

## 5. Architecture check
- [x] No ViewModels or Views created
- [x] SyncCoordinator created as stub only (content matches off-limits warning)
- [x] No `import Supabase` in any file
- [x] No hardcoded strings in source files

## 6. Step-by-step execution order
1. Create all directories with `mkdir -p`
2. Write stub Swift files (Services, Constants)
3. Write Localizable.strings
4. Write README.md placeholders for Features/ and Repositories/ subfolders
5. Run SwiftLint
6. Append to agent.log.md

## 7. Risks and unknowns
- SyncCoordinator is off-limits per `.harness/off-limits.md` but the task explicitly requests creating it as a stub. Proceeding since task instruction is explicit user approval for this creation.

## 8. Definition of done
- [ ] All folders and stubs exist
- [ ] SwiftLint passes with zero new errors
- [ ] Agent log updated
- [ ] Working tree snapshot taken
