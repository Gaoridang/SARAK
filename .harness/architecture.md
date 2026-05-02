# Architecture — MVVM (strict)
# Load this when: adding features, creating files, refactoring

## Layer diagram
```
View → ViewModel → [Protocol] → LocalRepository | RemoteRepository
                                        ↓
                                  SyncCoordinator (restricted)
```

## Layer rules

### View
- SwiftUI only. Zero business logic. Zero data calls.
- `@StateObject` / `@ObservedObject` for ViewModel binding.
- Never import `Supabase`. Never call a Repository directly.

### ViewModel
- One per screen. Named `<Feature>ViewModel`.
- `@MainActor` always.
- Calls Repository protocols only — never concrete types.
- Exposes: `@Published var items`, `@Published var isLoading`, `@Published var errorMessage`.

### Repository
- Every data op behind a protocol: `<Entity>RepositoryProtocol`.
- `Local<Entity>Repository` → SwiftData implementation.
- `Remote<Entity>Repository` → Supabase implementation.
- ViewModels depend on protocol only — injected at init.

### SyncCoordinator
- ONLY class that touches both local + remote simultaneously.
- Do NOT modify without explicit user approval. Flag and ask.

## Xcode 16 — synchronized folder groups
This project uses Xcode 16 synchronized folder groups (`objectVersion = 77`). Files added to any folder under `SARAK/` are **auto-discovered and auto-bundled** — no manual `project.pbxproj` edits needed when adding Swift files. Consequence: never place non-source files (README.md, .txt, etc.) inside `SARAK/` subfolders — Xcode will bundle them as app resources and break the build.

## Feature → ViewModel map
| Feature              | ViewModel               |
|----------------------|-------------------------|
| Book search & add    | `BookSearchViewModel`   |
| Reading sessions     | `SessionViewModel`      |
| Progress             | `ProgressViewModel`     |
| Goals                | `GoalViewModel`         |
| Notes & highlights   | `NoteViewModel`         |
| Stats & charts       | `StatsViewModel`        |
| Authentication       | `AuthViewModel`         |
| Social / sharing     | `SocialViewModel`       |
