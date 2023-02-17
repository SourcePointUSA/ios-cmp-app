//
//  PrivacyManagerTabSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Vilas on 28/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Foundation
import Nimble
import Quick

class SPPrivacyManagerTabSpec: QuickSpec {
    override func spec() {
        describe("SPPrivacyManagerTab") {
            context("Default") {
                it("has the empty raw value") {
                    expect(SPPrivacyManagerTab.Default.rawValue) == ""
                }
            }

            context("Purposes") {
                it("has the raw value 'purposes'") {
                    expect(SPPrivacyManagerTab.Purposes.rawValue) == "purposes"
                }
            }

            context("Vendors") {
                it("has the raw value 'vendors'") {
                    expect(SPPrivacyManagerTab.Vendors.rawValue) == "vendors"
                }
            }

            context("Features") {
                it("has the raw value 'features'") {
                    expect(SPPrivacyManagerTab.Features.rawValue) == "features"
                }
            }
        }
    }
}
