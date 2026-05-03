// AuthView.swift — SARAK
import SwiftUI

struct AuthView: View {
    @ObservedObject var viewModel: AuthViewModel

    var body: some View {
        VStack(spacing: UIConstants.Spacing.lg) {
            Spacer()

            Text(StringConstants.Auth.appTitle)
                .font(.largeTitle)
                .fontWeight(.bold)

            Spacer()

            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.2)
            } else {
                Button {
                    Task { await viewModel.signInWithKakao() }
                } label: {
                    Text(StringConstants.Auth.kakaoLoginButton)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(
                    PillButtonStyle(
                        backgroundColor: UIConstants.Colors.kakaoYellow,
                        pressedBackgroundColor: UIConstants.Colors.kakaoYellow.opacity(0.82),
                        foregroundColor: UIConstants.Colors.kakaoLabel
                    )
                )
                .padding(.horizontal, UIConstants.Spacing.lg)
            }

            if let message = viewModel.errorMessage {
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, UIConstants.Spacing.lg)
            }

            Spacer()
        }
        .background(UIConstants.Colors.canvas)
    }
}
