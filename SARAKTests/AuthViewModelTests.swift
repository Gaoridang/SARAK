// AuthViewModelTests.swift — SARAK
import Testing
@testable import SARAK

@Suite("AuthViewModel")
@MainActor
struct AuthViewModelTests {

    @Test("isAuthenticated becomes true after successful Kakao sign in")
    func signInSuccess() async {
        let service = MockAuthService()
        let viewModel = AuthViewModel(authService: service)
        await viewModel.signInWithKakao()
        #expect(viewModel.isAuthenticated == true)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.isLoading == false)
    }

    @Test("errorMessage is set and isAuthenticated stays false on sign in failure")
    func signInFailure() async {
        let service = MockAuthService(shouldFail: true)
        let viewModel = AuthViewModel(authService: service)
        await viewModel.signInWithKakao()
        #expect(viewModel.isAuthenticated == false)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.isLoading == false)
    }

    @Test("isAuthenticated becomes false after sign out")
    func signOutSuccess() async {
        let service = MockAuthService(signedIn: true)
        let viewModel = AuthViewModel(authService: service)
        viewModel.isAuthenticated = true
        await viewModel.signOut()
        #expect(viewModel.isAuthenticated == false)
        #expect(viewModel.errorMessage == nil)
        #expect(viewModel.isLoading == false)
    }

    @Test("errorMessage is set and isAuthenticated stays true on sign out failure")
    func signOutFailure() async {
        let service = MockAuthService(signedIn: true, shouldFail: true)
        let viewModel = AuthViewModel(authService: service)
        viewModel.isAuthenticated = true
        await viewModel.signOut()
        #expect(viewModel.isAuthenticated == true)
        #expect(viewModel.errorMessage != nil)
        #expect(viewModel.isLoading == false)
    }
}

// MARK: - Mock

private final class MockAuthService: AuthServiceProtocol, @unchecked Sendable {
    // @unchecked Sendable safe: only mutated serially within test setup, never concurrently
    private var signedIn: Bool
    private let shouldFail: Bool

    init(signedIn: Bool = false, shouldFail: Bool = false) {
        self.signedIn = signedIn
        self.shouldFail = shouldFail
    }

    var isSignedIn: Bool {
        get async { signedIn }
    }

    func signInWithKakao() async throws {
        if shouldFail { throw MockAuthError.intentional }
        signedIn = true
    }

    func signOut() async throws {
        if shouldFail { throw MockAuthError.intentional }
        signedIn = false
    }
}

private enum MockAuthError: Error {
    case intentional
}
