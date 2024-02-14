//
//  Font +.swift
//  JUDA
//
//  Created by 홍세희 on 2024/01/23.
//

import SwiftUI

// MARK: - Font 커스텀 [ pretendard ]
extension Font {
    // Bold
    static let bold22: Font = .custom(FontType.Bold.name, size: 22)
    static let bold20: Font = .custom(FontType.Bold.name, size: 20)
    static let bold18: Font = .custom(FontType.Bold.name, size: 18)
    static let bold16: Font = .custom(FontType.Bold.name, size: 16)
    static let bold14: Font = .custom(FontType.Bold.name, size: 14)
    // SemiBold
    static let semibold28: Font = .custom(FontType.SemiBold.name, size: 28)
    static let semibold26: Font = .custom(FontType.SemiBold.name, size: 26)
    static let semibold24: Font = .custom(FontType.SemiBold.name, size: 24)
    static let semibold20: Font = .custom(FontType.SemiBold.name, size: 20)
    static let semibold18: Font = .custom(FontType.SemiBold.name, size: 18)
    static let semibold16: Font = .custom(FontType.SemiBold.name, size: 16)
    static let semibold14: Font = .custom(FontType.SemiBold.name, size: 14)
    // Medium
    static let medium36: Font = .custom(FontType.Medium.name, size: 36)
	static let medium26: Font = .custom(FontType.Medium.name, size: 26)
    static let medium20: Font = .custom(FontType.Medium.name, size: 20)
    static let medium18: Font = .custom(FontType.Medium.name, size: 18)
    static let medium16: Font = .custom(FontType.Medium.name, size: 16)
    static let medium14: Font = .custom(FontType.Medium.name, size: 14)
    static let medium10: Font = .custom(FontType.Medium.name, size: 10)
    // Regular
    static let regular24: Font = .custom(FontType.Regular.name, size: 24)
    static let regular20: Font = .custom(FontType.Regular.name, size: 20)
    static let regular18: Font = .custom(FontType.Regular.name, size: 18)
    static let regular16: Font = .custom(FontType.Regular.name, size: 16)
    static let regular14: Font = .custom(FontType.Regular.name, size: 14)
    static let regular12: Font = .custom(FontType.Regular.name, size: 12)
    // Light
    static let light20: Font = .custom(FontType.Light.name, size: 20)
    static let light18: Font = .custom(FontType.Light.name, size: 18)
    static let light16: Font = .custom(FontType.Light.name, size: 16)
    static let light14: Font = .custom(FontType.Light.name, size: 14)
    static let light12: Font = .custom(FontType.Light.name, size: 12)
    // Thin
    static let thin20: Font = .custom(FontType.Thin.name, size: 20)
    static let thin18: Font = .custom(FontType.Thin.name, size: 18)
    static let thin16: Font = .custom(FontType.Thin.name, size: 16)
    static let thin14: Font = .custom(FontType.Thin.name, size: 14)
    static let thin12: Font = .custom(FontType.Thin.name, size: 12)
}

enum FontType {
    case Bold
    case SemiBold
    case Medium
    case Regular
    case Light
    case Thin
    
    var name: String {
        switch self {
        case .Bold:
            return "Pretendard-Bold"
        case .SemiBold:
            return "Pretendard-SemiBold"
        case .Medium:
            return "Pretendard-Medium"
        case .Regular:
            return "Pretendard-Regular"
        case .Light:
            return "Pretendard-Light"
        case .Thin:
            return "Pretendard-Thin"
        }
    }
}
