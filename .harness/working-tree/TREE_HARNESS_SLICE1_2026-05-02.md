# Working Tree Snapshot — Harness Slice 1
**Date:** 2026-05-02
**Branch:** audit/harness-compliance-2026-05-02

## Relevant files before changes

```
SARAK/Features/Home/
├── HomeView.swift                        (30 lines — unchanged)
├── HomeViewModel.swift                   (50 lines — WILL CHANGE)
├── Components/
│   ├── CurrentlyReadingCard.swift        (59 lines — WILL CHANGE)
│   ├── DailyGoalRing.swift               (62 lines — unchanged)
│   ├── ProfileStripView.swift            (21 lines — unchanged)
│   ├── ReadingQueueStrip.swift           (42 lines — WILL CHANGE)
│   └── WeatherHeaderView.swift           (48 lines — unchanged)
└── Models/                               (dir does not exist yet — WILL CREATE)
    └── HomeBookDisplayModel.swift        (new — WILL CREATE)

SARAKTests/
└── HomeViewModelTests.swift              (40 lines — WILL CHANGE)
```

## Key state of files before changes

### HomeViewModel.swift
- Defines `StubBook` struct inline (lines 7–11)
- `isLoadingWeather: Bool` (not `isLoading`)
- No `errorMessage` property
- `loadWeather()` uses `try?` (line 47)
- `currentBook` returns `StubBook?`
- `queue` returns `[StubBook]`

### CurrentlyReadingCard.swift
- `let book: StubBook?` (line 5)
- `private func bookCard(_ book: StubBook)` (line 15)

### ReadingQueueStrip.swift
- `let books: [StubBook]` (line 5)
- `private func bookCard(_ book: StubBook)` (line 30)

### HomeViewModelTests.swift
- 5 tests, all passing
- No test for weather failure path
- No test verifying `errorMessage` is nil on success
- `isLoadingWeather` not referenced (uses `isLoadingWeather` via `viewModel.isLoadingWeather`)
  → actually references `viewModel.isLoadingWeather` on line 38

## Post-change expected state

- `HomeBookDisplayModel.swift` created (~10 lines)
- `HomeViewModel.swift` ~50 lines — `StubBook` removed, `isLoading`/`errorMessage` added, `loadWeather` fixed
- `CurrentlyReadingCard.swift` — 2 occurrences of `StubBook` → `HomeBookDisplayModel`
- `ReadingQueueStrip.swift` — 2 occurrences of `StubBook` → `HomeBookDisplayModel`
- `HomeViewModelTests.swift` — 3 new tests added; `isLoadingWeather` reference updated to `isLoading`
