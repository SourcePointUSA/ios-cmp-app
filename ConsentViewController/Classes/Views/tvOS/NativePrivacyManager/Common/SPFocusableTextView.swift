//
//  SPFocusableTextView.swift
//  ConsentViewController-tvOS
//
//  Created by Andre Herculano on 17.03.22.
//

import UIKit

class SPFocusableTextView: UITextView, UITextViewDelegate {
    override var canBecomeFocused: Bool { true }
    public var canFocusCategoryTableView: Bool = true

    open override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if isFocused {
            backgroundColor = .lightGray.withAlphaComponent(0.5)
            flashScrollIndicators()
            if (self.contentSize.height > self.frame.size.height) {
                canFocusCategoryTableView = false
            }
        } else {
            backgroundColor = .clear
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.delegate = self
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        checkIfCategoryTableViewFocusable()
    }

    func scrollViewWillEndDragging(_: UIScrollView, withVelocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        checkIfCategoryTableViewFocusable()
    }

    func checkIfCategoryTableViewFocusable()
    {
        if contentOffset == .zero || contentOffset.y <= 0 {
            canFocusCategoryTableView = true
        }
    }
}
