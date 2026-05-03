# Working Tree Snapshot — MVP Reading Interactions + Supabase Schema
# Created: 2026-05-03
# Branch: feat/mvp-reading-interactions-supabase

## Initial status
```text
 M SARAK/Constants/UIConstants.swift
 M SARAK/Features/Auth/AuthView.swift
 M SARAK/Features/Home/Components/CurrentlyReadingCard.swift
 M SARAK/Features/Home/Components/ReadingQueueStrip.swift
 M SARAK/Features/Home/HomeView.swift
 M SARAK/Features/Profile/ProfileView.swift
 M SARAK/Features/Shared/Components/EmptyStateCard.swift
?? SARAK/Features/Shared/Components/CompactDesignStyles.swift
?? UI/
```

## Relevant existing code
- Supabase client/auth already exist in `SupabaseService.swift` and `AuthService.swift`.
- Home data is currently stubbed in `HomeViewModel.swift`.
- `LibraryView.swift` and `StatsView.swift` are placeholders.
- `SyncCoordinator.swift` is empty but off-limits without explicit approval.

## Harness constraints
- Dedicated branch created.
- Plan checklist created before implementation.
- Supabase SQL will be generated under `.harness/supabase/`, not `SARAK/` or a protected migrations folder.
- Existing compact-design work is preserved.
