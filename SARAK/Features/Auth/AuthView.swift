// AuthView.swift — SARAK
import SwiftUI

struct AuthView: View {
    @StateObject private var viewModel = AuthViewModel()

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
                        .fontWeight(.semibold)
                        .foregroundStyle(UIConstants.Colors.kakaoLabel)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, UIConstants.Spacing.md)
                }
                .background(UIConstants.Colors.kakaoYellow)
                .clipShape(RoundedRectangle(cornerRadius: UIConstants.CornerRadius.md))
                .padding(.horizontal, UIConstants.Spacing.xl)
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
    }
}
