//
//  SpinnerExtension.swift
//  NativeMessageExample
//
//  Created by Andre Herculano on 22.09.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

private var aiView: UIView?

extension UIViewController {
    func showSpinner() {
        let ai = UIActivityIndicatorView(style: .gray)
        aiView = UIView(frame: view.bounds)
        aiView?.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        ai.center = aiView?.center ?? .zero
        ai.startAnimating()
        ai.color = .black
        aiView?.addSubview(ai)
        if aiView != nil {
            view.addSubview(aiView!) // swiftlint:disable:this force_unwrapping
        }
    }

    func removeSpinner() {
        aiView?.removeFromSuperview()
        aiView = nil
    }
}
