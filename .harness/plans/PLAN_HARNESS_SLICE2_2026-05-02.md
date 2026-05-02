# Plan: Harness Compliance — PR Slice 2
**Date:** 2026-05-02
**Branch:** audit/harness-compliance-2026-05-02
**Audit source:** `.harness/audits/AUDIT_HARNESS_COMPLIANCE_2026-05-02.md`
**Violations addressed:** V-04, V-05 (doc only), V-06, V-07

---

## Scope

Fix four Medium-severity violations. V-05 is doc-only (no code change).

| V-ID | Description |
|---|---|
| V-04 | `AuthService:16` — `try?` without justification comment |
| V-05 | `HomeViewModel.init` defaults to concrete `StubWeatherService()` — document plan only |
| V-06 | `LibraryView` and `StatsView` hardcode Korean strings; equivalents already exist in `StringConstants` |
| V-07 | `WeatherHeaderView` hardcodes locale, date format, and temperature format |

---

## Files to modify

| File | Change |
|---|---|
| `SARAK/Services/AuthService.swift` | Add inline `// safe:` comment on `try?` line (V-04) |
| `SARAK/Features/Library/LibraryView.swift` | `Text("내 서재")` → `Text(StringConstants.Tab.library)` (V-06) |
| `SARAK/Features/Stats/StatsView.swift` | `Text("통계")` → `Text(StringConstants.Tab.stats)` (V-06) |
| `SARAK/Features/Home/Components/WeatherHeaderView.swift` | Replace hardcoded locale, date format, temperature format/fallback (V-07) |
| `SARAK/Constants/StringConstants.swift` | Add `Home.weatherUnavailable` constant (V-07) |
| `SARAK/Resources/Localizable.strings` | Add `home.weather.unavailable` key (V-07) |

## Files NOT touched

All off-limits files, and all files not listed above.
No new test files required (these are pure string/constant fixes with no logic change).

---

## V-07 detail — WeatherHeaderView approach

### Date format
Replace:
```swift
formatter.locale = Locale(identifier: "ko_KR")
formatter.dateFormat = "M월 d일 EEEE"
```
With:
```swift
formatter.locale = Locale.current
formatter.setLocalizedDateFormatFromTemplate("MdEEEE")
```
`setLocalizedDateFormatFromTemplate` derives the format from a skeleton for the active locale.

### Temperature
Replace:
```swift
guard let weather else { return "--°C" }
return String(format: "%.0f°C", weather.temperatureC)
```
With `MeasurementFormatter` using `.providedUnit` (keeps Celsius for now; locale handles symbol):
```swift
guard let weather else { return StringConstants.Home.weatherUnavailable }
let measurement = Measurement(value: weather.temperatureC, unit: UnitTemperature.celsius)
let formatter = MeasurementFormatter()
formatter.unitOptions = .providedUnit
formatter.numberFormatter.maximumFractionDigits = 0
return formatter.string(from: measurement)
```

### New string key
- `StringConstants.Home.weatherUnavailable` → `String(localized: "home.weather.unavailable")`
- `Localizable.strings`: `"home.weather.unavailable" = "--";`

---

## V-05 documentation note

`HomeViewModel.init` defaults to `StubWeatherService()` — acceptable for the current stub-only PR.
A real `WeatherService` implementation must be created and wired as the default before PR 2 ships.
This will be tracked in the PR 2 plan.

---

## Constraints checklist (pre-coding)

- [ ] No force unwraps
- [ ] No new `import Supabase`
- [ ] No new hardcoded user-facing strings
- [ ] Files stay under 200 lines
- [ ] No off-limits files touched
- [ ] No tests required for pure string-constant substitutions
