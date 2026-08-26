//
//  DidomiInitializeParametersExt.swift
//  Pods
//
//  Created by Andre Herculano on 26/08/2026.
//

import Didomi
import Foundation

extension DidomiInitializeParameters {
    convenience init(accountId: Int, propertyId: Int, propertyName: String) {
        // TODO: The new implementation of the SDK will require apiKey and noticeID
        self.init(
            apiKey: "eea5ad63-29d4-4552-9dac-2edebe1fe518",
            disableDidomiRemoteConfig: true,
            noticeID: "BVP3EcHb",
            handleConsentUIAutomatically: false
        )
    }
}
