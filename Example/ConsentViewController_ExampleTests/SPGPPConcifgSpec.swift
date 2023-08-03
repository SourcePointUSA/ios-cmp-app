//
//  SPGPPConcifgSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 03.08.23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Foundation
import Nimble
import Quick

class SPGPPConfigSpec: QuickSpec {
    override func spec() {
        describe("when all flags are nil") {
            it("json is an empty object") {
                expect(SPGPPConfig()).to(encodeToValue("{}"))
            }
        }

        describe("when some or all flags are set") {
            it("json contains only the set flags") {
                expect(SPGPPConfig(MspaCoveredTransaction: .no)).to(encodeToValue(
                    #"{"MspaCoveredTransaction":"no"}"#
                ))
            }
        }

        describe("SPMspaBinaryFlag") {
            it("encodes to a single value") {
                expect(SPGPPConfig.SPMspaBinaryFlag.no).to(encodeToValue(#""no""#))
            }
        }
    }
}
