# Harness Compliance Audit
**Date:** 2026-05-02
**Branch:** audit/harness-compliance-2026-05-02
**Auditor:** Claude Code (automated)
**Harness docs consulted:** constraints.md, off-limits.md, architecture.md, conventions.md, testing.md, supabase.md, sync.md

---

## 1. Files Inspected

| File | Lines |
|---|---|
| `SARAK/SARAKApp.swift` | 35 |
| `SARAK/Item.swift` | 18 |
| `SARAK/Features/Root/RootView.swift` | 14 |
| `SARAK/Features/Root/MainTabView.swift` | 30 |
| `SARAK/Features/Auth/AuthView.swift` | 46 |
| `SARAK/Features/Auth/AuthViewModel.swift` | 45 |
| `SARAK/Features/Home/HomeView.swift` | 30 |
| `SARAK/Features/Home/HomeViewModel.swift` | 50 |
| `SARAK/Features/Home/Components/CurrentlyReadingCard.swift` | 59 |
| `SARAK/Features/Home/Components/DailyGoalRing.swift` | 62 |
| `SARAK/Features/Home/Components/ProfileStripView.swift` | 21 |
| `SARAK/Features/Home/Components/ReadingQueueStrip.swift` | 42 |
| `SARAK/Features/Home/Components/WeatherHeaderView.swift` | 48 |
| `SARAK/Features/Library/LibraryView.swift` | 11 |
| `SARAK/Features/Profile/ProfileView.swift` | 22 |
| `SARAK/Features/Stats/StatsView.swift` | 11 |
| `SARAK/Models/WeatherSummary.swift` | 11 |
| `SARAK/Services/AuthService.swift` | 29 |
| `SARAK/Services/SupabaseService.swift` | 19 |
| `SARAK/Services/SyncCoordinator.swift` | 7 |
| `SARAK/Services/WeatherService.swift` | 12 |
| `SARAK/Constants/APIConstants.swift` | 23 |
| `SARAK/Constants/StringConstants.swift` | 40 |
| `SARAK/Constants/UIConstants.swift` | 22 |
| `SARAKTests/SARAKTests.swift` | 17 |
| `SARAKTests/AuthViewModelTests.swift` | 81 |
| `SARAKTests/HomeViewModelTests.swift` | 40 |

---

## 2. Violations Found

---

### V-01 · `StubBook` is a temporary name in production files
**Files:** `HomeViewModel.swift`, `CurrentlyReadingCard.swift`, `ReadingQueueStrip.swift`
**Severity:** High
**Harness rule:** conventions.md — "Avoid temporary names like `StubBook` in production files. Prefer stable UI-facing names such as `HomeBookDisplayModel`."

**Why it violates:** `StubBook` is defined and consumed in three production files. It crosses the View layer (components receive `StubBook` directly), which means it is embedded in the public API of those components. When the real data model lands, all three files must change. Using `HomeBookDisplayModel` from the start would contain the migration to one place.

**Suggested fix:**
- Rename `StubBook` → `HomeBookDisplayModel` in `HomeViewModel.swift`.
- Move the struct to `SARAK/Features/Home/Models/HomeBookDisplayModel.swift`.
- Update references in `CurrentlyReadingCard.swift` and `ReadingQueueStrip.swift`.

**Off-limits risk:** None.

---

### V-02 · `HomeViewModel` missing required baseline state shape
**File:** `HomeViewModel.swift`
**Severity:** High
**Harness rule:** architecture.md — "Required baseline state shape for data-loading ViewModels: `@Published var isLoading: Bool`, `@Published var errorMessage: String?`"

**Why it violates:** `HomeViewModel` loads weather asynchronously and has stub data paths, yet exposes only `isLoadingWeather` (a feature-specific flag) and no `errorMessage`. The harness requires every data-loading ViewModel to have these two baseline properties. Missing `errorMessage` means the weather failure path silently swallows the error (via `try?`) with no surface to the UI.

**Suggested fix:**
- Add `@Published var isLoading: Bool = false` (can replace or complement `isLoadingWeather`).
- Add `@Published var errorMessage: String?`.
- Convert `weather = try? await weatherService.currentWeather()` to a proper do/catch that sets `errorMessage`.

**Off-limits risk:** None.

---

### V-03 · `try?` swallows the weather error silently
**File:** `HomeViewModel.swift:47`
**Severity:** High
**Harness rule:** constraints.md — "Avoid `try?`. If `try?` is intentionally safe, add a comment explaining why." Also: "Do not silently swallow errors."

**Why it violates:** The line `weather = try? await weatherService.currentWeather()` drops any thrown error without recording it anywhere. There is no `errorMessage` property (see V-02) and no comment explaining why failure is safe to ignore. Users see a blank weather section with no indication of why.

**Suggested fix:** Replace with a do/catch block. On success set `weather`; on failure set `errorMessage`. This also resolves V-02.

**Off-limits risk:** None.

---

### V-04 · `try?` without justification comment in `AuthService`
**File:** `AuthService.swift:16`
**Severity:** Medium
**Harness rule:** constraints.md — "If `try?` is intentionally safe, add a comment explaining why."

**Why it violates:** `(try? await SupabaseService.client.auth.session) != nil` is used to implement `isSignedIn`. The failure is intentionally collapsed to `false` (no session = not signed in), but there is no comment explaining this. A future reader may incorrectly assume this is an oversight.

**Suggested fix:** Add an inline comment: `// safe: session absence or error both map to signed-out state`.

**Off-limits risk:** None.

---

### V-05 · `HomeViewModel` injects concrete `StubWeatherService` as default
**File:** `HomeViewModel.swift:20`
**Severity:** Medium
**Harness rule:** architecture.md — "ViewModels must not: depend on concrete repositories / depend on concrete services." The `StubWeatherService` concrete type is the default argument in the production initializer.

**Why it violates:** The production `HomeViewModel.init` hard-wires `StubWeatherService()` as the default. This means the ViewModel currently ships with a fake dependency baked in, which is acceptable for a stub-only PR only if it is clearly temporary and the architecture enforces protocol injection in the initializer signature. The initializer signature itself is correct (`any WeatherServiceProtocol`), but the default value is a stub rather than a real service, indicating no real `WeatherService` implementation exists yet.

**Note:** This is acceptable within a formally declared stub-only PR. However it is recorded here because a real `WeatherService` conforming to `WeatherServiceProtocol` must be created before the production default is wired up. The current state leaves the app shipping a stub in production builds.

**Suggested fix:** Either:
  - (a) Add a real `WeatherService` implementation and switch the default to it, or
  - (b) Mark the stub intent explicitly with a `#if DEBUG` guard or a clearly documented plan entry.

**Off-limits risk:** None.

---

### V-06 · Hardcoded user-facing strings in `LibraryView` and `StatsView`
**Files:** `LibraryView.swift:7`, `StatsView.swift:7`
**Severity:** Medium
**Harness rule:** constraints.md — "No hardcoded user-facing strings in production UI." conventions.md — "No hardcoded user-facing strings in production UI."

**Why it violates:**
- `LibraryView.swift:7` — `Text("내 서재")` is a raw Korean string in the View body.
- `StatsView.swift:7` — `Text("통계")` is a raw Korean string in the View body.

Both strings already have localization equivalents in `Localizable.strings` (`tab.library` = "서재", `tab.stats` = "통계") and `StringConstants.Tab` constants. The views should use `StringConstants.Tab.library` and `StringConstants.Tab.stats`.

**Suggested fix:**
- `LibraryView.swift:7` → `Text(StringConstants.Tab.library)`
- `StatsView.swift:7` → `Text(StringConstants.Tab.stats)`

**Off-limits risk:** None.

---

### V-07 · Hardcoded date format and locale in `WeatherHeaderView`
**File:** `WeatherHeaderView.swift:9–10, 15–16`
**Severity:** Medium
**Harness rule:** constraints.md — "No hardcoded user-facing strings in production UI." conventions.md — same. Also: the `"ko_KR"` locale is hardcoded, making the app non-localizable.

**Why it violates:**
- `Locale(identifier: "ko_KR")` hardcodes Korean locale unconditionally.
- `"M월 d일 EEEE"` is a Korean date format string baked into the view.
- `"--°C"` and `"%.0f°C"` are hardcoded fallback and format strings.

These strings bypass the localization system. The temperature format and date format should either use `FormatStyle`/`DateFormatter` with `Locale.current`, or the format strings should be moved to `StringConstants`.

**Suggested fix:**
- Use `Date.FormatStyle` or `DateFormatter` with `Locale.current` instead of hardcoded `"ko_KR"`.
- Move `"--°C"` fallback to `StringConstants.Home`.
- Move `"%.0f°C"` format to `StringConstants.Home` or use `Measurement<UnitTemperature>` formatting.

**Off-limits risk:** None.

---

### V-08 · `UIConstants.Spacing` and `CornerRadius` use abbreviated names
**File:** `UIConstants.swift`
**Severity:** Low
**Harness rule:** conventions.md — "Avoid abbreviations such as `sm`, `md`, `lg` in production constants unless already established across the project."

**Why it violates:** `sm`, `md`, `lg`, `xl` are listed as abbreviations to avoid. The harness carves an exception "unless already established across the project." Since the project is new (initial commits only), these abbreviations are not yet established as a deliberate exception; they were written before the harness was finalised.

**Suggested fix:** Rename to `small`, `medium`, `large`, `extraLarge` (and update all call sites) — or formally document in `.harness/conventions.md` that these shorthand names are an approved exception for this project.

**Note:** This is the lowest-priority item. A project-wide rename across ~10 files is a non-trivial churn; documenting as an approved exception may be the right call.

**Off-limits risk:** None, but touches many files if renamed.

---

### V-09 · `Item.swift` is Xcode boilerplate — unused SwiftData model
**File:** `SARAK/Item.swift`
**Severity:** Low
**Harness rule:** conventions.md — "Avoid vague type names: `Manager`, `Helper`, `Data`, `Info`, `Thing`, `Temp`." While `Item` is not listed explicitly, it is generic Xcode boilerplate with no domain meaning. It is registered in `SARAKApp.swift`'s `ModelContainer` schema and occupies a slot in the real app container.

**Why it violates:** `Item` has no relationship to the app domain. It is the default Xcode SwiftData template model. Its presence in the production `ModelContainer` schema adds a phantom table to the app's data store. Naming convention requires domain-meaningful names.

**Suggested fix:** Delete `Item.swift` and remove it from the `SARAKApp` `ModelContainer` schema once a real domain model (e.g., `Book`) replaces it. Until then, file a plan entry noting it must be removed before PR 2.

**Off-limits risk:** `SARAKApp.swift` is not off-limits, but modifying `ModelContainer` schema is a migration-risk operation (data schema change). Safe to remove `Item` now since no user data exists yet.

---

### V-10 · `SARAKApp.swift` calls `SupabaseService.handle(url)` — boundary gray area
**File:** `SARAKApp.swift:30`
**Severity:** Low
**Harness rule:** supabase.md — "Supabase may only be imported by: `Remote*Repository`, `AuthService`, `SupabaseService`, `SyncCoordinator`." The `App` struct is not in that list.

**Why it violates (partially):** `SARAKApp` calls `SupabaseService.handle(url)` without importing Supabase directly (it uses the wrapper method on `SupabaseService`). The call does not `import Supabase`; it merely calls a public method on `SupabaseService`. The `SupabaseService.handle(_:)` wrapper was explicitly designed to prevent direct Supabase import in callers. This is architecturally acceptable but creates a subtle coupling: the `App` entry point knows `SupabaseService` exists.

**Suggested fix:** Acceptable as-is given the explicit wrapper design. The comment in `SupabaseService.swift` documents this intent. Record as a Low/acknowledged item. If `AuthService` later takes ownership of URL handling, `SARAKApp` can delegate to `AuthServiceProtocol` instead.

**Off-limits risk:** None.

---

### V-11 · `SARAKTests/SARAKTests.swift` is empty boilerplate
**File:** `SARAKTests/SARAKTests.swift`
**Severity:** Low
**Harness rule:** testing.md — tests should describe behavior and be meaningful. An empty `@Test func example()` is Xcode boilerplate.

**Suggested fix:** Delete or replace with a minimal placeholder comment. No behavioral harm, but it contributes noise to the test suite.

**Off-limits risk:** None.

---

## 3. Violation Summary Table

| ID | File(s) | Description | Severity | Off-limits risk |
|---|---|---|---|---|
| V-01 | HomeViewModel, CurrentlyReadingCard, ReadingQueueStrip | `StubBook` temporary name in production | **High** | None |
| V-02 | HomeViewModel | Missing `isLoading` + `errorMessage` baseline | **High** | None |
| V-03 | HomeViewModel:47 | `try?` silently swallows weather error | **High** | None |
| V-04 | AuthService:16 | `try?` without justification comment | **Medium** | None |
| V-05 | HomeViewModel:20 | Concrete stub default in production init | **Medium** | None |
| V-06 | LibraryView:7, StatsView:7 | Hardcoded Korean strings bypass localization | **Medium** | None |
| V-07 | WeatherHeaderView:9–16 | Hardcoded locale, date format, temp format strings | **Medium** | None |
| V-08 | UIConstants | `sm`/`md`/`lg` abbreviated constant names | **Low** | None |
| V-09 | Item.swift, SARAKApp | Unused boilerplate `Item` model in schema | **Low** | None |
| V-10 | SARAKApp:30 | App entry point couples to SupabaseService | **Low** | None |
| V-11 | SARAKTests/SARAKTests.swift | Empty boilerplate test | **Low** | None |

**No violations touch off-limits files.**

---

## 4. Not Violated (confirmed clean)

- No `import Supabase` in Views or ViewModels ✓
- No force unwraps (`!`) in production code ✓
- All ViewModels are `@MainActor` ✓
- `AuthViewModel` has single owner (`RootView`) and is injected into children ✓
- ViewModels depend on injected protocols (not concrete types), except V-05 stub default ✓
- `SyncCoordinator` not modified ✓
- No `project.pbxproj` edits ✓
- All files well under 200-line limit ✓
- No `print()` in production code ✓
- No `DispatchQueue.main.async` or semaphores ✓
- Supabase imported only in `SupabaseService.swift` and `AuthService.swift` ✓
- Table names use `APIConstants.Supabase.*` ✓
- `AuthServiceProtocol` injected into `AuthViewModel` ✓
- `WeatherServiceProtocol` injected into `HomeViewModel` ✓
- Tests use Swift Testing + `@testable import SARAK` ✓
- `AuthViewModelTests` covers success, failure, sign-out success, sign-out failure ✓
- Mock uses protocol, not concrete type ✓
- `@unchecked Sendable` in tests has explanatory comment ✓

---

## 5. Recommended PR Slices

### PR Slice 1 — High-severity naming, baseline state, error handling (no off-limits)
**Goal:** Fix all High violations. Unblocks future PR 2 (real data layer).

1. Rename `StubBook` → `HomeBookDisplayModel`, extract to `Models/HomeBookDisplayModel.swift` (V-01)
2. Add `@Published var isLoading: Bool` and `@Published var errorMessage: String?` to `HomeViewModel` (V-02)
3. Replace `try?` weather call with `do/catch` setting `errorMessage` (V-03)

Touches: `HomeViewModel.swift`, `CurrentlyReadingCard.swift`, `ReadingQueueStrip.swift`, new `HomeBookDisplayModel.swift`
Tests required: update `HomeViewModelTests` to cover `errorMessage` on weather failure and `isLoading` state transitions.

---

### PR Slice 2 — Medium: string/localization hardcoding fixes
**Goal:** Fix V-04, V-06, V-07.

1. Add `try?` comment in `AuthService` (V-04)
2. Replace hardcoded strings in `LibraryView` and `StatsView` with `StringConstants` (V-06)
3. Fix `WeatherHeaderView` locale, date format, and temperature format strings (V-07)
4. Document V-05 (`StubWeatherService` default) in a plan entry for PR 2 (real weather service)

Touches: `AuthService.swift`, `LibraryView.swift`, `StatsView.swift`, `WeatherHeaderView.swift`, `StringConstants.swift`

---

### PR Slice 3 — Low: cleanup and constants naming decision
**Goal:** Resolve V-08, V-09, V-10, V-11.

1. Decide on `sm/md/lg` naming — rename to full words or add approved-exception note to `conventions.md` (V-08)
2. Delete `Item.swift` and remove from `SARAKApp.swift` schema (V-09) — safe now, no real user data
3. Acknowledge V-10 as acceptable in `agent.log.md` (V-10)
4. Delete or replace empty `SARAKTests.swift` boilerplate (V-11)

---

## 6. Safe Implementation Order

```
PR Slice 1  (High — naming + baseline state + error handling)
    → Unblocks: real data layer (PR 2), honest error UX
    → Risk: Low — no off-limits files, no schema changes

PR Slice 2  (Medium — localization + string cleanup)
    → Unblocks: multi-language support, cleaner review
    → Risk: Low — view-only and constants changes

PR Slice 3  (Low — cleanup + naming decision)
    → Unblocks: clean schema for Book model, reduced noise
    → Risk: Very low — `Item` deletion is safe pre-user-data
```

**Awaiting approval to implement PR Slice 1.**
