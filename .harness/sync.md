# Sync strategy — offline-first
# Load this when: touching SyncCoordinator, repositories, or any data write

## Rule: local is always source of truth
1. All writes → SwiftData first, always, unconditionally.
2. SyncCoordinator queues pending changes, uploads to Supabase when online.
3. Never block UI waiting for Supabase. All remote ops are background Tasks.

## Conflict resolution
- User notes/highlights: local wins
- Everything else (book metadata, progress): remote wins on conflict

## Reachability
- Use `NWPathMonitor` — never assume network state
- SyncCoordinator observes path updates and triggers sync automatically

## Sync triggers
- App foreground
- Network becomes available
- User explicitly pulls to refresh

## SyncCoordinator is restricted
- Only file allowed to touch both local + remote simultaneously
- Do NOT modify without user approval
