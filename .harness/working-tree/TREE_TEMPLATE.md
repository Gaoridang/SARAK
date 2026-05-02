# Working tree — [FEATURE NAME]
# Snapshot: [DATE TIME]
# Purpose: debugging reference — state of relevant files at task start

---

## Current file tree (relevant paths only)
```
Sources/
├── Features/
│   └── [Feature]/
│       ├── [Feature]View.swift          [EXISTS | TO CREATE]
│       └── [Feature]ViewModel.swift     [EXISTS | TO CREATE]
├── Repositories/
│   ├── [Entity]RepositoryProtocol.swift [EXISTS | TO CREATE]
│   ├── Local[Entity]Repository.swift    [EXISTS | TO CREATE]
│   └── Remote[Entity]Repository.swift   [EXISTS | TO CREATE]
├── Services/
│   ├── AuthService.swift                [EXISTS — DO NOT MODIFY]
│   └── SyncCoordinator.swift            [EXISTS — RESTRICTED]
└── Constants/
    └── APIConstants.swift               [EXISTS]

Tests/
└── Unit/
    └── [Feature]ViewModelTests.swift    [EXISTS | TO CREATE]
```

## Key types in scope
| Type | File | Status |
|------|------|--------|
| `BookRepositoryProtocol` | `Repositories/BookRepositoryProtocol.swift` | Exists |
| `LocalBookRepository` | `Repositories/LocalBookRepository.swift` | Exists |

## Current build status
- [ ] Build: passing / failing
- [ ] SwiftLint: passing / N errors
- [ ] Tests: passing / N failing

## Known issues at snapshot time
List any existing warnings, lint errors, or test failures before starting work.
These must not be introduced by this task — they must stay the same or improve.

## Dependency state
Supabase-swift version: `2.x.x`
SwiftLint version: `x.x.x`

---
## Post-task diff summary
Fill this in after the task is complete.

### Files created
-

### Files modified
-

### Tests added
-

### Build status after
- Build: 
- SwiftLint: 
- Tests: 
