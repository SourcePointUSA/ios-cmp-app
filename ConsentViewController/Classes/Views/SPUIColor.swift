//
//  SDKUtils.swift
//  Pods
//
//  Created by Vilas on 05/05/21.
//

import Foundation
import UIKit

extension UIColor {
    public convenience init?(hexString: String?) {
        let colorString = String(hexString?.trimmingCharacters(in: .whitespacesAndNewlines).uppercased().dropFirst() ?? "")
        if colorString.count != 6 { return nil }
        var rgbValue: UInt64 = 0
        Scanner(string: colorString).scanHexInt64(&rgbValue)
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
