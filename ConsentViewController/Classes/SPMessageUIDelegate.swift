//
//  MessageUIDelegate.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 10.02.21.
//

import Foundation

@objc protocol SPMessageUIDelegate {
    func loaded(_ controller: SPMessageViewController)
    func action(_ action: SPAction, from controller: SPMessageViewController)
    func onError(_ error: SPError)
    func finished(_ vcFinished: SPMessageViewController)
}
