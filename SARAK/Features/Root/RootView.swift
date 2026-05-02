// RootView.swift — SARAK
import SwiftUI

struct RootView: View {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        if authViewModel.isAuthenticated {
            MainTabView(authViewModel: authViewModel)
        } else {
            AuthView(viewModel: authViewModel)
        }
    }
}
