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
    static let client = SupabaseClient(
        supabaseURL: URL(string: APIConstants.Supabase.url)!,
        supabaseKey: APIConstants.Supabase.anonKey
    )
}
```

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
