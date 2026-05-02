# Active Task — Home Tab Shell (PR 1 of 3)
# Branch: feat/home-tab-shell
# Started: 2026-05-02
# Status: IN PROGRESS — paused at step 5/11

---

## Plan reference
`.harness/plans/PLAN_HOME_TAB_SHELL_2026-05-02.md`

---

## Progress

### ✅ Done
| File | Notes |
|------|-------|
| `SARAK/Models/WeatherSummary.swift` | `WeatherSummary` struct + `WeatherCondition` enum |
| `SARAK/Services/WeatherService.swift` | `WeatherServiceProtocol` + `StubWeatherService` |
| `SARAK/Features/Root/RootView.swift` | Auth gate — `@StateObject AuthViewModel`, switches AuthView ↔ MainTabView |
| `SARAK/Features/Root/MainTabView.swift` | 4-tab TabView, passes `authViewModel` to ProfileView |
| `SARAK/Features/Library/LibraryView.swift` | Placeholder |
| `SARAK/Features/Stats/StatsView.swift` | Placeholder |
| `SARAK/Features/Profile/ProfileView.swift` | Sign-out button wired to `authViewModel.signOut()` |
| `SARAK/Features/Home/HomeViewModel.swift` | Stub data: `StubBook`, `weeklyMinutes`, `currentBook`, `todayGoalMinutes`, `todayReadMinutes`, `queue`, `loadWeather()` |
| `SARAK/Features/Home/Components/ProfileStripView.swift` | Name + weekly minutes |
| `SARAK/Features/Home/Components/WeatherHeaderView.swift` | Date, temp, condition, mood string |
| `SARAK/Features/Home/Components/CurrentlyReadingCard.swift` | Book cover, progress, last-read, CTA; nil empty state |

### ✏️ Modified
| File | Change |
|------|--------|
| `SARAK/Features/Auth/AuthView.swift` | `@StateObject` → `@ObservedObject var viewModel: AuthViewModel` (RootView now owns the instance) |

---

## ⏸ Remaining work

### Waiting on user design input
- `SARAK/Features/Home/Components/DailyGoalRing.swift` — **DO NOT implement until user specifies design**
- `SARAK/Features/Home/Components/ReadingQueueStrip.swift` — **DO NOT implement until user specifies design**

### Ready to implement (unblocked once above are done)
| File | Notes |
|------|-------|
| `SARAK/Features/Home/HomeView.swift` | Composes all 5 components — blocked on DailyGoalRing + ReadingQueueStrip |
| `SARAK/Constants/StringConstants.swift` | Add `Tab`, `Home`, `WeatherMood` namespaces |
| `SARAK/Resources/Localizable.strings` | Add tab + home + mood strings |
| `SARAK/SARAKApp.swift` | Replace `AuthView()` root with `RootView()` |
| `SARAK/ContentView.swift` | Delete |
| `SARAKTests/HomeViewModelTests.swift` | Minimal smoke tests |

---

## String keys needed (not yet in StringConstants or Localizable.strings)

```
StringConstants.Tab.home / .library / .stats / .profile
StringConstants.Home.greeting
StringConstants.Home.weeklyMinutesFormat        // "이번 주 %d분 읽었어요"
StringConstants.Home.progressFormat             // "%d%% 읽음"
StringConstants.Home.startSession               // "독서 시작"
StringConstants.Home.noCurrentBook             // "아직 읽고 있는 책이 없어요"
StringConstants.Home.addBook                   // "책 추가하기"
StringConstants.Home.goalProgressFormat        // "%d / %d분"
StringConstants.Home.dailyGoalLabel            // "오늘의 목표"
StringConstants.Home.noGoalSet                 // "오늘의 목표를 설정하세요"
StringConstants.Home.setGoal                   // "설정하기"
StringConstants.Home.readingQueue              // "읽을 책"
StringConstants.WeatherMood.sunny              // "맑은 날, 카페에서 읽어보세요 ☀️"
StringConstants.WeatherMood.cloudy             // "흐린 날씨, 실내에서 책 한 권 어때요 ☁️"
StringConstants.WeatherMood.rainy              // "비 오는 날엔 책이죠 🌧️"
StringConstants.WeatherMood.snowy              // "눈 오는 날엔 따뜻하게 책 한 권 📖"
```

---

## Current build state
SourceKit errors present — expected. `StringConstants.Tab/Home/WeatherMood` and `HomeView` don't exist yet. Build will not pass until all remaining files are in place.

---

## Definition of done (from plan §13)
- [ ] Build passes, zero warnings
- [ ] SwiftLint passes, zero new errors
- [ ] RootView switches AuthView ↔ TabView correctly
- [ ] All 5 home components render with stub data
- [ ] All empty states render correctly (nil book, no goal)
- [ ] HomeViewModelTests written and passing
- [ ] ContentView.swift deleted
- [ ] Agent log updated before commit
