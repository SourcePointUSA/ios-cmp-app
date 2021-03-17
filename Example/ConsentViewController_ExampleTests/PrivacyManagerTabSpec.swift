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
            context("Default") {
                it("has the empty raw value") {
                    expect(SPPrivacyManagerTab.Default.rawValue).to(equal(""))
                }
            }

            context("Purposes") {
                it("has the raw value 'purposes'") {
                    expect(SPPrivacyManagerTab.Purposes.rawValue).to(equal("purposes"))
                }
            }

            context("Vendors") {
                it("has the raw value 'vendors'") {
                    expect(SPPrivacyManagerTab.Vendors.rawValue).to(equal("vendors"))
                }
            }

            context("Features") {
                it("has the raw value 'features'") {
                    expect(SPPrivacyManagerTab.Features.rawValue).to(equal("features"))
                }
            }
        }
    }
}
