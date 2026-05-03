# Architecture Quick Guide

- Flow: View -> ViewModel -> Protocol -> Repository/Service.
- Views do not call repositories/services/SwiftData/Supabase/network.
- ViewModels are `@MainActor` and use injected protocols only.
- Only `SyncCoordinator` may coordinate local+remote stores.
- If adding new feature files, mirror existing feature folder structure.

Open full `.harness/architecture.md` only when adding new data flows, new repositories, or cross-feature state ownership.
