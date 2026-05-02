# AUDIT_HOME_VISUAL_2026-05-02

## Baseline

Captured:

- `.harness/screenshots/home/before-20260502-233842.png`

## Findings

- The mint atmospheric orb participated in layout, producing a large empty band between the weather header and current-book card.
- Current-book content started too low in the first viewport, delaying the daily-goal and queue sections.
- The daily-goal ring was partially hidden behind the tab bar in the baseline screenshot.
- Queue items were not visible in the first viewport and needed a clearer framed treatment when they entered view.

## After

Captured:

- `.harness/screenshots/home/after-20260502-234009.png`

Result:

- Moved the orb into a non-layout background so it reads as atmosphere.
- Tightened Home vertical spacing and current-book card composition.
- Added a surface around the daily-goal ring so it aligns with the current-book card as a section.
- Framed queue books as cards; queue header and cards now appear in the first viewport.
