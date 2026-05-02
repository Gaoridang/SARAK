# Off-limits files
# Load this when: before any code change, and whenever unsure if a file is safe to modify

## Purpose

Some files are high-risk.

Do not modify these files without explicit user approval.

If a task appears to require changing one of these files, stop before editing.

---

## Never touch without explicit user approval

- `Secrets.swift`
- `*.xcconfig`
- `SARAK.xcodeproj/project.pbxproj`
- `**/Migrations/`
- `SARAK/Services/SyncCoordinator.swift`

---

## Why these files are protected

### `Secrets.swift`

May contain API keys or secret configuration.

Rules:

- Never commit secrets.
- Never print secrets.
- Never move secrets into source files.
- Never hardcode secrets elsewhere as a workaround.

---

### `*.xcconfig`

Build configuration files are high-impact.

Changing them can affect:

- environments
- build settings
- signing
- deployment
- secrets
- compiler behavior

Do not edit without approval.

---

### `SARAK.xcodeproj/project.pbxproj`

Do not hand-edit the Xcode project file.

This project uses Xcode 16 synchronized folder groups.

Rules:

- Add Swift files directly under `SARAK/`.
- Let Xcode auto-discover files.
- Do not manually add or remove file references in `project.pbxproj`.

Allowed exception:

- Xcode or Swift Package Manager may update this file automatically during approved package or project configuration changes.

Manual editing is not allowed.

---

### `**/Migrations/`

Migration files are data-safety critical.

Changing migrations can corrupt existing user data or break upgrade paths.

Do not edit, delete, rename, or regenerate migrations without explicit approval.

---

### `SARAK/Services/SyncCoordinator.swift`

SyncCoordinator is core offline-first infrastructure.

It controls:

- local/remote coordination
- pending change upload
- conflict resolution
- retry behavior
- network-triggered sync

Do not modify without explicit approval.

A plan may mention that SyncCoordinator changes are needed, but implementation must stop before editing this file.

---

## If you need to touch an off-limits file

Follow this protocol exactly:

1. Stop coding.
2. State the exact file path.
3. Explain the required change.
4. Explain why the change is necessary.
5. Explain why there is no safer alternative.
6. Wait for explicit user approval.

Do not make the change silently.

---

## Safer alternatives to check first

Before requesting approval, consider whether the task can be solved by:

- adding a new Swift file under `SARAK/`
- changing a ViewModel instead of project settings
- injecting a protocol instead of modifying sync core
- adding a wrapper service instead of changing secrets/config
- creating a plan for a later migration instead of editing migration files now
- using Xcode synchronized groups instead of editing `project.pbxproj`

---

## Review checklist

Before finishing any PR, verify:

- [ ] No off-limits file was modified without approval
- [ ] No manual `project.pbxproj` edit was made
- [ ] No secrets were added, moved, printed, or committed
- [ ] No migration file was edited without approval
- [ ] `SyncCoordinator.swift` was not modified without approval
- [ ] Any required off-limits change was documented and approved first
