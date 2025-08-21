//
//  Bundle+Framework.swift
//  ConsentViewController
//
//  Created by Vilas on 15/10/20.
//

import Foundation

extension Foundation.Bundle {
    /// Returns the resource bundle associated with the current Swift module.
    static var framework: Bundle = {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        if let url = main.url(forResource: "ConsentViewController", withExtension: "bundle"),
            let bundle = Bundle(url: url) {
            return bundle
        } else {
            return Bundle(for: SPConsentManager.self)
        }
        #endif
    }()
}
