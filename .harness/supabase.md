# Supabase usage rules
# Load this when: touching auth, remote repositories, DTOs, Supabase client, or any remote data layer

## Purpose

Supabase is a remote data dependency.

Keep Supabase isolated from UI, ViewModels, local persistence, and domain logic.

---

## Where Supabase can be imported

Supabase may only be imported in:

- `Remote*Repository`
- `AuthService.swift`
- `SupabaseService.swift`
- `SyncCoordinator.swift`

Supabase must not be imported in:

- Views
- ViewModels
- SwiftData models
- Local repositories
- display models
- UI components
- tests, unless specifically testing remote repository behavior with approved test setup

---

## Supabase boundary

Views must never know Supabase exists.

ViewModels must never know Supabase exists.

Allowed flow:

View
→ ViewModel
→ RepositoryProtocol or ServiceProtocol
→ RemoteRepository or AuthService
→ SupabaseService.client

Disallowed:

View
→ Supabase

ViewModel
→ Supabase

ViewModel
→ SupabaseService.client

ViewModel
→ RemoteBookRepository concrete type

---

## Client initialization

Use a single shared Supabase client.

The client must be initialized only in `SupabaseService.swift`.

Example:

enum SupabaseService {
    static let client: SupabaseClient = {
        guard let url = URL(string: APIConstants.Supabase.url) else {
            preconditionFailure("Invalid Supabase URL — check APIConstants.Supabase.url")
        }

        return SupabaseClient(
            supabaseURL: url,
            supabaseKey: APIConstants.Supabase.anonKey
        )
    }()
}

Rules:

- Do not create Supabase clients inside Views.
- Do not create Supabase clients inside ViewModels.
- Do not create Supabase clients inside individual repositories.
- Do not use `URL(string:)!`.
- Do not force unwrap.
- Use `guard let` and `preconditionFailure` for invalid static configuration.

---

## Secrets and keys

Do not hardcode secrets.

Rules:

- Never commit service role keys.
- Never use service role keys in the iOS app.
- Only the anon key may be used in the client app.
- Keep keys in the approved configuration location.
- Do not move secrets into source files as a workaround.
- Do not print keys or auth tokens.

If a key/config change is required, check `off-limits.md` first.

---

## Table name rules

Never inline table names.

Use:

- `APIConstants.Supabase.*`

Example:

APIConstants.Supabase.booksTable

Do not write:

"books"

inside repository queries.

Table names, bucket names, RPC names, and repeated remote constants should be centralized.

---

## Remote repository rules

Remote repositories handle Supabase persistence and fetching.

Naming:

- `Remote<Entity>Repository`

Examples:

- `RemoteBookRepository`
- `RemoteReadingSessionRepository`
- `RemoteUserProfileRepository`

Remote repositories may:

- import Supabase
- use `SupabaseService.client`
- perform remote fetch/save/delete calls
- map DTOs to domain models
- throw domain errors

Remote repositories must not:

- import SwiftUI
- update UI state
- expose Supabase response types to ViewModels
- expose DTOs to Views
- access SwiftData `ModelContext`
- coordinate local and remote stores directly unless inside `SyncCoordinator`

---

## Repository protocol rule

ViewModels depend on repository protocols, not remote repositories.

Good:

final class BookSearchViewModel {
    private let bookRepository: BookRepositoryProtocol

    init(bookRepository: BookRepositoryProtocol) {
        self.bookRepository = bookRepository
    }
}

Bad:

final class BookSearchViewModel {
    private let bookRepository = RemoteBookRepository()
}

Bad:

final class BookSearchViewModel {
    private let client = SupabaseService.client
}

---

## DTO rules

Remote data transfer objects must be isolated to the remote layer.

Naming:

- `<Entity>RemoteDTO`

Examples:

- `BookRemoteDTO`
- `ReadingSessionRemoteDTO`
- `UserProfileRemoteDTO`

Rules:

- DTOs represent Supabase rows or remote payloads.
- DTOs should usually be `Codable`.
- DTOs may include remote-specific field names.
- DTOs should map into domain models before leaving the remote repository.
- Views and ViewModels must not depend on DTOs.
- Local repositories should not use remote DTOs.

Preferred flow:

Supabase row
→ RemoteDTO
→ domain model or sync payload
→ repository protocol result

---

## DTO mapping

Mapping should be explicit.

Good:

extension BookRemoteDTO {
    func toDomain() throws -> Book {
        Book(
            id: id,
            title: title,
            author: author,
            updatedAt: updatedAt
        )
    }
}

Good:

extension Book {
    func toRemoteDTO(userID: UUID) -> BookRemoteDTO {
        BookRemoteDTO(
            id: id,
            userID: userID,
            title: title,
            author: author,
            updatedAt: updatedAt
        )
    }
}

Avoid:

- leaking DTOs into UI
- using dictionaries for typed rows
- duplicating mapping logic across multiple files
- silently ignoring failed mappings

---

## Calling pattern

All Supabase calls must be `async throws`.

Example:

func fetchBooks() async throws -> [Book] {
    let response: [BookRemoteDTO] = try await SupabaseService.client
        .from(APIConstants.Supabase.booksTable)
        .select()
        .execute()
        .value

    return try response.map { try $0.toDomain() }
}

Rules:

- No semaphores.
- No blocking `.sync`.
- No callback wrapping unless unavoidable.
- No UI blocking while waiting for Supabase.
- Convert Supabase errors into domain errors when useful.

---

## Auth

Supabase Auth is handled exclusively by `AuthService`.

Allowed:

AuthView
→ AuthViewModel
→ AuthServiceProtocol
→ AuthService
→ Supabase

Not allowed:

AuthView
→ Supabase

AuthViewModel
→ Supabase

AuthViewModel
→ SupabaseService.client

Rules:

- Use PKCE flow for iOS.
- `AuthViewModel` calls `AuthServiceProtocol`.
- `AuthService` performs Supabase Auth operations.
- Auth state should have one owner in the app shell.
- Do not create duplicate `AuthViewModel` instances across auth/profile/root views.
- Do not expose raw tokens to Views.

---

## RLS and user scoping

RLS is enabled on all tables.

Rules:

- Never disable RLS from app code.
- Never use service role keys in the client app.
- Never bypass user scoping from app code.
- Remote queries should rely on RLS.
- Where appropriate, remote writes should include the authenticated user id.
- Do not fetch or modify data belonging to another user.

If a query appears to require bypassing RLS, stop and ask.

---

## Schema and policy changes

Do not change Supabase schema from app code.

Do not change:

- tables
- columns
- indexes
- policies
- functions
- triggers
- storage buckets
- RLS settings

Schema, policy, or migration changes require a separate approved plan.

If a feature needs schema changes, write the requirement in the plan and stop before implementing schema changes.

---

## Storage rules

If Supabase Storage is used:

- bucket names must come from constants
- upload/download code belongs in an approved service or remote repository
- Views must not upload files directly
- ViewModels must call an injected protocol
- RLS/storage policies must not be bypassed
- large file operations must not block the UI

---

## Offline behavior

Remote failures must not break local-first behavior.

Rules:

- Supabase failures should throw.
- ViewModels should convert errors into safe UI state.
- Local writes should happen first where sync rules apply.
- Failed remote writes should be queued by sync logic where appropriate.
- Do not block the UI waiting for remote confirmation.

Follow `sync.md` for offline-first behavior.

---

## Error handling

Do not expose raw Supabase errors directly to users.

Remote repositories should convert errors where useful.

Examples:

- `AuthError.signInFailed`
- `BookError.remoteFetchFailed`
- `SyncError.uploadFailed`
- `NetworkError.offline`

ViewModels should expose user-safe `errorMessage`.

---

## Testing

ViewModel tests should use protocol mocks, not real Supabase.

Remote repository tests may use one of:

- mocked Supabase client wrapper
- approved test project/backend
- integration test setup approved in the plan

Do not run tests against production Supabase.

Do not use real user credentials in tests.

Do not commit test secrets.

---

## Checklist

Before finishing a PR that touches Supabase, verify:

- [ ] Supabase is imported only in approved files
- [ ] ViewModels depend on protocols, not Supabase or concrete remote repositories
- [ ] Table names use `APIConstants.Supabase.*`
- [ ] No force unwraps are used in client initialization
- [ ] DTOs do not leak into Views or ViewModels
- [ ] Remote errors are handled or converted
- [ ] RLS is not disabled or bypassed
- [ ] No service role key is used in the app
- [ ] No schema or policy change was made without approval
- [ ] Tests do not use production Supabase or real credentials
