//
//  LoadConsent.swift
//  AuthExample
//
//  Created by Andre Herculano on 21.06.19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import ConsentViewController

class ConsentManager: NSObject {
    private let cvc: ConsentViewController
    private let viewControllerDeletage: UIViewController

    init(viewController: UIViewController, myPrivacyManager: Bool) {
        viewControllerDeletage = viewController
        cvc = try! ConsentViewController(accountId: 22, siteName: "mobile.demo", stagingCampaign: false)
        cvc.setTargetingParam(key: "MyPrivacyManager", value: String(myPrivacyManager))
        cvc.onMessageReady = { controller in
            viewController.present(controller, animated: false, completion: nil)
            print("Message ready")
        }
        cvc.onInteractionComplete = { controller in
            viewController.dismiss(animated: false, completion: nil)
            print("Interaction complete")
        }
    }

    func onConsentsReady(_ callback: @escaping Callback) -> ConsentManager {
        cvc.onInteractionComplete = { viewController in
                self.viewControllerDeletage.dismiss(animated: false, completion: nil)
                callback(viewController)
        }
        return self
    }

    func loadConsents() {
        cvc.loadMessage()
    }

    func loadConsents(forAuthId authId: String) {
        cvc.loadMessage(forAuthId: authId)
    }
}


