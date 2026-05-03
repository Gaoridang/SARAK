# Supabase Login Sync Plan

- **Branch:** `feat/supabase-login-sync`
- **Owner:** Codex
- **Last update:** 2026-05-03 23:04 KST

## Summary

Connect logged-in users to Supabase with the app's local-first sync architecture. Views keep reading SwiftData; login and app entry trigger background sync that uploads pending local changes and imports remote rows.

## Checklist

- [x] Read `CLAUDE.md` and required harness docs.
- [x] Inspect current auth, repository, and sync wiring.
- [x] Create dedicated task branch.
- [x] Add auth callback refresh support.
- [x] Add local merge APIs for remote imports.
- [x] Extend sync trigger and coordinator for login sync.
- [x] Update Supabase schema SQL for current book fields.
- [x] Add/update tests.
- [x] Run build, SwiftLint, and tests.

## Implementation Notes

- Keep `Supabase` imports restricted to approved files.
- Do not route Views or ViewModels to remote repositories directly.
- Remote imports must not enqueue pending sync changes.
- Preserve local rows that still have pending sync changes.
