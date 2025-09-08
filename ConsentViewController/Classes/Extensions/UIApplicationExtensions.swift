//
//  UIApplicationExtensions.swift
//  Pods
//
//  Created by Andre Herculano on 8/9/25.
//

extension UIApplication {
    var systemFontScale: Float {
        switch preferredContentSizeCategory {
        case .extraSmall: return 0.76
        case .small: return 0.88
        case .medium: return 1.0
        case .large: return 1.0 // yes, .medium and .large have the same scale
        case .extraLarge: return 1.12
        case .extraExtraLarge: return 1.24
        case .extraExtraExtraLarge: return 1.35

        case .accessibilityMedium: return 1.65
        case .accessibilityLarge: return 1.94
        case .accessibilityExtraLarge: return 2.35
        case .accessibilityExtraExtraLarge: return 2.76
        case .accessibilityExtraExtraExtraLarge: return 3.12

        default:
            return 1.0
        }
    }
}
