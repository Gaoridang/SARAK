// StringConstants.swift — SARAK
// Localized string keys for all user-facing text.
// Never hardcode display strings in Views or ViewModels.
import Foundation

enum StringConstants {
    enum Auth {
        static let appTitle = String(localized: "auth.app_title")
        static let kakaoLoginButton = String(localized: "auth.kakao_login_button")
        static let signOutButton = String(localized: "auth.sign_out_button")
    }
}
