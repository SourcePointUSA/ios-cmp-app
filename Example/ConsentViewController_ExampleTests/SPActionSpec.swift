//
//  SPActionSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 07.05.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

// swiftlint:disable function_body_length

import Foundation
import Quick
import Nimble
@testable import ConsentViewController

class SPActionSpec: QuickSpec {
    override func spec() {

        describe("SPAction") {
            it("publisherData is set to empty dictionary by default") {
                expect(SPAction(type: .AcceptAll).publisherData).to(equal([:]))
            }

            describe("init") {
                it("initialises type, id and payload") {
                    let payload = SPJson()
                    let type = SPActionType.AcceptAll
                    let consentLanguage = "EN"
                    let action = SPAction(type: .AcceptAll, consentLanguage: "EN", pmPayload: payload)

                    expect(action.type).to(equal(type))
                    expect(action.pmPayload).to(equal(payload))
                    expect(action.consentLanguage).to(equal(consentLanguage))
                }

                it("initialises data to data encoded \"{}\" by default") {
                    let action = SPAction(type: .AcceptAll)
                    expect(action.pmPayload).to(equal(SPJson()))
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
                    expect(SPActionType.SaveAndExit.rawValue).to(equal(1))
                }

                it("has its description as 'SaveAndExit'") {
                    expect(SPActionType.SaveAndExit.description).to(equal("SaveAndExit"))
                }
            }

            describe("PMCancel") {
                it("has the raw value of 2") {
                    expect(SPActionType.PMCancel.rawValue).to(equal(2))
                }

                it("has its description as 'PMCancel'") {
                    expect(SPActionType.PMCancel.description).to(equal("PMCancel"))
                }
            }

            describe("AcceptAll") {
                it("has the raw value of 11") {
                    expect(SPActionType.AcceptAll.rawValue).to(equal(11))
                }

                it("has its description as 'AcceptAll'") {
                    expect(SPActionType.AcceptAll.description).to(equal("AcceptAll"))
                }
            }

            describe("ShowPrivacyManager") {
                it("has the raw value of 12") {
                    expect(SPActionType.ShowPrivacyManager.rawValue).to(equal(12))
                }

                it("has its description as 'ShowPrivacyManager'") {
                    expect(SPActionType.ShowPrivacyManager.description).to(equal("ShowPrivacyManager"))
                }
            }

            describe("RejectAll") {
                it("has the raw value of 13") {
                    expect(SPActionType.RejectAll.rawValue).to(equal(13))
                }

                it("has its description as 'RejectAll'") {
                    expect(SPActionType.RejectAll.description).to(equal("RejectAll"))
                }
            }

            describe("Dismiss") {
                it("has the raw value of 15") {
                    expect(SPActionType.Dismiss.rawValue).to(equal(15))
                }

                it("has its description as 'Dismiss'") {
                    expect(SPActionType.Dismiss.description).to(equal("Dismiss"))
                }
            }
        }
    }
}
