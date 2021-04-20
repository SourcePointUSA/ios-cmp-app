//
//  GDPRUserDefaultsSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 06/03/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import ConsentViewController

// swiftlint:disable force_cast function_body_length

class GDPRUserDefaultsSpec: QuickSpec {
    func randomUserConsents() -> SPConsents {
        SPConsents()
    }

    override func spec() {
        var localStorage = InMemoryStorageMock()

        beforeEach {
            localStorage = InMemoryStorageMock()
        }

        describe("GDPRUserDefaults") {
            describe("tcfData") {
                it("is empty dictionary by default") {
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    expect(userDefaults.tcfData).to(beEmpty())
                }

                it("gets its value from the local storage") {
                    localStorage.storage = [SPUserDefaults.IAB_CMP_SDK_ID_KEY: 99]
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    expect(userDefaults.tcfData?[SPUserDefaults.IAB_CMP_SDK_ID_KEY] as? Int).to(equal(99))
                }

                it("persists the value in the local storage") {
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    userDefaults.tcfData = [SPUserDefaults.IAB_CMP_SDK_ID_KEY: 99]
                    let stored = localStorage.storage[SPUserDefaults.IAB_CMP_SDK_ID_KEY] as! Int
                    expect(stored).to(equal(99))
                }
            }

            describe("consentsProfile") {
                it("is empty ConsentsProfile by default") {
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    expect(userDefaults.consentsProfile).to(equal(ConsentsProfile()))
                }

                it("gets its value from the local storage") {
                    let profile = ConsentsProfile()
                    localStorage.storage = [SPUserDefaults.CONSENTS_PROFILE_KEY: profile]
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    expect(userDefaults.consentsProfile).to(equal(profile))
                }

                it("persists the value in the local storage") {
                    let profile = ConsentsProfile()
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    userDefaults.consentsProfile = profile
                    let stored = localStorage.storage[SPUserDefaults.CONSENTS_PROFILE_KEY] as! ConsentsProfile
                    expect(stored).to(equal(profile))
                }
            }

            describe("dictionaryRepresentation") {
                it("returns a dictionary containing its attributes") {
                    let profile = self.randomUserConsents()
                    let tcfData = ["\(SPUserDefaults.IAB_KEY_PREFIX)foo": "bar"]
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    userDefaults.consentsProfile = profile
                    userDefaults.tcfData = tcfData
                    let dict = userDefaults.dictionaryRepresentation()
                    expect((dict[SPUserDefaults.CONSENTS_PROFILE_KEY] as? ConsentsProfile)).to(equal(profile))
                    expect((dict["\(SPUserDefaults.IAB_KEY_PREFIX)foo"] as? String)).to(equal("bar"))
                }

                it("returns a dictionary containing only its attributes") {
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    let attributes = [
                        SPUserDefaults.CONSENTS_PROFILE_KEY,
                        SPUserDefaults.US_PRIVACY_STRING_KEY,
                        SPUserDefaults.LOCAL_STATE_KEY
                    ]
                    let dict = userDefaults.dictionaryRepresentation().keys.filter { key in !attributes.contains(key) }
                    expect(dict).to(beEmpty())
                }
            }

            describe("clear") {
                it("sets userConsents back to its default value") {
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    userDefaults.consentsProfile = self.randomUserConsents()
                    userDefaults.clear()
                    expect(userDefaults.consentsProfile).to(equal(ConsentsProfile()))
                }

                it("sets tcfData back to its default value") {
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    userDefaults.tcfData = ["foo": "bar"]
                    userDefaults.clear()
                    expect(userDefaults.tcfData).to(beEmpty())
                }
            }
        }
    }
}
