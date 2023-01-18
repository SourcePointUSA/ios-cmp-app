//
//  MessageUIDelegate.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 10.02.21.
//

import Foundation
import UIKit

@objc public protocol SPMessageUIDelegate {
    func loaded(_ controller: UIViewController)
    @objc(loadedWithNativeMessage:) optional func loaded(_ message: SPNativeMessage)
    func action(_ action: SPAction, from controller: UIViewController)
    func onError(_ error: SPError)
    func finished(_ vcFinished: UIViewController)
}
