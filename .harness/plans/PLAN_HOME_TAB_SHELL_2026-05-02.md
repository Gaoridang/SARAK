# Execution plan — Home Tab Shell (PR 1 of 3)
# Created: 2026-05-02
# Branch: feat/home-tab-shell

---

## 1. Task summary
Build the navigation shell (RootView + 4-tab TabView) and the Home tab UI
with stub data. No real data layer yet — HomeViewModel returns hardcoded
values. WeatherService is a stub returning mock weather. Session start button
is a no-op. Real data wiring, WeatherKit, and the session timer are PR 2/3.

## 2. Harness docs loaded
- [x] architecture.md
- [x] conventions.md
- [x] constraints.md
- [ ] sync.md (no data layer touched in PR 1)
- [x] testing.md
- [ ] supabase.md (no remote calls in PR 1)
- [x] off-limits.md

## 3. Files to create
| File path | Purpose |
|-----------|---------|
| `SARAK/Features/Home/HomeView.swift` | Root home tab — layout only, composes subviews |
| `SARAK/Features/Home/HomeViewModel.swift` | `@MainActor` VM — stub data for PR 1 |
| `SARAK/Features/Home/Components/ProfileStripView.swift` | Name + weekly minutes |
| `SARAK/Features/Home/Components/WeatherHeaderView.swift` | Date, temp, condition, mood string |
| `SARAK/Features/Home/Components/CurrentlyReadingCard.swift` | Book cover, progress, last-read, CTA |
| `SARAK/Features/Home/Components/DailyGoalRing.swift` | Circular progress ring for today's goal |
| `SARAK/Features/Home/Components/ReadingQueueStrip.swift` | Horizontal scroll of queued books |
| `SARAK/Features/Root/RootView.swift` | Auth gate — switches AuthView ↔ TabView on isAuthenticated |
| `SARAK/Features/Library/LibraryView.swift` | Placeholder tab |
| `SARAK/Features/Stats/StatsView.swift` | Placeholder tab |
| `SARAK/Features/Profile/ProfileView.swift` | Placeholder tab |
| `SARAK/Services/WeatherService.swift` | WeatherServiceProtocol + stub implementation |
| `SARAK/Models/WeatherSummary.swift` | WeatherSummary struct + WeatherCondition enum |
| `SARAKTests/HomeViewModelTests.swift` | Minimal tests for stub VM (see §8) |

## 4. Files to modify
| File path | Change |
|-----------|--------|
| `SARAK/SARAKApp.swift` | Replace `AuthView()` root with `RootView()` |
| `SARAK/Constants/StringConstants.swift` | Add Home + WeatherMood namespaces |
| `SARAK/Resources/Localizable.strings` | Add home + mood strings |

## 5. Files to delete
| File path | Reason |
|-----------|--------|
| `SARAK/ContentView.swift` | Unreachable after RootView lands — Xcode template leftover |

## 6. Architecture
```
SARAKApp
  └── RootView (@StateObject AuthViewModel)
        ├── AuthView             (isAuthenticated == false)
        └── TabView              (isAuthenticated == true)
              ├── HomeView       (@StateObject HomeViewModel)
              │     ├── ProfileStripView
              │     ├── WeatherHeaderView
              │     ├── CurrentlyReadingCard
              │     ├── DailyGoalRing
              │     └── ReadingQueueStrip
              ├── LibraryView    (placeholder)
              ├── StatsView      (placeholder)
              └── ProfileView    (placeholder)
```

**Auth gate:** `RootView` holds `AuthViewModel` as `@StateObject`. Switches on
`isAuthenticated`. Sign-out from ProfileView will call `authViewModel.signOut()`
passed via environment or binding — no second `AuthViewModel` instance.

## 7. WeatherServiceProtocol (stub-safe interface)
Defined now so PR 3 only swaps the implementation, not the protocol shape.
```swift
protocol WeatherServiceProtocol: Sendable {
    func currentWeather() async throws -> WeatherSummary
}
struct WeatherSummary {
    let temperatureC: Double
    let condition: WeatherCondition
}
enum WeatherCondition { case sunny, cloudy, rainy, snowy, unknown }
```
Stub returns `WeatherSummary(temperatureC: 18, condition: .cloudy)`.

Mood strings keyed by condition in `Localizable.strings`:
```
"home.mood.sunny"  = "맑은 날, 카페에서 읽어보세요 ☀️"
"home.mood.cloudy" = "흐린 날씨, 실내에서 책 한 권 어때요 ☁️"
"home.mood.rainy"  = "비 오는 날엔 책이죠 🌧️"
"home.mood.snowy"  = "눈 오는 날엔 따뜻하게 책 한 권 📖"
```

## 8. Stub data (HomeViewModel, PR 1)
HomeViewModel in PR 1 returns hardcoded data. No repository injection yet.
Weekly-minutes calculation is stubbed — real logic ships in PR 2.
```swift
var weeklyMinutes: Int { 120 }
var currentBook: StubBook? { StubBook(title: "Dune", author: "Frank Herbert", progress: 0.74) }
var todayGoalMinutes: Int { 30 }
var todayReadMinutes: Int { 20 }
var queue: [StubBook] { [...] }
```
`StubBook` is a local struct inside `HomeViewModel.swift`, not a SwiftData model.
It will be deleted and replaced by real `Book` in PR 2.

## 9. Empty states (required — not deferred)
Each component handles missing data:
- **CurrentlyReadingCard (nil book):** "아직 읽고 있는 책이 없어요" + "책 추가하기" button (no-op in PR 1)
- **DailyGoalRing (no goal set):** "오늘의 목표를 설정하세요" + "설정하기" button (no-op in PR 1)
- **ReadingQueueStrip (empty queue):** hidden entirely in PR 1

## 10. Testing notes
PR 1 HomeViewModel has no logic — it returns stub constants. Tests are minimal
by design. One smoke test verifying stub values are non-nil is enough.
Real ViewModel tests (with MockBookRepository etc.) ship in PR 2.
Not gaming the hard rule — it says "ViewModel methods or business logic".
Stub accessors are not business logic.

## 11. Step-by-step execution order
1. Create `WeatherSummary.swift` + `WeatherService.swift`
2. Create `RootView.swift`
3. Create placeholder views (Library, Stats, Profile)
4. Create `HomeViewModel.swift` with stub data
5. Create Home subview components (ProfileStrip → Weather → CurrentlyReading → GoalRing → Queue)
6. Create `HomeView.swift` composing all components
7. Update `StringConstants.swift` + `Localizable.strings`
8. Update `SARAKApp.swift` — RootView as root
9. Delete `ContentView.swift`
10. Write `HomeViewModelTests.swift`
11. Build + SwiftLint + tests
12. Log entry → commit

## 12. Risks
- `ContentView.swift` deletion: Xcode synchronized groups will auto-remove it from
  the build — safe to `git rm` directly.
- `Item.swift` left in place intentionally — it will be replaced by real SwiftData
  models in PR 2. Deleting it now would require a `project.pbxproj` change.
- WeatherKit capability (entitlement) is NOT added in PR 1 — the stub doesn't need it.
  PR 3 plan will flag this as a manual Xcode step.

## 13. Definition of done
- [ ] Build passes, zero warnings
- [ ] SwiftLint passes, zero new errors
- [ ] RootView switches AuthView ↔ TabView correctly
- [ ] All 5 home components render with stub data
- [ ] All empty states render correctly (nil book, no goal)
- [ ] HomeViewModelTests written and passing
- [ ] ContentView.swift deleted
- [ ] Agent log updated before commit
