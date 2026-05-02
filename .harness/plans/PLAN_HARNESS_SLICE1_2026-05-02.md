# Plan: Harness Compliance — PR Slice 1
**Date:** 2026-05-02
**Branch:** audit/harness-compliance-2026-05-02
**Audit source:** `.harness/audits/AUDIT_HARNESS_COMPLIANCE_2026-05-02.md`
**Violations addressed:** V-01, V-02, V-03

---

## Scope

Fix the three High-severity violations. No other changes.

| V-ID | Description |
|---|---|
| V-01 | `StubBook` temporary name in production — rename to `HomeBookDisplayModel` |
| V-02 | `HomeViewModel` missing `@Published var isLoading` and `@Published var errorMessage` |
| V-03 | `try?` in `loadWeather()` silently swallows errors — replace with `do/catch` |

---

## Files to create

| File | Reason |
|---|---|
| `SARAK/Features/Home/Models/HomeBookDisplayModel.swift` | Extract `HomeBookDisplayModel` struct (was `StubBook` inline in ViewModel) |

## Files to modify

| File | Change |
|---|---|
| `SARAK/Features/Home/HomeViewModel.swift` | Remove `StubBook` definition; rename return types to `HomeBookDisplayModel`; add `@Published var isLoading`; add `@Published var errorMessage`; replace `try?` with `do/catch` in `loadWeather()` |
| `SARAK/Features/Home/Components/CurrentlyReadingCard.swift` | Replace `StubBook` → `HomeBookDisplayModel` in property and function signature |
| `SARAK/Features/Home/Components/ReadingQueueStrip.swift` | Replace `StubBook` → `HomeBookDisplayModel` in property and function signature |
| `SARAKTests/HomeViewModelTests.swift` | Add `loadWeather sets errorMessage on service failure` test; add `isLoading resets to false after loadWeather` test |

## Files NOT touched

All off-limits files, and all files not listed above.

---

## Decisions

### isLoadingWeather vs isLoading
`HomeViewModel` currently has `isLoadingWeather`. The harness baseline requires `isLoading`.
Decision: **rename `isLoadingWeather` → `isLoading`** (same semantics, just the baseline name).
`HomeView.swift` does not reference `isLoadingWeather` directly, so no change needed there.

### HomeBookDisplayModel location
Placed in `SARAK/Features/Home/Models/` per the feature folder pattern in `architecture.md`.

### loadWeather error handling
`do/catch` sets `errorMessage` on failure. On success clears `errorMessage` to nil.
`isLoading` wraps the entire operation (set to `true` before, `false` in defer).

---

## Constraints checklist (pre-coding)

- [ ] No force unwraps
- [ ] No `import Supabase` in new/modified files
- [ ] All ViewModels `@MainActor` — unchanged, already compliant
- [ ] Protocol injection unchanged — `weatherService: any WeatherServiceProtocol` stays
- [ ] No hardcoded user-facing strings added
- [ ] Files stay under 200 lines
- [ ] Tests required: yes, updating `HomeViewModelTests.swift`
- [ ] No off-limits files touched

---

## Test plan

Add to `HomeViewModelTests.swift`:

1. `loadWeather sets errorMessage on service failure`
   - Given: `FailingWeatherService` that always throws
   - When: `await viewModel.loadWeather()`
   - Then: `errorMessage != nil`, `isLoading == false`, `weather == nil`

2. `isLoading is false after loadWeather completes`
   - Given: `StubWeatherService`
   - When: `await viewModel.loadWeather()`
   - Then: `isLoading == false` (regression guard)

3. `errorMessage is nil on successful loadWeather`
   - Given: `StubWeatherService`
   - When: `await viewModel.loadWeather()`
   - Then: `errorMessage == nil`
