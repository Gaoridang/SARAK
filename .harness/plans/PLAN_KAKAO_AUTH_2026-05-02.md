# Execution plan — Supabase Kakao Login
# Created: 2026-05-02
# Branch: feat/kakao-auth

---

## 1. Task summary
Implement Kakao OAuth login via Supabase Auth. Uses Supabase's built-in OAuth flow (PKCE) — no native Kakao SDK needed. Supabase opens an ASWebAuthenticationSession to Kakao's login page, then redirects back to the app via a deep link URL scheme. AuthService handles the Supabase calls; AuthViewModel wraps it for the View; AuthView presents the login button.

## 2. Harness docs loaded
- [x] architecture.md
- [x] conventions.md
- [x] constraints.md
- [ ] sync.md (not touching SyncCoordinator)
- [x] testing.md
- [x] supabase.md
- [x] off-limits.md

## 3. Files to create
| File path | Purpose |
|-----------|---------|
| `SARAK/Features/Auth/AuthViewModel.swift` | `@MainActor` VM — wraps AuthService, exposes session state |
| `SARAK/Features/Auth/AuthView.swift` | SwiftUI login screen with Kakao button |
| `SARAKTests/AuthViewModelTests.swift` | Unit tests for AuthViewModel via mock AuthService |

## 4. Files to modify
| File path | Change |
|-----------|--------|
| `SARAK/Services/AuthService.swift` | Implement `signInWithKakao()`, `signOut()`, session publisher |
| `SARAK/SARAKApp.swift` | Register `.onOpenURL` handler for OAuth deep link callback |
| `SARAK/Constants/APIConstants.swift` | Add `redirectURL` constant for OAuth callback scheme |

## 5. Architecture check
- [x] AuthView has zero business logic — only binds to AuthViewModel
- [x] AuthViewModel is `@MainActor`
- [x] AuthViewModel calls AuthService only — never touches Supabase directly
- [x] `import Supabase` only in AuthService — allowed per supabase.md
- [x] SyncCoordinator NOT touched

## 6. OAuth flow (PKCE — no native Kakao SDK)
```
AuthView taps "Kakao Login"
  → AuthViewModel.signInWithKakao()
    → AuthService.signInWithKakao()
      → SupabaseService.client.auth.signInWithOAuth(
            provider: .kakao,
            redirectTo: APIConstants.Auth.redirectURL
         )
      → opens ASWebAuthenticationSession → Kakao login page
      → Kakao redirects to: sarak://login-callback?code=...
  → SARAKApp.onOpenURL captures the URL
    → AuthService.handleDeepLink(url)
      → SupabaseService.client.auth.session(from: url)
  → AuthService publishes updated Session → AuthViewModel updates UI
```

## 7. Step-by-step execution order
1. Add `APIConstants.Auth.redirectURL` constant
2. Implement `AuthService` — `signInWithKakao()`, `signOut()`, `sessionPublisher`
3. Create `AuthViewModel` — `@MainActor`, consumes AuthService
4. Create `AuthView` — Kakao login button, bound to AuthViewModel
5. Wire `onOpenURL` in `SARAKApp`
6. Write `AuthViewModelTests` with `MockAuthService`
7. Build + SwiftLint + tests

## 8. Risks and unknowns — BLOCKING

### ❓ Unknown 1 — Kakao OAuth redirect URL scheme
What URL scheme should the app register for the OAuth callback?
- Common pattern: `sarak://login-callback`
- Must match exactly what is registered in Supabase Dashboard → Auth → Providers → Kakao → Redirect URLs
- **Need user to confirm the redirect URL before I add it to APIConstants and Info.plist.**

### ❓ Unknown 2 — Supabase Kakao provider configured?
Has Kakao been enabled as an OAuth provider in the Supabase Dashboard (with the Kakao app key and secret)?
- If not, the OAuth flow will fail at runtime even if the code is correct.
- **Need user to confirm this is set up in the dashboard.**

### ❓ Unknown 3 — Info.plist URL scheme entry
Adding a custom URL scheme requires adding a `CFBundleURLSchemes` entry to Info.plist (or the Xcode project's URL Types setting).
- This is a project-level change. Fine to do — not in off-limits — but needs the redirect scheme confirmed first.

## 9. Definition of done
- [ ] Build passes with zero warnings
- [ ] SwiftLint passes with zero errors
- [ ] AuthViewModel: `signInWithKakao()` and `signOut()` covered by tests
- [ ] Agent log updated before commit
- [ ] Deep link handler wired in SARAKApp
