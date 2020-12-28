//
//  PrivacyManagerTabSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Vilas on 28/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import ConsentViewController

class PrivacyManagerTabSpec: QuickSpec {
    override func spec() {

        describe("PrivacyManagerTab") {
            context("DefaultTab") {
                it("has the empty raw value") {
                    expect(PrivacyManagerTab.DefaultTab.rawValue).to(equal(""))
                }
            }

            context("PurposesTab") {
                it("has the raw value 'purposes'") {
                    expect(PrivacyManagerTab.PurposesTab.rawValue).to(equal("purposes"))
                }
            }

            context("VendorsTab") {
                it("has the raw value 'vendors'") {
                    expect(PrivacyManagerTab.VendorsTab.rawValue).to(equal("vendors"))
                }
            }

            context("FeaturesTab") {
                it("has the raw value 'features'") {
                    expect(PrivacyManagerTab.FeaturesTab.rawValue).to(equal("features"))
                }
            }
        }
    }
}
