//
//  SPSDK.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 10.02.21.
//

import Foundation

@objc public protocol SPCCPA {
    @objc func loadCCPAPrivacyManager()
    @objc func ccpaApplies() -> Bool
}

@objc public  protocol SPGDPR {
    @objc func loadGDPRPrivacyManager()
    @objc func gdprApplies() -> Bool
}

@objc public protocol SPSDK: SPGDPR, SPCCPA {
    @objc func loadMessage(forAuthId authId: String?)
//    @objc func loadNativeMessage(forAuthId authId: String?)
}