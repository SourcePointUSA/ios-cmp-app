//
//  SPFocusableTextView.swift
//  ConsentViewController-tvOS
//
//  Created by Andre Herculano on 17.03.22.
//

import Foundation
import UIKit

@objc(ObjCSPFocusableTextView)
@objcMembers class SPFocusableTextView: UITextView, UITextViewDelegate {
    override var canBecomeFocused: Bool { isContentBig }
    var isContentBig: Bool { self.contentSize.height > self.frame.size.height }
    public var contentFitsContainer: Bool = true

    open override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if isFocused {
            backgroundColor = .lightGray.withAlphaComponent(0.5)
            flashScrollIndicators()
            if isContentBig {
                contentFitsContainer = false
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
        updateContentFitsContainer()
    }

    func scrollViewWillEndDragging(_: UIScrollView, withVelocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        updateContentFitsContainer()
    }

    func updateContentFitsContainer() {
        if contentOffset == .zero || contentOffset.y <= 0 {
            contentFitsContainer = true
        }
    }
}
