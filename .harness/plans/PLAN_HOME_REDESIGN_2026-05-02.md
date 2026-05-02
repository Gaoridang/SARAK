# PLAN_HOME_REDESIGN_2026-05-02

## Goal

Apply `UIConstants` design tokens to `HomeView` and its 5 components. No behaviour changes — token wiring only.

## Scope

- `SARAK/Features/Home/HomeView.swift`
- `SARAK/Features/Home/Components/ProfileStripView.swift`
- `SARAK/Features/Home/Components/WeatherHeaderView.swift`
- `SARAK/Features/Home/Components/CurrentlyReadingCard.swift`
- `SARAK/Features/Home/Components/DailyGoalRing.swift`
- `SARAK/Features/Home/Components/ReadingQueueStrip.swift`

Out of scope: AuthView, LibraryView, StatsView, ProfileView (deferred).

## User decisions

| Question | Decision |
|---|---|
| Which views? | Home + components only |
| Primary CTA on HomeView? | Start Session → ink pill; Add Book / Set Goal → outline |
| Kakao button shape? | Keep RoundedRectangle (brand-mandated) |

## Token swaps

### HomeView.swift
- ScrollView `.background(UIConstants.Colors.canvas)`
- Restructure to `VStack(spacing: 0)` with explicit per-band padding
- Header band: `ZStack` wrapping ProfileStrip + WeatherHeader with `RadialGradient(gradientMint.opacity(0.45))` blurred 60, `allowsHitTesting(false)`
- `Spacing.section` (64pt) top-padding before CurrentlyReadingCard
- `Spacing.xxl` before DailyGoalRing and ReadingQueueStrip

### ProfileStripView.swift
- Greeting: `.title2+.bold` → `Typography.displaySM`
- Subtext: `.subheadline+.secondary` → `Typography.caption` + `Colors.muted`
- Spacing `2` → `Spacing.xxs`

### WeatherHeaderView.swift
- Date: `.subheadline+.secondary` → `Typography.caption` + `Colors.muted`
- Temp: `.headline` → `Typography.bodyStrong` + `Colors.bodyStrong`
- Mood: `.subheadline+.secondary` → `Typography.bodySM` + `Colors.muted`

### CurrentlyReadingCard.swift
- Card surface: `secondarySystemBackground` → `Colors.surfaceCard`, radius `.md` → `.lg`, add hairline 1pt stroke + shadow opacity 0.04
- Placeholder: `Color.secondary.opacity(0.2)` → `Colors.surfaceStrong`
- Title: `.headline` → `Typography.titleSM` + `Colors.ink`
- Author: `.subheadline` → `Typography.bodySM` + `Colors.muted`
- Progress: `.caption` → `Typography.caption` + `Colors.muted`
- Start Session: `.borderedProminent` → ink-pill (`Colors.primary` fill, `Capsule()`)
- Add Book (empty state): outline button (`Capsule` stroke `hairlineStrong`)

### DailyGoalRing.swift
- Track: `Color.secondary.opacity(0.2)` → `Colors.hairlineSoft`
- Fill: `Color.accentColor` → `Colors.primary`
- Centre label: `.system(.callout, design: .rounded)` → `Typography.bodyStrong`
- Sub-label: `.caption2` → `Typography.captionUppercase`
- Spacing `2` → `Spacing.xxs`
- Set Goal (empty state): outline button

### ReadingQueueStrip.swift
- Header: `.headline` → `Typography.titleSM` + `Colors.ink`
- Placeholder: `Color.secondary.opacity(0.2)` → `Colors.surfaceStrong`
- Book title: `.font(.caption)` → `.font(UIConstants.Typography.caption)`

## Verification

1. `xcodebuild -scheme SARAK -destination 'name=iPhone 17' build`
2. `swiftlint lint --quiet`
3. Visual: canvas BG, New York serif greeting, mint orb, card elevation, ink/outline CTAs, ring colors
