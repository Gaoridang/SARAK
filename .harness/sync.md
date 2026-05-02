# Sync strategy — offline-first
# Load this when: touching SyncCoordinator, repositories, data writes, offline behavior, or conflict handling

## Purpose

This app is offline-first.

Local SwiftData is the immediate source of truth for the UI.

Remote Supabase sync should happen in the background and must not block normal app usage.

---

## Core rule

Local is always the first write target.

For user-generated writes:

1. Write to SwiftData first.
2. Record a pending sync change.
3. Return control to the UI.
4. SyncCoordinator uploads to Supabase when possible.
5. Remote failure must not undo the successful local write.

The UI must not wait for Supabase before showing the user’s change.

---

## Layer ownership

Only SyncCoordinator may coordinate local and remote stores together.

Allowed:

- SyncCoordinator reads pending local changes.
- SyncCoordinator calls local repositories.
- SyncCoordinator calls remote repositories.
- SyncCoordinator resolves conflicts.
- SyncCoordinator retries failed uploads.

Not allowed:

- ViewModel calling both local and remote repositories.
- View calling any repository.
- LocalRepository calling RemoteRepository.
- RemoteRepository calling LocalRepository.
- Service coordinating local and remote persistence unless explicitly approved.

Do not modify `SyncCoordinator.swift` without explicit user approval.

A plan may mention SyncCoordinator changes, but implementation must stop before editing that file.

---

## Repository responsibilities

Local repositories:

- write to SwiftData
- read from SwiftData
- expose local data to ViewModels or SyncCoordinator through protocols
- do not import Supabase
- do not perform network calls

Remote repositories:

- read/write Supabase data
- map remote DTOs to domain models
- do not import SwiftUI
- do not access SwiftData ModelContext
- do not update UI state

SyncCoordinator:

- observes pending changes
- uploads local changes
- fetches remote changes
- handles conflicts
- handles retries
- responds to network/app lifecycle triggers

---

## Write flow

Preferred write flow for user actions:

View
→ ViewModel
→ LocalRepositoryProtocol
→ SwiftData write
→ pending sync change recorded
→ UI updates immediately
→ SyncCoordinator uploads later

ViewModel should expose success once the local write succeeds.

Remote sync status may be shown separately if needed, but it should not block the user action.

---

## Read flow

Default read flow:

View
→ ViewModel
→ LocalRepositoryProtocol
→ SwiftData read
→ UI renders local data

Remote refresh flow:

1. UI triggers refresh, app enters foreground, or network becomes available.
2. SyncCoordinator fetches remote updates.
3. SyncCoordinator merges updates into SwiftData.
4. UI updates from local SwiftData state.

ViewModels should normally read local data, not remote data directly.

Exceptions require explicit architectural justification.

---

## Pending change queue

All offline-first writes should record a pending change.

Suggested pending change fields:

- `id`
- `entityType`
- `entityID`
- `operation`
- `payload`
- `createdAt`
- `updatedAt`
- `retryCount`
- `lastError`
- `status`

Suggested operations:

- `create`
- `update`
- `delete`

Suggested statuses:

- `pending`
- `uploading`
- `failed`
- `synced`

Pending changes should be durable, not memory-only.

---

## Delete behavior

Deletes must be sync-safe.

Use tombstones for user-deleted synced entities.

Rules:

- Do not immediately hard-delete synced entities if remote deletion is still pending.
- Mark the entity as deleted locally.
- Queue a pending delete change.
- Hide tombstoned entities from normal UI.
- Hard-delete only after remote deletion is confirmed or cleanup policy allows it.

Tombstone fields may include:

- `isDeleted`
- `deletedAt`
- `pendingDelete`

Unsynced local-only entities may be hard-deleted if they have never been uploaded.

---

## Conflict resolution

Conflict rules must be deterministic.

Default rules:

- Notes and highlights: local wins.
- Reading sessions: append-only where possible.
- Reading progress: latest `updatedAt` wins unless session history allows recalculation.
- Book metadata from external or remote sources: remote wins.
- User-customized book fields: local wins.
- Deletions: tombstone wins unless the remote version has a newer explicit restore action.

Do not silently overwrite user-generated local data.

If a conflict cannot be safely resolved, keep the local version and record a sync error for later handling.

---

## Updated timestamps

Synced entities should have stable timestamps where possible.

Recommended fields:

- `createdAt`
- `updatedAt`
- `lastSyncedAt`
- `deletedAt` when tombstoned

Rules:

- Update `updatedAt` when user-visible data changes.
- Do not update `updatedAt` only because sync metadata changed.
- Use timestamps consistently for conflict resolution.
- Avoid relying on device time alone if remote authoritative timestamps are available.

---

## Network handling

Use `NWPathMonitor` for reachability.

Never assume the network is available.

Rules:

- Remote operations may fail at any time.
- Offline state should not crash the app.
- Failed remote operations should be retried later.
- Retry behavior should avoid infinite tight loops.
- UI should remain usable when offline.

---

## Sync triggers

Sync may be triggered by:

- app entering foreground
- network becoming available
- user pull-to-refresh
- successful local write
- scheduled/background opportunity, if later approved

Do not trigger heavy sync repeatedly without throttling or deduplication.

---

## Retry behavior

Failed sync attempts should be retried safely.

Recommended behavior:

- increment `retryCount`
- store `lastError`
- keep status as `failed` or `pending`
- retry when network returns or user explicitly refreshes
- use backoff for repeated failures where appropriate

Do not spin in a tight retry loop.

Do not delete pending changes only because upload failed.

---

## UI sync state

The UI should primarily reflect local data.

Optional sync state may be exposed as:

- syncing indicator
- last synced time
- offline banner
- non-blocking error message
- retry button

Do not show raw Supabase errors to users.

Do not block reading, editing, or local navigation because sync is pending.

---

## Supabase relationship

Supabase is the remote sync target.

Rules:

- Remote repositories perform Supabase calls.
- SyncCoordinator decides when to call remote repositories.
- ViewModels should not call Supabase directly.
- ViewModels should not instantiate remote repositories directly.
- RLS must remain enabled.
- Service role keys must never be used in the app.

Follow `supabase.md`.

---

## Testing sync behavior

Sync-related tests should cover:

- local write succeeds while remote is offline
- pending change is created
- pending change uploads when network returns
- failed upload increments retry count
- delete creates tombstone
- tombstoned item is hidden from normal UI
- conflict resolution for local-wins data
- conflict resolution for remote-wins data
- no duplicate upload after successful sync

Use in-memory SwiftData for local tests.

Do not test against production Supabase.

---

## Stop conditions

Stop and ask before implementing if:

- `SyncCoordinator.swift` must be modified
- conflict behavior is unclear
- schema changes are required
- migration files are required
- remote delete behavior is ambiguous
- data loss is possible
- a ViewModel seems to need both local and remote repositories

---

## Checklist

Before finishing a PR touching sync or writes, verify:

- [ ] Local write happens before remote sync
- [ ] UI does not wait for Supabase
- [ ] Pending sync change is recorded
- [ ] Offline state is handled gracefully
- [ ] Delete behavior is tombstone-safe
- [ ] Conflict rule is explicit
- [ ] ViewModel does not coordinate local and remote directly
- [ ] Local repository does not import Supabase
- [ ] Remote repository does not access SwiftData ModelContext
- [ ] SyncCoordinator was not modified without approval
- [ ] Tests cover local write, pending sync, failure, and conflict behavior where relevant
