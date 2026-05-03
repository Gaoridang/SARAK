// RootView.swift — SARAK
import SwiftUI

struct RootView: View {
    @StateObject private var authViewModel = AuthViewModel()

    var body: some View {
        Group {
            if authViewModel.isAuthenticated {
                MainTabView(authViewModel: authViewModel)
            } else {
                AuthView(viewModel: authViewModel)
            }
        }
        .onOpenURL { url in
            Task { await authViewModel.handleOpenURL(url) }
        }
    }
}
