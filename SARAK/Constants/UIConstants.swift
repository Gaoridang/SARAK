// UIConstants.swift — SARAK
// All UI magic numbers live here. Never hardcode in Views.
import Foundation
import SwiftUI

enum UIConstants {
    enum Spacing {
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
    }
    enum CornerRadius {
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
    }
    enum Colors {
        static let kakaoYellow = Color(red: 0.992, green: 0.898, blue: 0.0)
        static let kakaoLabel = Color(red: 0.137, green: 0.122, blue: 0.118)
    }
}
