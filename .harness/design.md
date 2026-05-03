# design.md — SARAK Design System

## Purpose

SARAK adopts a quiet, monochrome editorial aesthetic: pure white canvas, near-black charcoal ink, Inter/SF Pro sans-serif for everything, and a single amber accent reserved exclusively for the active reading session. Flat surfaces dominate; only the hero card breaks with a dark fill. The result is focused and readable — content-first, not decorative.

This document is prescriptive. All values map directly to `UIConstants` tokens. Never inline hex codes, raw `CGFloat` literals, or font sizes in Views.

---

## Color Tokens

All tokens live in `UIConstants.Colors`. Reference by name, never by hex.

### Surface

| Swift name | Hex | Use |
|---|---|---|
| `canvas` | #FFFFFF | Page floor — default `View` background |
| `canvasSoft` | #FAFAFA | Lighter band for subtle alternating sections |
| `surfaceCard` | #FFFFFF | Card background (explicit alias of canvas) |
| `surfaceCompact` | #F4F4F4 | Gray card surface — goal cards, soft tiles |
| `surfaceStrong` | #EEEEEE | Pressed states, avatar plates, inline chips |

### Text

| Swift name | Hex | Use |
|---|---|---|
| `ink` | #1F1F1F | Primary text, display headlines |
| `body` | #6B6B6B | Default running body text |
| `bodyStrong` | #4A4A4A | Emphasized body, list labels |
| `muted` | #9A9A9A | Sub-titles, secondary metadata |
| `mutedSoft` | #C8C8C8 | Disabled text, placeholders |
| `onPrimary` | #FFFFFF | Text on ink pill buttons |

### On-dark (hero card)

| Swift name | Hex | Use |
|---|---|---|
| `onDark` | #FFFFFF | Primary text on dark hero surface |
| `onDarkMuted` | #B5B5B5 | Author, secondary text on dark |
| `onDarkSoft` | #9A9A9A | Uppercase labels on dark hero |
| `darkTrack` | #3A3A3A | Progress track background on dark hero |

### Primary Action

| Swift name | Hex | Use |
|---|---|---|
| `primary` | #1F1F1F | Dark CTA fill — the only primary button color |
| `primaryActive` | #0F0F0F | Press state on dark CTA |

### Hairlines

| Swift name | Hex | Use |
|---|---|---|
| `hairline` | #E6E6E6 | Default 1pt dividers, card borders, ring tracks |
| `hairlineSoft` | #EEEEEE | Lighter panel outline |
| `hairlineStrong` | #D0D0D0 | Outline button stroke, strong panel border |

### Accent

| Swift name | Hex | Use |
|---|---|---|
| `accent` | #FFE6A8 | Session-active state **only** — never decorative |

The amber accent appears only when a reading session is running. It is a state indicator, not a brand color. Never apply it to idle UI.

### Book Cover Placeholder Tones

| Swift name | Hex | Use |
|---|---|---|
| `coverWarm` | #E8DDD0 | Warm placeholder for mini covers |
| `coverCool` | #D8DEE8 | Cool placeholder for mini covers |
| `coverSage` | #E2E2DA | Neutral sage placeholder |
| `coverInk` | #1F1F1F | Dark placeholder (use `onDark` for label text) |

### Semantic

| Swift name | Hex | Use |
|---|---|---|
| `semanticSuccess` | #16a34a | Confirmation, completion states |
| `semanticError` | #dc2626 | Validation errors, destructive states |

### Third-party Brand Exception — Kakao

`kakaoYellow` and `kakaoLabel` are mandated by Kakao's brand guidelines. Do not change, replace, or use for any SARAK UI.

---

## Typography Tokens

All tokens live in `UIConstants.Typography` as static `Font` properties. All use SF Pro (`.system` without `design:` parameter).

### Display

| Swift name | Size | Weight | Use |
|---|---|---|---|
| `displayMD` | 26pt | bold | Hero greetings, book titles — largest display |
| `displaySM` | 22pt | semibold | Section heads, modal titles |

### Title

| Swift name | Size | Weight | Use |
|---|---|---|---|
| `titleMD` | 20pt | semibold | Component titles, navigation bar titles |
| `titleSM` | 18pt | semibold | List row labels, form section heads |

### Body

| Swift name | Size | Weight | Use |
|---|---|---|---|
| `bodyMD` | 14pt | regular | Default body text |
| `bodyStrong` | 14pt | semibold | Emphasized body, key values |
| `bodySM` | 13pt | regular | Secondary body, metadata |

### Micro

| Swift name | Size | Weight | Use |
|---|---|---|---|
| `caption` | 12pt | regular | Helper text, subtitles |
| `captionUppercase` | 10pt | semibold | Section eyebrows, badge labels (uppercase) |
| `button` | 14pt | semibold | CTA pill label |
| `navLink` | 15pt | medium | Tab labels, navigation links |

### Rules

- **No serif fonts.** All text uses SF Pro (`.system` without `design: .serif`).
- **26pt is the maximum.** `displayMD` is the ceiling — never exceed it.
- **Body stays at `.regular` or `.semibold`.** Do not use `.light` for body text — legibility degrades.
- **`captionUppercase` is always uppercased in the View.** Apply `.textCase(.uppercase)` or use `.uppercased()`.

---

## Spacing Tokens

All tokens live in `UIConstants.Spacing`. Base unit: 4pt.

| Swift name | Value | Notes |
|---|---|---|
| `xxs` | 4pt | Tight internal gaps |
| `sm` | 8pt | Component-internal spacing |
| `xs` | 10pt | Extra-tight padding |
| `cardPaddingTight` | 12pt | Tight card padding |
| `smd` | 14pt | Between sm and md |
| `md` | 16pt | Standard horizontal padding, card gaps |
| `cardPaddingCompact` | 16pt | Default card padding |
| `smx` | 18pt | Card inner padding for wider items |
| `buttonHorizontal` | 20pt | Button horizontal inset |
| `lgs` | 22pt | Section-internal rhythm |
| `lg` | 24pt | Section-internal vertical rhythm |
| `lgx` | 28pt | Generous section separation |
| `xl` | 32pt | Wide padding |
| `xxl` | 48pt | Major section separators |
| `section` | 64pt | Vertical rhythm between full-width page bands |

**Rule:** All spacing in Views must use a token. No inline `CGFloat` literals.

---

## Corner Radius Tokens

All tokens live in `UIConstants.CornerRadius`.

| Swift name | Value | Use |
|---|---|---|
| `xs` | 6pt | Inline tags, micro badges |
| `sm` | 8pt | Book cover thumbnails |
| `md` | 12pt | Compact rows, form inputs |
| `lg` | 14pt | Buttons (non-pill), small cards |
| `cardCompact` | 16pt | Standard cards |
| `xl` | 20pt | Hero cards, large containers |

**Pill buttons:** use `Capsule()` clip shape — no radius constant. `Capsule()` produces the correct fully-rounded shape.

```swift
// Correct — pill CTA
Button("Start reading session") { }
    .background(UIConstants.Colors.primary)
    .foregroundColor(UIConstants.Colors.onPrimary)
    .clipShape(Capsule())

// Correct — standard card
RoundedRectangle(cornerRadius: UIConstants.CornerRadius.cardCompact)

// Correct — hero card
RoundedRectangle(cornerRadius: UIConstants.CornerRadius.xl)

// Wrong — hardcoded
RoundedRectangle(cornerRadius: 16)
```

---

## Elevation

Three tiers. Use the lowest appropriate tier.

| Level | Treatment | Use |
|---|---|---|
| Flat | `canvas` background, no shadow | Body bands, page floor |
| Card | `surfaceCard` or `surfaceCompact` background + 1pt `hairline` border + `shadow(color: .black.opacity(0.06), radius: 3, x: 0, y: 1)` | Content cards, goal cards |
| Cover | No border + `shadow(color: .black.opacity(0.12), radius: 16, x: 0, y: 6)` | Book cover art, floating surfaces |

```swift
// Correct card treatment (via .compactCard() modifier)
VStack { }
    .compactCard()

// Correct hero card treatment
RoundedRectangle(cornerRadius: UIConstants.CornerRadius.xl, style: .continuous)
    .fill(UIConstants.Colors.ink)
```

---

## Component Rules

### Hero "Continue Reading" Card

- Background: `UIConstants.Colors.ink` (#1F1F1F)
- Corner radius: `UIConstants.CornerRadius.xl` (20pt)
- Padding: `UIConstants.Spacing.smx` (18pt) horizontal, `UIConstants.Spacing.md` (16pt) vertical
- Label: `captionUppercase` + `onDarkSoft`
- Title: `displaySM` + `onDark`
- Author: `bodySM` + `onDarkMuted`
- Progress track: 4pt height, `darkTrack` background, `onDark` fill
- CTA button: `canvas` background normally; `accent` background when session active

### Goal Card

- Background: `surfaceCompact` (#F4F4F4)
- Corner radius: `cardCompact` (16pt)
- Padding: `cardPaddingCompact` (16pt) × `smx` (18pt)
- Title: `titleSM` or `bodyStrong` + `ink`
- Subtitle: `caption` + `body`
- Progress ring: 48pt, `hairline` track, `ink` progress stroke

### Primary CTA Button

```swift
Button("Label") { }
    .font(UIConstants.Typography.button)
    .foregroundColor(UIConstants.Colors.onPrimary)
    .frame(minHeight: UIConstants.Size.buttonHeight)
    .padding(.horizontal, UIConstants.Spacing.buttonHorizontal)
    .background(UIConstants.Colors.primary)
    .clipShape(Capsule())
```

Press state background: `UIConstants.Colors.primaryActive`.

### Icon Circle Button (32pt)

```swift
Image(systemName: "gearshape")
    .frame(width: UIConstants.Size.iconCircle, height: UIConstants.Size.iconCircle)
    .background(UIConstants.Colors.surfaceCompact)
    .clipShape(Circle())
```

### Section Header

```swift
HStack {
    Text("Your goals")
        .font(UIConstants.Typography.titleSM)
        .foregroundStyle(UIConstants.Colors.ink)
    Spacer()
    Button("Edit") { }
        .font(UIConstants.Typography.caption)
        .foregroundStyle(UIConstants.Colors.body)
}
```

---

## Principles

### One dark surface per screen

The hero "Continue Reading" card is the only `ink`-filled block. Everything else stays light. One dark anchor makes the focal point unambiguous.

### Earn the accent

`accent` (#FFE6A8) appears only when a session is running. It is a live state, not decoration. Never apply it to static or idle elements.

### Whitespace over rules

Sections separate by spacing (`lgx`/`xl`, 28–32pt) and quiet headers — not borders. Reserve `hairline` dividers for inside dense components (metadata rows, form fields).

### Flat-first

Use the Card elevation tier only for actual content cards. Never stack shadows. Avoid elevation theatre.

---

## Do's and Don'ts

### Do

- Use `UIConstants.Colors.primary` for the single primary CTA per screen. One per screen maximum.
- Use `Capsule()` for every CTA button.
- Use `UIConstants.CornerRadius.xl` (20pt) for hero/prominent cards.
- Use `UIConstants.CornerRadius.cardCompact` (16pt) for standard content cards.
- Use `UIConstants.Colors.accent` only when a reading session is active.
- Use `UIConstants.Spacing.section` (64pt) as vertical rhythm between full-width page bands.

### Don't

- Don't use serif fonts. SF Pro only.
- Don't exceed 26pt (`displayMD`) for any headline.
- Don't use `accent` on idle or decorative UI.
- Don't introduce a second saturated action color. Exception: Kakao brand colors on the Kakao login button only.
- Don't add a second shadow tier. `opacity: 0.06, radius: 3` is the card shadow ceiling.
- Don't inline hex codes or raw `CGFloat` literals. Use `UIConstants` tokens.
- Don't use `.light` font weight for body text.
