// AuthService.swift — SARAK
// Handles all authentication via Supabase Auth.
// See .harness/supabase.md for usage rules.
import Foundation
import Supabase

protocol AuthServiceProtocol: Sendable {
    func signInWithKakao() async throws
    func signOut() async throws
    var isSignedIn: Bool { get async }
}

final class AuthService: AuthServiceProtocol {

    var isSignedIn: Bool {
        get async { (try? await SupabaseService.client.auth.session) != nil }
    }

    func signInWithKakao() async throws {
        try await SupabaseService.client.auth.signInWithOAuth(
            provider: .kakao,
            redirectTo: APIConstants.Auth.redirectURL
        )
    }

    func signOut() async throws {
        try await SupabaseService.client.auth.signOut()
    }
}
