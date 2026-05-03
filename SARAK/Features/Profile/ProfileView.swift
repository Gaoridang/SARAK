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
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(
                    PillButtonStyle(
                        backgroundColor: UIConstants.Colors.surfaceCompact,
                        pressedBackgroundColor: UIConstants.Colors.surfaceStrong,
                        foregroundColor: UIConstants.Colors.semanticError,
                        borderColor: UIConstants.Colors.semanticError.opacity(0.22),
                        borderWidth: 1
                    )
                )
                .padding(.horizontal, UIConstants.Spacing.lg)
                Spacer()
            }
            .background(UIConstants.Colors.canvas)
            .navigationTitle(StringConstants.Tab.profile)
        }
    }
}
