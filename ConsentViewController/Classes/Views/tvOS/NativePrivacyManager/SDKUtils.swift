//
//  SDKUtils.swift
//  Pods
//
//  Created by Vilas on 05/05/21.
//

import Foundation

class SDKUtils {

    /// It transforms a Hexadecimal color string to UIColor
    /// - Parameters:
    ///   - hex: `String` in the format of `#ffffff` (Hexeximal color representation)
    ///
    /// Taken from https://stackoverflow.com/a/27203691/1244883)
    static func hexStringToUIColor(hex: String) -> UIColor? {
        let colorString = String(hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased().dropFirst())
        if colorString.count != 6 { return nil }
        var rgbValue: UInt64 = 0
        Scanner(string: colorString).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
