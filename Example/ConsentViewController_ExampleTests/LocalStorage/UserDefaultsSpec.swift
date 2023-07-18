//
//  GDPRUserDefaultsSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 06/03/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Nimble
import Quick

// swiftlint:disable force_cast function_body_length

class UserDefaultsSpec: QuickSpec {
    func randomUserConsents() -> SPUserData {
        SPUserData()
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
                    let iabKey = "\(SPUserDefaults.IAB_KEY_PREFIX)_key"
                    localStorage.storage = [iabKey: 99]
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    expect(userDefaults.tcfData?[iabKey] as? Int) == 99
                }

                it("persists the value in the local storage") {
                    let iabKey = "\(SPUserDefaults.IAB_KEY_PREFIX)_key"
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    userDefaults.tcfData = [iabKey: 99]
                    expect(localStorage.storage[iabKey] as? Int) == 99
                }
            }

            describe("userData") {
                it("is empty SPUserData by default") {
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    expect(userDefaults.userData) == SPUserData()
                }

                it("gets its value from the local storage") {
                    let userData = SPUserData()
                    localStorage.storage = [SPUserDefaults.USER_DATA_KEY: userData]
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    expect(userDefaults.userData) == userData
                }

                it("persists the value in the local storage") {
                    let userData = SPUserData()
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    userDefaults.userData = userData
                    let stored = localStorage.storage[SPUserDefaults.USER_DATA_KEY] as! SPUserData
                    expect(stored) == userData
                }
            }

            describe("dictionaryRepresentation") {
                it("returns a dictionary containing its attributes") {
                    let userData = self.randomUserConsents()
                    let tcfData = ["\(SPUserDefaults.IAB_KEY_PREFIX)foo": "bar"]
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    userDefaults.userData = userData
                    userDefaults.tcfData = tcfData
                    let dict = userDefaults.dictionaryRepresentation()
                    expect((dict[SPUserDefaults.USER_DATA_KEY] as? SPUserData)) == userData
                    expect((dict["\(SPUserDefaults.IAB_KEY_PREFIX)foo"] as? String)) == "bar"
                }

                it("returns a dictionary containing only its attributes") {
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    let attributes = [
                        SPUserDefaults.USER_DATA_KEY,
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
                    userDefaults.userData = self.randomUserConsents()
                    userDefaults.clear()
                    expect(userDefaults.userData) == SPUserData()
                }

                it("sets tcfData back to its default value") {
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    userDefaults.tcfData = ["foo": "bar"]
                    userDefaults.clear()
                    expect(userDefaults.tcfData).to(beEmpty())
                }
            }

            describe("childPMId") {
                it("sets gdprChildPMId and checks it") {
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    userDefaults.gdprChildPmId = "yo"
                    expect(userDefaults.gdprChildPmId) == "yo"
                }

                it("sets ccpaChildPMId and checks it") {
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    userDefaults.ccpaChildPmId = "yo"
                    expect(userDefaults.ccpaChildPmId) == "yo"
                }
            }
        }
    }
}
