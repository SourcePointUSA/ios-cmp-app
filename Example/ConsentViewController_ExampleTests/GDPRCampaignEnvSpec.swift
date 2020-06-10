//
//  GDPRCampaignEnvSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 05.06.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import ConsentViewController

// swiftlint:disable force_try

class GDPRCampaignEnvSpec: QuickSpec {
    override func spec() {
        describe("GDPRCampaignEnv") {
            describe("Stage") {
                it("has the raw value of 0") {
                    expect(GDPRCampaignEnv.Stage.rawValue).to(equal(0))
                }

                it("has its description as 'stage'") {
                    expect(GDPRCampaignEnv.Stage.description).to(equal("stage"))
                }

                it("can be created with a string") {
                    expect(GDPRCampaignEnv(stringValue: "stage")).to(equal(GDPRCampaignEnv.Stage))
                }
            }

            describe("Public") {
                it("has the raw value of 1") {
                    expect(GDPRCampaignEnv.Public.rawValue).to(equal(1))
                }

                it("has its description as 'prod'") {
                    expect(GDPRCampaignEnv.Public.description).to(equal("prod"))
                }

                it("can be created with a string") {
                    expect(GDPRCampaignEnv(stringValue: "prod")).to(equal(GDPRCampaignEnv.Public))
                }
            }

            describe("Codable") {
                it("can be encoded/decoded to/from JSON") {
                    let original = GDPRCampaignEnv.Stage
                    let decoded = try! JSONDecoder().decode(GDPRCampaignEnv.self, from: JSONEncoder().encode(original))
                    expect(decoded).to(equal(original))
                }
            }
        }
    }
}
