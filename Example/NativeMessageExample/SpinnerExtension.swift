//
//  SpinnerExtension.swift
//  NativeMessageExample
//
//  Created by Andre Herculano on 22.09.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

fileprivate var aiView: UIView?

extension UIViewController {
    func showSpinner() {
        let ai = UIActivityIndicatorView(style: .gray)
        aiView = UIView(frame: view.bounds)
        aiView?.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        ai.center = aiView!.center
        ai.startAnimating()
        ai.color = .black
        aiView?.addSubview(ai)
        view.addSubview(aiView!)
    }

    func removeSpinner() {
        aiView?.removeFromSuperview()
        aiView = nil
    }
}
