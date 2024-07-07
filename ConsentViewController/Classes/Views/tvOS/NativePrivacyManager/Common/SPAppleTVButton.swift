//
//  SPAppleTVButton.swift
//  ConsentViewController-tvOS
//
//  Created by Andre Herculano on 14.03.22.
//

import UIKit

/// A button that enforces clear background colors.
/// To style the background, use ``UIButton.setBackgroundImage(_ image:for:)``.
/// This suppresses unwanted background and border effects automatically added when using
/// the system button type while keeping the default appearance, drop shadow, and scaling effect.
final class SPAppleTVButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        clearBackgroundColors()
    }
}

extension UIView {

    /// Sets the background colors of all the view's subviews to ``UIColor.clear``.
    /// - Parameter ignoredColor: Exception that is not overridden.
    func clearBackgroundColors(ignoring ignoredColor: UIColor? = nil) {
        for subview in subviews {
            subview.clearBackgroundColors(ignoring: ignoredColor)

            if let ignoredColor, subview.backgroundColor == ignoredColor {
                continue
            }

            subview.backgroundColor = .clear
        }
    }
}
