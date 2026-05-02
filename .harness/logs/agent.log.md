# Agent log — append only
# Format: [DATE] [TASK] [DECISION] [OUTCOME]
# Never delete or edit past entries. Append only.
# Purpose: track agent decisions, mistakes, and corrections for harness improvement.

---

## Log format
```
### [YYYY-MM-DD] Task: <short task name>
- **Plan file:** `.harness/plans/PLAN_<name>_<date>.md`
- **Harness docs read:** architecture.md, conventions.md (list all)
- **Decision:** What approach was chosen and why
- **Constraints applied:** Which hard rules were relevant
- **Files modified:** List of files touched
- **Tests written:** Yes/No — file names
- **Outcome:** Completed | Blocked | Needs approval
- **Notes:** Any ambiguity hit, mistake made, or harness gap found
```

---

## Entries

<!-- Append new entries below this line. Never edit above. -->

### [2026-05-02] Task: Kakao login via Supabase OAuth
- **Plan file:** `.harness/plans/PLAN_KAKAO_AUTH_2026-05-02.md`
- **Working tree:** `.harness/working-tree/TREE_KAKAO_AUTH_2026-05-02.md`
- **Branch:** `feat/kakao-auth`
- **Harness docs read:** architecture.md, conventions.md, constraints.md, supabase.md, testing.md, off-limits.md
- **Decision:** Used Supabase built-in OAuth (PKCE) with `signInWithOAuth(provider: .kakao)` — no native Kakao SDK needed. Added `SupabaseService.handle(_:)` wrapper so `SARAKApp` can handle deep links without importing Supabase. Defined `AuthServiceProtocol` for testability; `AuthViewModel` depends only on the protocol.
- **Constraints applied:** No force unwraps (redirectURL uses guard/preconditionFailure), `import Supabase` only in allowed files (AuthService, SupabaseService), no hardcoded strings (StringConstants + Localizable.strings), @MainActor on AuthViewModel, 200-line limit respected
- **Files created:**
  - `SARAK/Features/Auth/AuthViewModel.swift`
  - `SARAK/Features/Auth/AuthView.swift`
  - `SARAK/Constants/StringConstants.swift`
  - `SARAKTests/AuthViewModelTests.swift`
  - `.harness/working-tree/TREE_KAKAO_AUTH_2026-05-02.md`
- **Files modified:**
  - `SARAK/Services/AuthService.swift` — full implementation + AuthServiceProtocol
  - `SARAK/Services/SupabaseService.swift` — added handle(_:) wrapper
  - `SARAK/Constants/APIConstants.swift` — added Auth.redirectURL
  - `SARAK/Constants/UIConstants.swift` — added Colors.kakaoYellow/kakaoLabel
  - `SARAK/Resources/Localizable.strings` — added auth string keys
  - `SARAK/SARAKApp.swift` — AuthView as root + onOpenURL handler
- **Tests written:** Yes — `SARAKTests/AuthViewModelTests.swift` (4 tests: signInSuccess, signInFailure, signOutSuccess, signOutFailure)
- **SwiftLint result:** 0 new errors, 0 new warnings
- **Build result:** SUCCEEDED
- **Test result:** 4/4 passed
- **Outcome:** Completed
- **Notes:** (1) `ObservableObject`/`@Published` require `import Combine` — missed on first pass, caught by build. (2) `SARAKApp` cannot import Supabase per supabase.md allowed list — resolved by adding `SupabaseService.handle(_:)` wrapper. (3) URL scheme `sarak` must be registered manually in Xcode (Target → Info → URL Types) — cannot be done from code without touching project.pbxproj.

### [2026-05-02] Task: Tighten hard rules in CLAUDE.md
- **Branch:** `feat/supabase-setup`
- **Harness docs read:** none — CLAUDE.md edit only
- **Decision:** Replaced "Tests required for every new feature" with "Tests required for every new ViewModel method or business logic" to close the loophole that allowed skipping tests on service/plumbing files. Added "Agent log entry required before every commit" as a hard rule — previously it only appeared in the PR checklist and was missed on the build-fix commit.
- **Files modified:** `CLAUDE.md`
- **Tests written:** No — rule change only
- **Outcome:** Completed
- **Notes:** Both changes prompted by the build-fix commit that shipped without a log entry until the user asked.

### [2026-05-02] Task: Xcode project scaffold
- **Plan file:** `.harness/plans/PLAN_SCAFFOLD_2026-05-02.md`
- **Working tree:** `.harness/working-tree/TREE_SCAFFOLD_2026-05-02.md`
- **Harness docs read:** architecture.md, conventions.md, off-limits.md
- **Decision:** Created SARAK/ folder hierarchy and stub files exactly as specified. README.md placeholders used for empty Git-tracked folders. SyncCoordinator stub created per explicit task instruction (task instruction counts as user approval for this creation).
- **Constraints applied:** No force unwraps, no import Supabase, no hardcoded strings, 200-line limit (all stubs well under)
- **Files created:**
  - `SARAK/Features/BookSearch/README.md`
  - `SARAK/Features/Session/README.md`
  - `SARAK/Features/Progress/README.md`
  - `SARAK/Features/Goals/README.md`
  - `SARAK/Features/Notes/README.md`
  - `SARAK/Features/Stats/README.md`
  - `SARAK/Features/Auth/README.md`
  - `SARAK/Features/Social/README.md`
  - `SARAK/Repositories/Protocols/README.md`
  - `SARAK/Repositories/Local/README.md`
  - `SARAK/Repositories/Remote/README.md`
  - `SARAK/Services/AuthService.swift`
  - `SARAK/Services/SyncCoordinator.swift`
  - `SARAK/Constants/APIConstants.swift`
  - `SARAK/Constants/UIConstants.swift`
  - `SARAK/Resources/Localizable.strings`
- **Folders created:** `SARAK/Features/`, `SARAK/Repositories/`, `SARAK/Services/`, `SARAK/Models/`, `SARAK/Constants/`, `SARAK/Resources/`
- **Files modified:** none
- **Off-limits files touched:** none (SARAKApp.swift, ContentView.swift, project.pbxproj untouched)
- **Tests written:** No — scaffold only, no logic
- **SwiftLint result:** 0 errors, 2 warnings (both pre-existing in Item.swift and SARAKApp.swift — not introduced by this task)
- **Outcome:** Completed
- **Notes:** SyncCoordinator.swift is listed as off-limits in `.harness/off-limits.md` but the task explicitly requested its creation as a stub. Treated task instruction as explicit approval. The `SARAK/Models/` directory was created empty (no SwiftData models yet) — no placeholder needed as no Git tracking required until first model is added.

### [2026-05-02] Task: Supabase client integration
- **Plan file:** `.harness/plans/PLAN_SUPABASE_SETUP_2026-05-02.md`
- **Branch:** `feat/supabase-setup`
- **Harness docs read:** architecture.md, conventions.md, constraints.md, supabase.md, off-limits.md
- **Decision:** Created `SupabaseService.swift` as the single shared `SupabaseClient` instance. Used `guard let` + `preconditionFailure` instead of force-unwrap to satisfy `force_unwrapping: error` SwiftLint rule, which conflicts with the `!` shown in `supabase.md`'s canonical example.
- **Constraints applied:** No force unwraps, `import Supabase` restricted to allowed files only, no hardcoded strings
- **Files created:** `SARAK/Services/SupabaseService.swift`
- **Files modified:** none
- **Off-limits files touched:** none
- **Tests written:** No — client initialisation only, no testable logic
- **SwiftLint result:** 0 new errors, 0 new warnings (2 pre-existing warnings in SARAKApp.swift and Item.swift unchanged)
- **Outcome:** Completed
- **Notes:** SourceKit reported "No such module 'Supabase'" outside Xcode build context — false positive. Package is already linked in project.pbxproj (`XCRemoteSwiftPackageReference "supabase-swift"`). `supabase.md` canonical example uses a force unwrap; flagged the conflict in the plan and resolved with `preconditionFailure` — harness doc should be updated to reflect the safe pattern.

### [2026-05-02] Task: Build fix + harness doc corrections
- **Branch:** `feat/supabase-setup`
- **Harness docs read:** architecture.md, conventions.md, off-limits.md, supabase.md, plans/PLAN_TEMPLATE.md
- **Decision:** Deleted 11 README.md placeholder files that were auto-bundled by Xcode 16 synchronized folder groups, causing duplicate-resource build failures. Updated 5 harness docs to fix stale paths and missing rules.
- **Constraints applied:** Off-limits files untouched; no source files modified
- **Files deleted:** all `README.md` placeholders in Features/ and Repositories/ subfolders (11 total)
- **Files modified:**
  - `.harness/architecture.md` — added Xcode 16 synchronized folder groups note
  - `.harness/conventions.md` — added rule against placeholder files in SARAK/ subfolders
  - `.harness/supabase.md` — fixed client init example (`!` → `guard/preconditionFailure`)
  - `.harness/off-limits.md` — fixed stale project name and paths (ReadingTracker/Sources → SARAK)
  - `.harness/plans/PLAN_TEMPLATE.md` — fixed all Sources/ paths to SARAK/
- **Tests written:** No
- **Build result:** SUCCEEDED on iPhone 17 simulator after README.md deletion
- **Outcome:** Completed
- **Notes:** Root cause of build failure — Xcode 16 `objectVersion = 77` uses synchronized folder groups that auto-discover and bundle every file inside SARAK/, including markdown files. README.md placeholders are incompatible with this project setup. Advisor recommended this approach.

### [2026-05-02] Task: SwiftLint setup
- **Plan file:** `.harness/plans/PLAN_SWIFTLINT_SETUP_2026-05-02.md`
- **Harness docs read:** constraints.md, off-limits.md
- **Decision:** Created `.swiftlint.yml` with rules matching `constraints.md` hard limits. Initial YAML used a `rules:` nesting key which SwiftLint 0.63.2 does not recognise — restructured to place rule configs at the top level.
- **Constraints applied:** `force_unwrapping: error`, `file_length: error 200`, `line_length: error 130`, `identifier_name: min_length 2`, custom `no_print` warning rule
- **Files created:** `.swiftlint.yml`
- **Files modified:** none (existing source files had 0 errors)
- **Tests written:** No — tooling config only
- **SwiftLint version:** 0.63.2
- **Lint result:** 0 errors, 2 warnings
  - `SARAK/Item.swift:14` — trailing whitespace (warning)
  - `SARAK/SARAKApp.swift:15` — trailing comma in collection literal (warning)
- **Outcome:** Completed
- **Notes:** The `rules:` key is invalid in SwiftLint 0.63.2; top-level keys must be used for per-rule configuration. Fixed before final run.
