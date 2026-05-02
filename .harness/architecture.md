# Architecture — MVVM strict
# Load this when: adding features, creating files, refactoring

## Purpose

This app uses strict MVVM with protocol-based dependencies.

The goal is to keep UI, state, persistence, remote calls, and sync logic clearly separated.

---

## Layer diagram

View
  → ViewModel
    → injected Protocol
      → LocalRepository | RemoteRepository | Service
        → SyncCoordinator only when local and remote coordination is required

---

## Core rule

Dependencies point inward and downward.

Higher layers may depend on protocols.
Higher layers must not depend on concrete lower-layer implementations.

Views know about ViewModels.
ViewModels know about protocols.
Repositories and services do the actual data/system work.

---

## View rules

Views are SwiftUI-only.

Views may:

- render UI
- bind to ViewModel state
- call ViewModel intent methods
- hold local UI-only state such as selected tab, sheet visibility, or animation state
- use `@StateObject`, `@ObservedObject`, `@EnvironmentObject`, or `@Bindable` appropriately

Views must not:

- contain business logic
- import Supabase
- call repositories directly
- call services directly
- call SwiftData `ModelContext` directly
- perform network requests
- create duplicate shared app-state ViewModels

A View should answer:

- What does the user see?
- What user intent happened?

A View should not answer:

- How is data fetched?
- How is data saved?
- How is sync performed?
- How is business logic calculated?

---

## ViewModel rules

One screen usually has one ViewModel named `<Feature>ViewModel`.

All ViewModels must be `@MainActor`.

ViewModels may:

- expose UI state with `@Published`
- expose loading state
- expose user-safe errors
- call injected repository protocols
- call injected service protocols
- transform domain data into display data
- coordinate UI-level workflows

ViewModels must not:

- import Supabase
- depend on concrete repositories
- depend on concrete services
- access SwiftData `ModelContext` directly
- perform direct network requests
- contain large reusable business logic that belongs in a service
- touch both local and remote repositories directly

Required baseline state shape for data-loading ViewModels:

- `@Published var isLoading: Bool`
- `@Published var errorMessage: String?`

Use additional `@Published` properties as needed for feature state.

---

## Dependency injection rule

ViewModels depend on injected protocols only.

Allowed protocol dependency types:

- Repository protocols for persisted app data
- Service protocols for non-persistence/system operations
- Lightweight helper protocols when useful for testing

Examples:

- `BookRepositoryProtocol`
- `ReadingSessionRepositoryProtocol`
- `WeatherServiceProtocol`
- `TimerServiceProtocol`
- `AuthServiceProtocol`

Disallowed:

- `LocalBookRepository`
- `RemoteBookRepository`
- `SupabaseService.client`
- `ModelContext`
- direct URL/network clients

Default implementations may be provided in initializers only when this does not create hidden global state.

---

## Repository rules

Every persisted data operation must go behind a protocol.

Naming:

- Protocol: `<Entity>RepositoryProtocol`
- Local implementation: `Local<Entity>Repository`
- Remote implementation: `Remote<Entity>Repository`

Examples:

- `BookRepositoryProtocol`
- `LocalBookRepository`
- `RemoteBookRepository`

Local repositories:

- use SwiftData
- handle local persistence
- do not import Supabase
- do not perform network calls

Remote repositories:

- use Supabase
- handle remote persistence/fetching
- do not import SwiftUI
- do not expose Supabase DTOs to ViewModels or Views

Repositories should throw domain-specific errors where useful.

---

## Service rules

Services handle non-entity operations or system/external dependencies.

Examples:

- authentication
- weather
- timers
- notifications
- reachability
- image/OCR
- external APIs

Naming:

- Protocol: `<Name>ServiceProtocol`
- Implementation: `<Name>Service`

Examples:

- `WeatherServiceProtocol`
- `WeatherService`
- `AuthServiceProtocol`
- `AuthService`

Services must be injected into ViewModels through protocols when used by UI workflows.

Services must not be called directly from Views.

---

## SyncCoordinator rules

`SyncCoordinator` is restricted.

It is the only component allowed to coordinate local and remote stores together.

Allowed:

- LocalRepository + RemoteRepository coordination
- pending change queue handling
- conflict resolution
- retry logic
- network-triggered sync

Not allowed outside SyncCoordinator:

- a ViewModel touching both local and remote repositories
- a View touching any repository
- a LocalRepository calling a RemoteRepository
- a RemoteRepository calling a LocalRepository

Do not modify `SyncCoordinator.swift` without explicit user approval.

---

## Shared app-state ownership

Shared app state must have one owner.

Examples:

- `RootView` may own `AuthViewModel`
- `AuthView`, `ProfileView`, and tab children should receive the same auth state
- child views must not create a second `AuthViewModel`

Allowed patterns:

- parent-owned `@StateObject`
- child `@ObservedObject`
- `@EnvironmentObject` for widely shared app state

Before adding `@StateObject`, ask:

Should this object be owned here, or injected from a parent?

Use `@StateObject` only when the view creates and owns the object lifecycle.

Use `@ObservedObject` or `@EnvironmentObject` when the object is owned elsewhere.

---

## Display model rule

Views should receive UI-friendly data.

Use display models when raw domain models are not ideal for UI rendering.

Naming:

- `<Feature><Entity>DisplayModel`

Examples:

- `HomeBookDisplayModel`
- `StatsReadingDisplayModel`
- `ProfileUserDisplayModel`

Use display models when:

- the View only needs a subset of model fields
- stub data is used for an early PR
- formatting is specific to a screen
- the underlying domain model will change soon
- multiple domain models are combined for one UI component

Avoid temporary names like `StubBook` in production files.
Prefer stable UI-facing names such as `HomeBookDisplayModel`.

---

## Feature folder pattern

Preferred structure:

- `SARAK/Features/<Feature>/<Feature>View.swift`
- `SARAK/Features/<Feature>/<Feature>ViewModel.swift`
- `SARAK/Features/<Feature>/Components/<ComponentName>.swift`
- `SARAK/Features/<Feature>/Models/<Feature><Entity>DisplayModel.swift` when needed

Example:

- `SARAK/Features/Home/HomeView.swift`
- `SARAK/Features/Home/HomeViewModel.swift`
- `SARAK/Features/Home/Components/CurrentlyReadingCard.swift`
- `SARAK/Features/Home/Models/HomeBookDisplayModel.swift`

---

## Feature to ViewModel map

| Feature | ViewModel |
|---|---|
| Root shell / auth gate | `AuthViewModel` owned by `RootView` |
| Authentication | `AuthViewModel` |
| Home | `HomeViewModel` |
| Book search and add | `BookSearchViewModel` |
| Library | `LibraryViewModel` |
| Reading sessions | `SessionViewModel` |
| Progress | `ProgressViewModel` |
| Goals | `GoalViewModel` |
| Notes and highlights | `NoteViewModel` |
| Stats and charts | `StatsViewModel` |
| Profile | `ProfileViewModel` if profile gains logic |
| Social and sharing | `SocialViewModel` |

Placeholder tabs do not need ViewModels until they contain state, logic, loading, or user actions.

---

## Xcode 16 synchronized folder groups

This project uses Xcode 16 synchronized folder groups.

Files added to folders under `SARAK/` are auto-discovered and auto-bundled.

Rules:

- Do not manually edit `SARAK.xcodeproj/project.pbxproj`.
- Do not place non-source placeholder files inside `SARAK/`.
- Do not use `README.md`, `.gitkeep`, or `.txt` to preserve folders inside `SARAK/`.
- Empty folders are fine.
- Add real Swift files when a folder is needed.

---

## Architecture checklist

Before finishing a PR, verify:

- [ ] Views contain UI only
- [ ] Views do not import Supabase
- [ ] Views do not call repositories or services directly
- [ ] ViewModels are `@MainActor`
- [ ] ViewModels depend on injected protocols only
- [ ] No duplicate shared app-state ViewModels are created
- [ ] Repositories are behind protocols
- [ ] Local repositories do not import Supabase
- [ ] Remote repositories do not expose DTOs to Views or ViewModels
- [ ] SyncCoordinator is not modified without approval
- [ ] Display models are used when UI data differs from domain data
