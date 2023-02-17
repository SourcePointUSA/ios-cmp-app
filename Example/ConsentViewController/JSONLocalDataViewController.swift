//
//  JSONLocalDataViewController.swift
//  ConsentViewController_Example
//
//  Created by Andre Herculano on 15.11.22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import JSONView
import SwiftUI
import UIKit

func toHashable(_ data: Any) -> AnyHashable {
    if let data = data as? Data,
       let jsonData = try? JSONSerialization.jsonObject(with: data, options: []) as? AnyHashable {
        return jsonData
    } else {
        return String(describing: data)
    }
}

class JSONLocalDataViewController: UIViewController {
    @IBOutlet var containerView: UIView!

    override func viewDidLoad() {
        let data: [String: AnyHashable] = UserDefaults.standard.dictionaryRepresentation()
            .filter { $0.key.starts(with: "sp_") || $0.key.starts(with: "IAB") }
            .reduce(into: [String: AnyHashable]()) { acc, element in
                if let newValue = element.value as? AnyHashable {
                    acc[element.key] = toHashable(newValue)
                }
            }
        let childView = UIHostingController(rootView: JSONView(data))
        addChild(childView)
        childView.view.frame = containerView.bounds
        containerView.addSubview(childView.view)
        childView.didMove(toParent: self)
    }
}
