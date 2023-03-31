//
//  SPAppleTVButton.swift
//  ConsentViewController-tvOS
//
//  Created by Andre Herculano on 14.03.22.
//

import UIKit

extension UIView {
    var allSubviews: [UIView] {
        subviews.reduce(into: [self]) { array, subview in
            array += subview.allSubviews
        }
    }
}

@objcMembers class SPAppleTVButton: UIButton {
    var viewBeforeUITitleView: UIView? { allSubviews.dropFirst(allSubviews.count - 2).first }

    var onFocusBackgroundColor: UIColor?
    var onUnfocusBackgroundColor: UIColor? {
        didSet {
            viewBeforeUITitleView?.backgroundColor = onUnfocusBackgroundColor
        }
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        if isFocused {
            backgroundColor = onFocusBackgroundColor
            coordinator.addCoordinatedAnimations({ [weak self] in
                self?.viewBeforeUITitleView?.backgroundColor = self?.onFocusBackgroundColor
            })
        } else {
            backgroundColor = onUnfocusBackgroundColor
            viewBeforeUITitleView?.backgroundColor = onUnfocusBackgroundColor
        }
    }
}
