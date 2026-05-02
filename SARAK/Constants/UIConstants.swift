// UIConstants.swift — SARAK
// All UI magic numbers live here. Never hardcode in Views.
import Foundation
import SwiftUI

enum UIConstants {
    enum Spacing {
        static let xxs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
        static let section: CGFloat = 64
    }
    enum CornerRadius {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 24
    }
    enum Colors {
        // Third-party brand — Kakao guidelines mandate these exact values. Do not replace.
        static let kakaoYellow = Color(red: 0.992, green: 0.898, blue: 0.0)
        static let kakaoLabel = Color(red: 0.137, green: 0.122, blue: 0.118)
        // Surface
        static let canvas = Color(red: 0.961, green: 0.961, blue: 0.961)
        static let canvasSoft = Color(red: 0.980, green: 0.980, blue: 0.980)
        static let surfaceCard = Color.white
        static let surfaceStrong = Color(red: 0.941, green: 0.937, blue: 0.929)
        // Primary action
        static let primary = Color(red: 0.161, green: 0.145, blue: 0.137)
        static let primaryActive = Color(red: 0.047, green: 0.039, blue: 0.035)
        // Text
        static let ink = Color(red: 0.047, green: 0.039, blue: 0.035)
        static let body = Color(red: 0.306, green: 0.306, blue: 0.306)
        static let bodyStrong = Color(red: 0.161, green: 0.145, blue: 0.137)
        static let muted = Color(red: 0.467, green: 0.443, blue: 0.412)
        static let mutedSoft = Color(red: 0.659, green: 0.635, blue: 0.620)
        static let onPrimary = Color.white
        // Hairlines
        static let hairline = Color(red: 0.906, green: 0.898, blue: 0.894)
        static let hairlineSoft = Color(red: 0.941, green: 0.937, blue: 0.929)
        static let hairlineStrong = Color(red: 0.839, green: 0.827, blue: 0.820)
        // Atmospheric gradient orbs — decoration only, never as button fills or text colors
        static let gradientMint = Color(red: 0.655, green: 0.898, blue: 0.827)
        static let gradientPeach = Color(red: 0.957, green: 0.773, blue: 0.659)
        static let gradientLavender = Color(red: 0.784, green: 0.722, blue: 0.878)
        static let gradientSky = Color(red: 0.659, green: 0.784, blue: 0.910)
        static let gradientRose = Color(red: 0.910, green: 0.722, blue: 0.769)
        // Semantic
        static let semanticSuccess = Color(red: 0.086, green: 0.639, blue: 0.290)
        static let semanticError = Color(red: 0.863, green: 0.149, blue: 0.149)
    }
    enum Typography {
        // Display — New York serif, weight .light (editorial signature; never .bold)
        static let displayMega: Font = .system(size: 64, weight: .light, design: .serif)
        static let displayXL: Font = .system(size: 48, weight: .light, design: .serif)
        static let displayLG: Font = .system(size: 36, weight: .light, design: .serif)
        static let displayMD: Font = .system(size: 32, weight: .light, design: .serif)
        static let displaySM: Font = .system(size: 24, weight: .light, design: .serif)
        // Title — SF Pro, weight .medium
        static let titleMD: Font = .system(size: 20, weight: .medium)
        static let titleSM: Font = .system(size: 18, weight: .medium)
        // Body — SF Pro
        static let bodyMD: Font = .system(size: 16, weight: .regular)
        static let bodyStrong: Font = .system(size: 16, weight: .medium)
        static let bodySM: Font = .system(size: 15, weight: .regular)
        // Micro
        static let caption: Font = .system(size: 14, weight: .regular)
        static let captionUppercase: Font = .system(size: 12, weight: .semibold)
        static let button: Font = .system(size: 15, weight: .medium)
        static let navLink: Font = .system(size: 15, weight: .medium)
    }
}
