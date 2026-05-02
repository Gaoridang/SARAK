# Supabase usage rules
# Load this when: touching any remote data layer

## Where Supabase can be imported
- `Remote*Repository` files only
- `AuthService.swift`
- `SyncCoordinator.swift`
- `SupabaseService.swift` (client init)
- Nowhere else

## Client initialization (single instance)
```swift
// SupabaseService.swift
import Supabase

enum SupabaseService {
    static let client: SupabaseClient = {
        guard let url = URL(string: APIConstants.Supabase.url) else {
            preconditionFailure("Invalid Supabase URL — check APIConstants.Supabase.url")
        }
        return SupabaseClient(supabaseURL: url, supabaseKey: APIConstants.Supabase.anonKey)
    }()
}
```
⚠️ Do NOT use `URL(string:)!` — `force_unwrapping` is a SwiftLint error. Use `guard let` + `preconditionFailure`.

## Table name rules
- Always use `APIConstants.Supabase.*` — never inline strings
- RLS is enabled on all tables — never disable it

## Calling pattern
```swift
func fetchBooks() async throws -> [Book] {
    try await SupabaseService.client
        .from(APIConstants.Supabase.booksTable)
        .select()
        .execute()
        .value
}
```

## Auth (Supabase Auth)
- Handled exclusively in `AuthService`
- `AuthViewModel` calls `AuthService` only — never calls Supabase directly
- Use PKCE flow for iOS
