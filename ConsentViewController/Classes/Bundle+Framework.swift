//
//  Bundle+Framework.swift
//  ConsentViewController
//
//  Created by Vilas on 15/10/20.
//

import class Foundation.Bundle

extension Foundation.Bundle {
    /// Returns the resource bundle associated with the current Swift module.
    static var framework: Bundle = {
        #if SWIFT_PACKAGE
        return Bundle.module
        #else
        return Bundle(for: SPConsentManager.self)
        #endif
    }()
}
