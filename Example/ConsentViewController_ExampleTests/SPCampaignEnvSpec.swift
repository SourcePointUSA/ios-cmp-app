//
//  SPCampaignEnvSpec.swift
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

class SPCampaignEnvSpec: QuickSpec {
    override func spec() {
        describe("SPCampaignEnv") {
            describe("Stage") {
                it("has the raw value of 0") {
                    expect(SPCampaignEnv.Stage.rawValue).to(equal(0))
                }

                it("has its description as 'stage'") {
                    expect(SPCampaignEnv.Stage.description).to(equal("stage"))
                }

                it("can be created with a string") {
                    expect(SPCampaignEnv(stringValue: "stage")).to(equal(SPCampaignEnv.Stage))
                }
            }

            describe("Public") {
                it("has the raw value of 1") {
                    expect(SPCampaignEnv.Public.rawValue).to(equal(1))
                }

                it("has its description as 'prod'") {
                    expect(SPCampaignEnv.Public.description).to(equal("prod"))
                }

                it("can be created with a string") {
                    expect(SPCampaignEnv(stringValue: "prod")).to(equal(SPCampaignEnv.Public))
                }
            }

            describe("Codable") {
                context("when encoded to JSON") {
                    it("encodes to a string") {
                        let encoded = try! JSONEncoder().encode(SPCampaignEnv.Stage).get()
                        let encodedString = String(data: encoded, encoding: .utf8)
                        if #available(iOS 11, *) {
                            expect(encodedString).to(equal("\"stage\""))
                        } else {
                            expect(encodedString).to(equal("[\"stage\"]"))
                        }
                    }
                }

                it("can be decoded from JSON") {
                    var decoded: SPCampaignEnv?
                    if #available(iOS 11, *) {
                        decoded = try? JSONDecoder().decode(SPCampaignEnv.self, from: "\"stage\"".data(using: .utf8)!)
                    } else {
                        decoded = try? JSONDecoder().decode(SPCampaignEnv.self, from: "[\"stage\"]".data(using: .utf8)!)
                    }
                    expect(decoded).to(equal(.Stage))
                }
            }
        }
    }
}
