# Visual Review Harness

## Home screenshot workflow

Capture Home before and after any visual polish that affects the first authenticated tab.

1. Run `.harness/scripts/capture-home-screenshot.sh --label before`.
2. Inspect the PNG in `.harness/screenshots/home/`.
3. Record concrete findings in `.harness/audits/`.
4. Apply the smallest Home-only polish pass needed to address the findings.
5. Run `.harness/scripts/capture-home-screenshot.sh --label after`.
6. Record the result in `.harness/logs/agent.log.md`.

## Inspection checklist

- The canvas fills the full safe area and does not flash white behind the tab bar.
- Atmospheric gradients sit behind content and do not read as tappable UI.
- The profile/weather header, current book, daily goal, and reading queue form clear sections.
- Primary and secondary actions have enough breathing room on iPhone 17.
- Text does not truncate unexpectedly, overlap, or crowd controls.
- Queue items look intentionally framed and remain scannable in horizontal scroll.

## Constraints

- Home-only visual changes unless a screenshot blocker requires a harness or DEBUG-only auth change.
- Keep stub data and behavior unchanged.
- Use existing `UIConstants` and localized strings.
- Do not commit generated screenshots or derived data.
