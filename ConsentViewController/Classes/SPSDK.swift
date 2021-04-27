//
//  SPSDK.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 10.02.21.
//

import Foundation

@objc public protocol SPCCPA {
    @objc func loadCCPAPrivacyManager(withId: String, tab: SPPrivacyManagerTab)
    @objc func ccpaApplies() -> Bool
}

@objc public protocol SPGDPR {
    @objc func loadGDPRPrivacyManager(withId: String, tab: SPPrivacyManagerTab)
    @objc func gdprApplies() -> Bool
}

@objc public protocol SPSDK: SPGDPR, SPCCPA {
    @objc var userData: SPUserData { get }
    @objc func loadMessage(forAuthId authId: String?)
//    @objc func loadNativeMessage(forAuthId authId: String?)
}
