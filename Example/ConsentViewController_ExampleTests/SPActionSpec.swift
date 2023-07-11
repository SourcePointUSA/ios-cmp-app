//
//  SPActionSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 07.05.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

// swiftlint:disable function_body_length

@testable import ConsentViewController
import Foundation
import Nimble
import Quick

class SPActionSpec: QuickSpec {
    override func spec() {
        describe("SPAction") {
            it("publisherData is set to empty dictionary by default") {
                expect(SPAction(type: .AcceptAll).publisherData) == [:]
            }

            describe("publisherData") {
                it("sets encodablePublisherData upen being updated") {
                    let action = SPAction(type: .Unknown)
                    action.publisherData = ["foo": "bar"]
                    expect(action.encodablePubData).to(equal(
                        ["foo": AnyEncodable("bar")]
                    ))
                }
            }

            describe("init") {
                it("initialises type, id and payload") {
                    let payload = SPJson()
                    let type = SPActionType.AcceptAll
                    let consentLanguage = "EN"
                    let action = SPAction(type: .AcceptAll, consentLanguage: "EN", pmPayload: payload)

                    expect(action.type) == type
                    expect(action.pmPayload) == payload
                    expect(action.consentLanguage) == consentLanguage
                }

                it("initialises data to data encoded \"{}\" by default") {
                    let action = SPAction(type: .AcceptAll)
                    expect(action.pmPayload) == SPJson()
                }

                it("initialises consentLanguage to nil by default") {
                    let action = SPAction(type: .AcceptAll)
                    expect(action.consentLanguage).to(beNil())
                }
            }
        }

        describe("SPActionType") {
            describe("SaveAndExit") {
                it("has the raw value of 1") {
                    expect(SPActionType.SaveAndExit.rawValue) == 1
                }

                it("has its description as 'SaveAndExit'") {
                    expect(SPActionType.SaveAndExit.description) == "SaveAndExit"
                }
            }

            describe("PMCancel") {
                it("has the raw value of 2") {
                    expect(SPActionType.PMCancel.rawValue) == 2
                }

                it("has its description as 'PMCancel'") {
                    expect(SPActionType.PMCancel.description) == "PMCancel"
                }
            }

            describe("AcceptAll") {
                it("has the raw value of 11") {
                    expect(SPActionType.AcceptAll.rawValue) == 11
                }

                it("has its description as 'AcceptAll'") {
                    expect(SPActionType.AcceptAll.description) == "AcceptAll"
                }
            }

            describe("ShowPrivacyManager") {
                it("has the raw value of 12") {
                    expect(SPActionType.ShowPrivacyManager.rawValue) == 12
                }

                it("has its description as 'ShowPrivacyManager'") {
                    expect(SPActionType.ShowPrivacyManager.description) == "ShowPrivacyManager"
                }
            }

            describe("RejectAll") {
                it("has the raw value of 13") {
                    expect(SPActionType.RejectAll.rawValue) == 13
                }

                it("has its description as 'RejectAll'") {
                    expect(SPActionType.RejectAll.description) == "RejectAll"
                }
            }

            describe("Dismiss") {
                it("has the raw value of 15") {
                    expect(SPActionType.Dismiss.rawValue) == 15
                }

                it("has its description as 'Dismiss'") {
                    expect(SPActionType.Dismiss.description) == "Dismiss"
                }
            }
        }
    }
}
