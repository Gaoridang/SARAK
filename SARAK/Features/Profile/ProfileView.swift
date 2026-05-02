// ProfileView.swift — SARAK
import SwiftUI

struct ProfileView: View {
    @ObservedObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: UIConstants.Spacing.lg) {
                Spacer()
                Button {
                    Task { await authViewModel.signOut() }
                } label: {
                    Text(StringConstants.Auth.signOutButton)
                        .foregroundStyle(.red)
                }
                Spacer()
            }
            .navigationTitle(StringConstants.Tab.profile)
        }
    }
}
