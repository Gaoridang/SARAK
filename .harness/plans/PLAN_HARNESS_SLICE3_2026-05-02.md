# Plan: Harness Compliance — PR Slice 3
**Date:** 2026-05-02
**Branch:** audit/harness-compliance-2026-05-02
**Audit source:** `.harness/audits/AUDIT_HARNESS_COMPLIANCE_2026-05-02.md`
**Violations addressed:** V-08, V-09, V-10 (doc only), V-11

---

## Scope

| V-ID | Description | Action |
|---|---|---|
| V-08 | `sm`/`md`/`lg`/`xl` abbreviated constant names | Document as approved exception in `conventions.md` |
| V-09 | `Item.swift` boilerplate in production schema | Delete `Item.swift`; remove `ModelContainer` scaffolding from `SARAKApp.swift` |
| V-10 | `SARAKApp` → `SupabaseService` coupling | Acknowledge in agent log — no code change |
| V-11 | Empty `SARAKTests/SARAKTests.swift` boilerplate | Delete file |

---

## V-08 decision: document exception rather than rename

Rationale: `sm`/`md`/`lg`/`xl` are used across every View file in the project. A rename would touch ~10 files with no functional benefit. The harness already carves an exception — "unless already established across the project." At this stage they are established. The right action is to formally record the exception in `conventions.md` so future agents do not flag it.

---

## V-09 detail

`Item.swift` is Xcode-generated boilerplate with no domain meaning. It is the only model currently registered in the `ModelContainer` schema in `SARAKApp.swift`.

Since no real SwiftData models exist yet and no View uses `@Query` or `@Environment(\.modelContext)`, the safest path is:
- Delete `SARAK/Item.swift`
- Remove `sharedModelContainer` property and `.modelContainer(sharedModelContainer)` modifier from `SARAKApp.swift`
- Remove `import SwiftData` from `SARAKApp.swift`

The `ModelContainer` will be re-added in PR 2 once real domain models (`Book`, etc.) are defined.

---

## Files to modify / delete

| File | Change |
|---|---|
| `SARAK/Item.swift` | **Delete** |
| `SARAK/SARAKApp.swift` | Remove `sharedModelContainer`, `.modelContainer(...)`, `import SwiftData` |
| `.harness/conventions.md` | Add approved-exception note for `sm/md/lg/xl` spacing constant names |
| `SARAKTests/SARAKTests.swift` | **Delete** |

## Files NOT touched

All off-limits files, and all files not listed above.

---

## Constraints checklist

- [ ] No off-limits files touched
- [ ] No force unwraps
- [ ] `SARAKApp.swift` remains buildable after `Item` removal
- [ ] No tests required (deleting boilerplate/unused model)
