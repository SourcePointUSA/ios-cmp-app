//
//  SPCampaignEnvSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 05.06.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Foundation
import Nimble
import Quick

// swiftlint:disable force_try

class SPCampaignEnvSpec: QuickSpec {
    override func spec() {
        describe("SPCampaignEnv") {
            describe("Stage") {
                it("has the raw value of 0") {
                    expect(SPCampaignEnv.Stage.rawValue) == 0
                }

                it("has its description as 'stage'") {
                    expect(SPCampaignEnv.Stage.description) == "SPCampaignEnv.stage"
                }

                it("can be created with a string") {
                    expect(SPCampaignEnv(stringValue: "stage")) == SPCampaignEnv.Stage
                }
            }

            describe("Public") {
                it("has the raw value of 1") {
                    expect(SPCampaignEnv.Public.rawValue) == 1
                }

                it("has its description as 'prod'") {
                    expect(SPCampaignEnv.Public.description) == "SPCampaignEnv.prod"
                }

                it("can be created with a string") {
                    expect(SPCampaignEnv(stringValue: "prod")) == SPCampaignEnv.Public
                }
            }

            describe("Codable") {
                context("when encoded to JSON") {
                    it("encodes to a string") {
                        let encoded = try! JSONEncoder().encodeResult(SPCampaignEnv.Stage).get()
                        let encodedString = String(data: encoded, encoding: .utf8)
                        if #available(iOS 11, *) {
                            expect(encodedString) == "\"stage\""
                        } else {
                            expect(encodedString) == "[\"stage\"]"
                        }
                    }
                }

                it("can be decoded from JSON") {
                    var decoded: SPCampaignEnv?
                    if #available(iOS 11, *) {
                        // swiftlint:disable:next force_unwrapping
                        decoded = try? JSONDecoder().decode(SPCampaignEnv.self, from: "\"stage\"".data(using: .utf8)!)
                    } else {
                        // swiftlint:disable:next force_unwrapping
                        decoded = try? JSONDecoder().decode(SPCampaignEnv.self, from: "[\"stage\"]".data(using: .utf8)!)
                    }
                    expect(decoded) == .Stage
                }
            }
        }
    }
}
