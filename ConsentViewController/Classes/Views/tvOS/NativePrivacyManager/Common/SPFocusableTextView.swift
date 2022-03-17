//
//  SPFocusableTextView.swift
//  ConsentViewController-tvOS
//
//  Created by Andre Herculano on 17.03.22.
//

import UIKit

class SPFocusableTextView: UITextView {
    override var canBecomeFocused: Bool { true }

    open override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if isFocused {
            backgroundColor = .lightGray.withAlphaComponent(0.5)
            flashScrollIndicators()
        } else {
            backgroundColor = .clear
        }
    }
}
