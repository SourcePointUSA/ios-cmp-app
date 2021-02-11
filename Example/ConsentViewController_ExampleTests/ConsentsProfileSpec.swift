//
//  ConsentsProfileSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 11.02.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation

import Quick
import Nimble
@testable import ConsentViewController

class ConsentsProfileSpec: QuickSpec {
    let gdprProfile = ConsentProfile<SPGDPRConsent>
    let jsonString = """
        {
            "gdpr": \()
        }
    """
    func spec() {
        describe("can be encoded to JSON") {

        }

        describe("can be decoded from JSON") {

        }
    }
}
