//
//  GDPRActionSpec.swift
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

class GDPRActionSpec: QuickSpec {
    override func spec() {
        describe("GDPRAction") {
            describe("init") {
                it("initialises type, id and payload") {
                    let payload = "".data(using: .utf8)!
                    let type = GDPRActionType.AcceptAll
                    let id = "something"
                    let action = GDPRAction(type: .AcceptAll, id: "something", payload: payload)

                    expect(action.type).to(equal(type))
                    expect(action.id).to(equal(id))
                    expect(action.payload).to(equal(payload))
                }

                it("initialises id to nil by default") {
                    let action = GDPRAction(type: .AcceptAll)
                    expect(action.id).to(beNil())
                }

                it("initialises data to data encoded \"{}\" by default") {
                    let action = GDPRAction(type: .AcceptAll)
                    expect(action.payload).to(equal("{}".data(using: .utf8)))
                }
            }
        }

        describe("GDPRActionType") {
            describe("SaveAndExit") {
                it("has the raw value of 1") {
                    expect(GDPRActionType.SaveAndExit.rawValue).to(equal(1))
                }

                it("has its description as 'SaveAndExit'") {
                    expect(GDPRActionType.SaveAndExit.description).to(equal("SaveAndExit"))
                }
            }

            describe("PMCancel") {
                it("has the raw value of 2") {
                    expect(GDPRActionType.PMCancel.rawValue).to(equal(2))
                }

                it("has its description as 'PMCancel'") {
                    expect(GDPRActionType.PMCancel.description).to(equal("PMCancel"))
                }
            }

            describe("AcceptAll") {
                it("has the raw value of 11") {
                    expect(GDPRActionType.AcceptAll.rawValue).to(equal(11))
                }

                it("has its description as 'AcceptAll'") {
                    expect(GDPRActionType.AcceptAll.description).to(equal("AcceptAll"))
                }
            }

            describe("ShowPrivacyManager") {
                it("has the raw value of 12") {
                    expect(GDPRActionType.ShowPrivacyManager.rawValue).to(equal(12))
                }

                it("has its description as 'ShowPrivacyManager'") {
                    expect(GDPRActionType.ShowPrivacyManager.description).to(equal("ShowPrivacyManager"))
                }
            }

            describe("RejectAll") {
                it("has the raw value of 13") {
                    expect(GDPRActionType.RejectAll.rawValue).to(equal(13))
                }

                it("has its description as 'RejectAll'") {
                    expect(GDPRActionType.RejectAll.description).to(equal("RejectAll"))
                }
            }

            describe("Dismiss") {
                it("has the raw value of 15") {
                    expect(GDPRActionType.Dismiss.rawValue).to(equal(15))
                }

                it("has its description as 'Dismiss'") {
                    expect(GDPRActionType.Dismiss.description).to(equal("Dismiss"))
                }
            }
        }
    }
}
