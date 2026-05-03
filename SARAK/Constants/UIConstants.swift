// UIConstants.swift — SARAK
// All UI magic numbers live here. Never hardcode in Views.
import Foundation
import SwiftUI

enum UIConstants {
    enum Spacing {
        static let space1: CGFloat = 4
        static let space2: CGFloat = 8
        static let space3: CGFloat = 10
        static let space4: CGFloat = 12
        static let space5: CGFloat = 14
        static let space6: CGFloat = 16
        static let space7: CGFloat = 18
        static let space8: CGFloat = 22
        static let space9: CGFloat = 24
        static let space10: CGFloat = 28
        static let space11: CGFloat = 32

        static let xxs = space1
        static let xs = space3
        static let sm = space2
        static let smd = space5
        static let md = space6
        static let smx = space7
        static let lgs = space8
        static let lg = space9
        static let lgx = space10
        static let xl = space11
        static let xxl: CGFloat = 48
        static let section: CGFloat = 64
        static let cardPaddingCompact = space6
        static let cardPaddingTight = space4
        static let cardSpacingCompact: CGFloat = 12
        static let buttonHorizontal: CGFloat = 20
    }
    enum CornerRadius {
        static let sm: CGFloat = 6
        static let md: CGFloat = 8
        static let lg: CGFloat = 14
        static let xl: CGFloat = 16
        static let twoXL: CGFloat = 20
        static let pill: CGFloat = 9999

        static let xs = sm
        static let cardCompact = xl
        static let hero = twoXL
    }
    enum Size {
        static let hitTarget: CGFloat = 44
        static let buttonHeight: CGFloat = 44
        static let compactButtonHeight: CGFloat = 42
        static let iconButton: CGFloat = 32
        static let iconButtonHitTarget = hitTarget
        static let avatar: CGFloat = 40
        static let iconCircle: CGFloat = 32
        static let separatorDot: CGFloat = 3
        static let bookRowCoverWidth: CGFloat = 48
        static let bookRowCoverHeight: CGFloat = 68
        static let statusBadgeMinWidth: CGFloat = 52
        static let setupStepBadge: CGFloat = 28
        static let skeletonLineHeight: CGFloat = 8
        static let scanIcon: CGFloat = 13
        static let progressRing: CGFloat = 48
        static let progressTrack: CGFloat = 4
    }
    enum Colors {
        // Third-party brand — Kakao guidelines mandate these exact values. Do not replace.
        static let kakaoYellow = Color(red: 0.992, green: 0.898, blue: 0.0)
        static let kakaoLabel = Color(red: 0.137, green: 0.122, blue: 0.118)
        // Surface
        static let canvas = Color.white
        static let surface = Color(red: 0.957, green: 0.957, blue: 0.957)
        static let surfaceSoft = Color(white: 0.980)
        static let border = Color(white: 0.933)
        static let divider = Color(white: 0.902)
        static let canvasSoft = surfaceSoft
        static let surfaceCard = Color.white
        static let surfaceCompact = surface
        static let surfaceStrong = border
        // Primary action
        static let primary = Color(white: 0.122)
        static let primaryActive = Color(white: 0.059)
        // Text
        static let ink = Color(white: 0.122)
        static let body = Color(white: 0.420)
        static let bodyStrong = Color(white: 0.290)
        static let muted = Color(white: 0.604)
        static let mutedSoft = Color(white: 0.784)
        static let onPrimary = Color.white
        // On-dark surfaces (hero card)
        static let onDark = Color.white
        static let onDarkMuted = Color(white: 0.710)
        static let onDarkSoft = Color(white: 0.604)
        static let darkTrack = Color(white: 0.227)
        static let darkBorder = Color(white: 0.290)
        static let darkDashedBorder = Color(white: 0.353)
        // Hairlines
        static let hairline = divider
        static let hairlineSoft = border
        static let hairlineStrong = Color(white: 0.816)
        // Session accent — active reading state only, never decorative
        static let accent = Color(red: 1.0, green: 0.902, blue: 0.659)
        // Book cover placeholder tones
        static let coverWarm = Color(red: 0.910, green: 0.867, blue: 0.816)
        static let coverCool = Color(red: 0.847, green: 0.871, blue: 0.910)
        static let coverSage = Color(red: 0.886, green: 0.886, blue: 0.855)
        static let coverInk = Color(white: 0.122)
        // Semantic
        static let semanticSuccess = Color(red: 0.086, green: 0.639, blue: 0.290)
        static let semanticError = Color(red: 0.863, green: 0.149, blue: 0.149)
    }
    enum Typography {
        static let trackingWide: CGFloat = 1.4
        static let trackingWider: CGFloat = 1.5

        // Inter tokens mapped to native SF/system fonts.
        static let displayMD: Font = .system(size: 26, weight: .bold)
        static let displaySM: Font = .system(size: 22, weight: .semibold)
        static let titleMD: Font = .system(size: 22, weight: .semibold)
        static let titleSM: Font = .system(size: 16, weight: .semibold)
        static let bodyMD: Font = .system(size: 14, weight: .regular)
        static let bodyStrong: Font = .system(size: 14, weight: .semibold)
        static let bodySM: Font = .system(size: 13, weight: .regular)
        static let caption: Font = .system(size: 12, weight: .regular)
        static let captionUppercase: Font = .system(size: 10, weight: .semibold)
        static let button: Font = .system(size: 14, weight: .semibold)
        static let navLink: Font = .system(size: 15, weight: .medium)
    }

    enum Shadow {
        static let smColor = Color.black.opacity(0.06)
        static let smRadius: CGFloat = 3
        static let smX: CGFloat = 0
        static let smY: CGFloat = 1

        static let mdColor = Color.black.opacity(0.12)
        static let mdRadius: CGFloat = 16
        static let mdX: CGFloat = 0
        static let mdY: CGFloat = 6

        static let lgColor = Color.black.opacity(0.18)
        static let lgRadius: CGFloat = 36
        static let lgX: CGFloat = 0
        static let lgY: CGFloat = 18

        static let promptColor = Color.black.opacity(0.25)
        static let promptRadius: CGFloat = 40
        static let promptX: CGFloat = 0
        static let promptY: CGFloat = 18
    }

    enum Motion {
        static let fast: Double = 0.12
        static let base: Double = 0.20
        static let slow: Double = 0.32
    }
}
