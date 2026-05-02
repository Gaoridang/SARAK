// AuthViewModel.swift — SARAK
import Foundation
import Combine

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let authService: any AuthServiceProtocol

    init(authService: any AuthServiceProtocol = AuthService()) {
        self.authService = authService
        Task { await refreshSession() }
    }

    func signInWithKakao() async {
        isLoading = true
        errorMessage = nil
        do {
            try await authService.signInWithKakao()
            isAuthenticated = true
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func signOut() async {
        isLoading = true
        errorMessage = nil
        do {
            try await authService.signOut()
            isAuthenticated = false
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    private func refreshSession() async {
        isAuthenticated = await authService.isSignedIn
    }
}
