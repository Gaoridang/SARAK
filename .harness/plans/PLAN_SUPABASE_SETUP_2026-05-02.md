# Execution plan — Supabase Client Integration
# Created: 2026-05-02
# Branch: feat/supabase-setup

---

## 1. Task summary
Wire the Supabase Swift SDK (already added to the project via SPM) into a single shared client instance via `SupabaseService.swift`. This is the only file in the app allowed to initialise the `SupabaseClient`. No feature code — plumbing only.

## 2. Harness docs loaded
- [x] architecture.md
- [x] conventions.md
- [x] constraints.md
- [ ] sync.md (not touching SyncCoordinator)
- [ ] testing.md (no VM logic to test)
- [x] supabase.md
- [x] off-limits.md

## 3. Files to create
| File path | Purpose |
|-----------|---------|
| `SARAK/Services/SupabaseService.swift` | Single shared `SupabaseClient` instance — only place `import Supabase` is allowed outside repositories |

## 4. Files to modify
None.

## 5. Architecture check
- [x] `import Supabase` only in `SupabaseService.swift` — allowed per supabase.md
- [x] No Views or ViewModels created
- [x] SyncCoordinator NOT touched
- [x] No hardcoded strings — URL and key come from `APIConstants.Supabase`
- [x] No force unwraps — see risk note below

## 6. Step-by-step execution order
1. Create `SARAK/Services/SupabaseService.swift` with safe URL init
2. Run `swiftlint lint --config .swiftlint.yml` — must be 0 new errors
3. Append to `.harness/logs/agent.log.md`

## 7. Risks and unknowns

### Force-unwrap conflict
`.harness/supabase.md` shows the canonical pattern using `URL(string: ...)!`.
`.harness/constraints.md` makes `force_unwrapping` a SwiftLint **error**.

**Resolution:** Replace `!` with `guard let` + `preconditionFailure`. This crashes at the same point with a clear message, satisfies SwiftLint, and avoids silently swallowing a bad URL.

```swift
enum SupabaseService {
    static let client: SupabaseClient = {
        guard let url = URL(string: APIConstants.Supabase.url) else {
            preconditionFailure("Invalid Supabase URL — check APIConstants.Supabase.url")
        }
        return SupabaseClient(supabaseURL: url, supabaseKey: APIConstants.Supabase.anonKey)
    }()
}
```

### anonKey type
`SupabaseClient` expects `supabaseKey` as a `String` — `APIConstants.Supabase.anonKey` is already `String`. No conversion needed.

## 8. Definition of done
- [ ] `SupabaseService.swift` exists and compiles
- [ ] SwiftLint passes with 0 new errors
- [ ] Agent log updated
- [ ] `import Supabase` does not appear in any View or ViewModel
