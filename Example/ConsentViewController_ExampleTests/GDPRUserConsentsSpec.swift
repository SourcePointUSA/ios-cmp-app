//
//  SPGDPRUserConsents.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 27.05.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import ConsentViewController

class SPGDPRUserConsentsSpec: QuickSpec {
    override func spec() {
        describe("static empty()") {
            it("contain empty defaults for all its fields") {
                let consents = SPGDPRUserConsent.empty()
                expect(consents.acceptedCategories).to(beEmpty())
                expect(consents.acceptedVendors).to(beEmpty())
                expect(consents.legitimateInterestCategories).to(beEmpty())
                expect(consents.specialFeatures).to(beEmpty())
                expect(consents.euconsent).to(beEmpty())
                expect(consents.tcfData.dictionaryValue).to(beEmpty())
                expect(consents.vendorGrants).to(beEmpty())
            }
        }

        it("is Codable") {
            expect(SPGDPRUserConsent.empty()).to(beAKindOf(Codable.self))
        }

        describe("CodingKeys") {
            it("legIntCategories is mapped to legitimateInterestCategories") {
                expect(SPGDPRUserConsent.CodingKeys.legitimateInterestCategories.rawValue)
                    .to(equal("legIntCategories"))
            }

            it("TCData is mapped to tcfData") {
                expect(SPGDPRUserConsent.CodingKeys.tcfData.rawValue).to(equal("TCData"))
            }
        }
    }
}
