# design.md — SARAK Design System

## Purpose

SARAK adopts an editorial print-magazine aesthetic inspired by ElevenLabs: an off-white canvas floor, near-black ink text, a display serif at weight 300 as the typographic signature, and soft pastel gradient orbs used purely as atmospheric decoration. The result is quiet, high-trust, and readable — not playful, not neon, not dark-canvas dev-tools.

This document is prescriptive. All values here map directly to `UIConstants` tokens. Never inline hex codes, raw CGFloat literals, or font sizes in Views.

---

## Color Tokens

All tokens live in `UIConstants.Colors`. Reference them by name, never by hex.

### Surface

| Swift name | Hex | Use |
|---|---|---|
| `canvas` | #f5f5f5 | Off-white page floor — default `View` background |
| `canvasSoft` | #fafafa | Lighter band for subtle alternating sections |
| `surfaceCard` | #ffffff | Card background |
| `surfaceStrong` | #f0efed | Badges, avatar plates, inline chips |

### Text

| Swift name | Hex | Use |
|---|---|---|
| `ink` | #0c0a09 | Display headlines, primary text |
| `body` | #4e4e4e | Default running body text |
| `bodyStrong` | #292524 | Emphasized body, list labels |
| `muted` | #777169 | Sub-titles, secondary metadata |
| `mutedSoft` | #a8a29e | Disabled text, placeholders |
| `onPrimary` | #ffffff | Text on ink pill buttons |

### Primary Action

| Swift name | Hex | Use |
|---|---|---|
| `primary` | #292524 | Ink pill — the only CTA fill color |
| `primaryActive` | #0c0a09 | Press state on ink pill |

### Hairlines

| Swift name | Hex | Use |
|---|---|---|
| `hairline` | #e7e5e4 | Default 1pt dividers, card borders |
| `hairlineSoft` | #f0efed | Lighter panel outline |
| `hairlineStrong` | #d6d3d1 | Outline button stroke, strong panel border |

### Atmospheric Gradient Orbs

These five tokens are **atmosphere only** — see Gradient Orbs section for rules.

| Swift name | Hex | |
|---|---|---|
| `gradientMint` | #a7e5d3 | Mint green |
| `gradientPeach` | #f4c5a8 | Peach |
| `gradientLavender` | #c8b8e0 | Lavender |
| `gradientSky` | #a8c8e8 | Sky blue |
| `gradientRose` | #e8b8c4 | Rose |

### Semantic

| Swift name | Hex | Use |
|---|---|---|
| `semanticSuccess` | #16a34a | Confirmation, completion states |
| `semanticError` | #dc2626 | Validation errors, destructive states |

### Third-party Brand Exception — Kakao

`kakaoYellow` and `kakaoLabel` are mandated by Kakao's brand guidelines and must not be changed or replaced. They are exempt from the "no saturated color" rule. Do not use them for any SARAK-branded UI.

---

## Typography Tokens

All tokens live in `UIConstants.Typography` as static `Font` properties.

### Display — New York serif, weight `.light`

Uses `Font.system(size:, weight: .light, design: .serif)` which renders New York on iOS.

| Swift name | Size | Use |
|---|---|---|
| `displayMega` | 64pt | Hero headline, screen titles |
| `displayXL` | 48pt | Feature section heads |
| `displayLG` | 36pt | Section heads |
| `displayMD` | 32pt | Sub-section heads, modal titles |
| `displaySM` | 24pt | Card group titles |

### Title — SF Pro, weight `.medium`

| Swift name | Size | Use |
|---|---|---|
| `titleMD` | 20pt | Component titles, navigation bar titles |
| `titleSM` | 18pt | List row labels, form section heads |

### Body — SF Pro, weight `.regular` or `.medium`

| Swift name | Size | Weight | Use |
|---|---|---|---|
| `bodyMD` | 16pt | regular | Default body text |
| `bodyStrong` | 16pt | medium | Emphasized body, key values |
| `bodySM` | 15pt | regular | Secondary body, footer text |

### Micro

| Swift name | Size | Weight | Use |
|---|---|---|---|
| `caption` | 14pt | regular | Photo captions, helper text |
| `captionUppercase` | 12pt | semibold | Section labels, badge text |
| `button` | 15pt | medium | CTA pill label |
| `navLink` | 15pt | medium | Tab labels, navigation links |

### Rules

- **Display uses `.serif` design.** This renders New York — the editorial signature. Never substitute `.default` on display tokens.
- **Display stays at `.light` (weight 300).** Never pass `.bold` or `.heavy` to a display token. Bolding display copy shifts the voice from editorial to consumer-marketing.
- **Body and navigation use `.default` (SF Pro).** Do not drop body weight to `.light` to match the display serif — body stays at `.regular`/`.medium` for legibility.

---

## Spacing Tokens

All tokens live in `UIConstants.Spacing`. Base unit: 4pt.

| Swift name | Value | Use |
|---|---|---|
| `xxs` | 4pt | Tight internal gaps, icon padding |
| `sm` | 8pt | Component-internal spacing |
| `md` | 16pt | Standard horizontal padding, card gaps |
| `lg` | 24pt | Section-internal vertical rhythm |
| `xl` | 32pt | Wide padding, button horizontal inset |
| `xxl` | 48pt | Major section separators |
| `section` | 64pt | Vertical rhythm between full-width page bands |

`section` (64pt) is the mobile-first band rhythm. The ElevenLabs desktop spec uses 96px — do not apply that value on phone.

**Rule:** All spacing in Views must use a token. No inline `CGFloat` literals for spacing.

---

## Corner Radius Tokens

All tokens live in `UIConstants.CornerRadius`.

| Swift name | Value | Use |
|---|---|---|
| `xs` | 4pt | Inline tags, micro badges |
| `sm` | 8pt | Small UI elements, image placeholders |
| `md` | 12pt | Compact rows, form inputs |
| `lg` | 16pt | Feature cards, pricing tiers, standard cards |
| `xl` | 24pt | Gradient orb containers, extra-soft hero cards |

**Pill buttons:** use `Capsule()` clip shape — not a corner radius value. There is no `pill` constant because SwiftUI's `Capsule()` already produces the correct fully-rounded pill shape.

```swift
// Correct — pill CTA
Button("Get started") { }
    .background(UIConstants.Colors.primary)
    .foregroundColor(UIConstants.Colors.onPrimary)
    .clipShape(Capsule())

// Correct — standard card
RoundedRectangle(cornerRadius: UIConstants.CornerRadius.lg)

// Wrong — hardcoded radius
RoundedRectangle(cornerRadius: 16)
```

---

## Elevation

Two tiers only. Never introduce a third.

| Level | Treatment | Use |
|---|---|---|
| Flat (canvas) | `UIConstants.Colors.canvas` background, no shadow | Body bands, page floor |
| Card | `UIConstants.Colors.surfaceCard` background + 1pt `UIConstants.Colors.hairline` border + `.shadow(color: .black.opacity(0.04), radius: 16, x: 0, y: 4)` | Content cards |

The card shadow is subtle — `opacity: 0.04` only. Do not increase it.

```swift
// Correct card treatment
RoundedRectangle(cornerRadius: UIConstants.CornerRadius.lg)
    .fill(UIConstants.Colors.surfaceCard)
    .overlay(
        RoundedRectangle(cornerRadius: UIConstants.CornerRadius.lg)
            .stroke(UIConstants.Colors.hairline, lineWidth: 1)
    )
    .shadow(color: .black.opacity(0.04), radius: 16, x: 0, y: 4)
```

---

## Atmospheric Gradient Orbs

Gradient orbs are the brand's atmospheric pattern: soft radial pastel blooms that drift behind hero copy or feature bands. They carry visual brand voltage without competing with content.

### Usage rule

Orbs are **decoration only**. They must:
- Sit behind content in the Z-order (`.zIndex` or background modifier)
- Use `.opacity(0.35)` to `0.5` — never full opacity
- Never contain content
- Never be used as a button fill, text color, or card surface

```swift
// Correct — atmospheric orb behind a section header
ZStack {
    RadialGradient(
        colors: [UIConstants.Colors.gradientMint.opacity(0.45), .clear],
        center: .center,
        startRadius: 0,
        endRadius: 180
    )
    .frame(width: 360, height: 360)
    .blur(radius: 60)
    .allowsHitTesting(false)

    VStack { /* content */ }
}

// Wrong — orb as button background
Button("Start") { }
    .background(UIConstants.Colors.gradientMint) // Never
```

---

## Component Rules

### Primary Button

```swift
Button("Label") { }
    .font(UIConstants.Typography.button)
    .foregroundColor(UIConstants.Colors.onPrimary)
    .padding(.vertical, UIConstants.Spacing.sm)
    .padding(.horizontal, UIConstants.Spacing.xl)
    .frame(height: 44)
    .background(UIConstants.Colors.primary)
    .clipShape(Capsule())
```

Active/press state background: `UIConstants.Colors.primaryActive`.

### Outline Button

```swift
Button("Label") { }
    .font(UIConstants.Typography.button)
    .foregroundColor(UIConstants.Colors.ink)
    .padding(.vertical, UIConstants.Spacing.sm)
    .padding(.horizontal, UIConstants.Spacing.xl)
    .frame(height: 44)
    .background(.clear)
    .clipShape(Capsule())
    .overlay(Capsule().stroke(UIConstants.Colors.hairlineStrong, lineWidth: 1))
```

### Feature Card

```swift
VStack(alignment: .leading, spacing: UIConstants.Spacing.sm) {
    // content
}
.padding(UIConstants.Spacing.lg)
.background(UIConstants.Colors.surfaceCard)
.cornerRadius(UIConstants.CornerRadius.lg)
.overlay(
    RoundedRectangle(cornerRadius: UIConstants.CornerRadius.lg)
        .stroke(UIConstants.Colors.hairline, lineWidth: 1)
)
```

### Gradient Orb Card (large hero container)

```swift
ZStack {
    // Atmospheric orb behind copy
    RadialGradient(
        colors: [UIConstants.Colors.gradientLavender.opacity(0.4), .clear],
        center: .center,
        startRadius: 0,
        endRadius: 200
    )
    .blur(radius: 80)

    VStack { /* display headline + subhead */ }
}
.padding(UIConstants.Spacing.xl)
.background(UIConstants.Colors.canvasSoft)
.cornerRadius(UIConstants.CornerRadius.xl)
```

### Avatar / Voice Circle

```swift
Circle()
    .fill(UIConstants.Colors.surfaceStrong)
    .frame(width: 32, height: 32)
    .overlay(/* initials or icon */)
```

---

## Do's and Don'ts

### Do

- Use `UIConstants.Colors.primary` (ink pill) for the single primary CTA on a screen. Reserve it — one per screen maximum.
- Use `.serif` design for every display headline. `UIConstants.Typography.displayMD` and above are all `.serif`.
- Use `Capsule()` for every CTA button and badge pill.
- Use gradient orb tokens as atmospheric radial backgrounds only — behind copy, never as fills.
- Use `UIConstants.Spacing.section` (64pt) as vertical rhythm between full-width page bands.

### Don't

- Don't introduce a new saturated action color. The ink pill is the only CTA color. Exception: Kakao brand colors on the Kakao login button only.
- Don't use `.bold` or `.heavy` weight on display tokens. Display stays at `.light` — bolding shifts the brand voice.
- Don't fill a button with a gradient orb color (`gradientMint`, `gradientPeach`, etc.). They are atmosphere, not UI signals.
- Don't use a hardcoded `cornerRadius(0)` on CTAs. Every CTA uses `Capsule()`.
- Don't drop body text weight to `.light` to match the serif display. Body stays at `.regular` or `.medium`.
- Don't add a second shadow tier. The card shadow is `opacity: 0.04` — do not stack shadows.
- Don't inline hex codes or raw `CGFloat` literals for spacing, color, or typography. Use `UIConstants` tokens.

---

## Responsive Notes (iOS)

This is a phone-first iOS app. Desktop web breakpoints from the ElevenLabs spec do not apply.

| Context | Guidance |
|---|---|
| iPhone (default) | `displayMega` (64pt) reserved for launch/hero screens; use `displayLG` (36pt) for most section heads |
| Compact width (iPhone SE, split view) | Drop display one step: `displayLG` → `displayMD`, `displayMD` → `displaySM` |
| iPad | `displayMega` and `displayXL` appropriate for feature hero sections |
| Section rhythm | `section` (64pt) between full-width VStack bands |

Use SwiftUI's `@Environment(\.horizontalSizeClass)` to adapt display tokens if needed — prefer `displayLG` as the safe default on iPhone.
