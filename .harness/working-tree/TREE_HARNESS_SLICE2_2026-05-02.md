# Working Tree Snapshot — Harness Slice 2
**Date:** 2026-05-02
**Branch:** audit/harness-compliance-2026-05-02

## Relevant files before changes

```
SARAK/Services/
└── AuthService.swift           (29 lines — WILL CHANGE: add try? comment)

SARAK/Features/Library/
└── LibraryView.swift           (11 lines — WILL CHANGE: hardcoded string fix)

SARAK/Features/Stats/
└── StatsView.swift             (11 lines — WILL CHANGE: hardcoded string fix)

SARAK/Features/Home/Components/
└── WeatherHeaderView.swift     (48 lines — WILL CHANGE: locale, format, fallback)

SARAK/Constants/
└── StringConstants.swift       (40 lines — WILL CHANGE: add weatherUnavailable)

SARAK/Resources/
└── Localizable.strings         (WILL CHANGE: add home.weather.unavailable key)
```

## Key state before changes

### AuthService.swift:16
```swift
get async { (try? await SupabaseService.client.auth.session) != nil }
```
Missing justification comment for `try?`.

### LibraryView.swift:7
```swift
Text("내 서재")
```
Hardcoded — `StringConstants.Tab.library` already exists.

### StatsView.swift:7
```swift
Text("통계")
```
Hardcoded — `StringConstants.Tab.stats` already exists.

### WeatherHeaderView.swift:9–16
```swift
formatter.locale = Locale(identifier: "ko_KR")
formatter.dateFormat = "M월 d일 EEEE"
...
guard let weather else { return "--°C" }
return String(format: "%.0f°C", weather.temperatureC)
```
Hardcoded locale, date format skeleton, and temperature strings.

## Post-change expected state

- All 6 files updated; 0 new files created
- No lines added that bypass StringConstants or Localizable.strings
- `WeatherHeaderView` uses `Locale.current` and `MeasurementFormatter`
- `LibraryView` and `StatsView` use `StringConstants` constants
- `AuthService` `try?` is documented
