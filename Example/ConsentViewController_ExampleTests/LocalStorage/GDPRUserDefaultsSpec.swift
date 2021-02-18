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
    func randomUserConsents() -> SPGDPRConsent {
        return SPGDPRConsent(acceptedVendors: [],
                               acceptedCategories: [],
                               legitimateInterestCategories: [],
                               specialFeatures: [],
                               vendorGrants: SPGDPRVendorGrants(),
                               euconsent: UUID().uuidString,
                               tcfData: SPJson())
    }

    override func spec() {
        var localStorage = InMemoryStorageMock()

        beforeEach {
            localStorage = InMemoryStorageMock()
        }

        describe("GDPRUserDefaults") {
            describe("consentString") {
                it("is empty string by default") {
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    expect(userDefaults.consentString).to(equal(""))
                }

                it("gets its value from the local storage") {
                    localStorage.storage = [SPUserDefaults.EU_CONSENT_KEY: "stored consentString"]
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    expect(userDefaults.consentString).to(equal("stored consentString"))
                }

                it("persists the value in the local storage") {
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    userDefaults.consentString = "new consentString"
                    let stored = localStorage.storage[SPUserDefaults.EU_CONSENT_KEY] as! String
                    expect(stored).to(equal("new consentString"))
                }
            }

            describe("consentUUID") {
                it("is empty string by default") {
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    expect(userDefaults.consentUUID).to(equal(""))
                }

                it("gets its value from the local storage") {
                    localStorage.storage = [SPUserDefaults.GDPR_UUID_KEY: "stored uuid"]
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    expect(userDefaults.consentUUID).to(equal("stored uuid"))
                }

                it("persists the value in the local storage") {
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    userDefaults.consentUUID = "new uuid"
                    let stored = localStorage.storage[SPUserDefaults.GDPR_UUID_KEY] as! String
                    expect(stored).to(equal("new uuid"))
                }
            }

            describe("meta") {
                it("is \"{}\" string by default") {
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    expect(userDefaults.meta).to(equal("{}"))
                }

                it("gets its value from the local storage") {
                    localStorage.storage = [SPUserDefaults.META_KEY: "stored meta"]
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    expect(userDefaults.meta).to(equal("stored meta"))
                }

                it("persists the value in the local storage") {
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    userDefaults.meta = "new meta"
                    let stored = localStorage.storage[SPUserDefaults.META_KEY] as! String
                    expect(stored).to(equal("new meta"))
                }
            }

            describe("authId") {
                it("is nil by default") {
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    expect(userDefaults.authId).to(beNil())
                }

                it("gets its value from the local storage") {
                    localStorage.storage = [SPUserDefaults.GDPR_AUTH_ID_KEY: "stored authId"]
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    expect(userDefaults.authId).to(equal("stored authId"))
                }

                it("persists the value in the local storage") {
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    userDefaults.authId = "new authId"
                    let stored = localStorage.storage[SPUserDefaults.GDPR_AUTH_ID_KEY] as! String
                    expect(stored).to(equal("new authId"))
                }
            }

            describe("tcfData") {
                it("is empty dictionary by default") {
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    expect(userDefaults.tcfData).to(beEmpty())
                }

                it("gets its value from the local storage") {
                    localStorage.storage = [SPUserDefaults.IAB_CMP_SDK_ID_KEY: 99]
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    expect(userDefaults.tcfData[SPUserDefaults.IAB_CMP_SDK_ID_KEY] as? Int).to(equal(99))
                }

                it("persists the value in the local storage") {
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    userDefaults.tcfData = [SPUserDefaults.IAB_CMP_SDK_ID_KEY: 99]
                    let stored = localStorage.storage[SPUserDefaults.IAB_CMP_SDK_ID_KEY] as! Int
                    expect(stored).to(equal(99))
                }
            }

            describe("userConsents") {
                it("is empty UserConsent by default") {
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    expect(userDefaults.userConsents).to(equal(SPGDPRConsent.empty()))
                }

                it("gets its value from the local storage") {
                    let userConsents = SPGDPRConsent.empty()
                    localStorage.storage = [SPUserDefaults.GDPR_USER_CONSENTS_KEY: userConsents]
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    expect(userDefaults.userConsents).to(equal(userConsents))
                }

                it("persists the value in the local storage") {
                    let userConsents = SPGDPRConsent.empty()
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    userDefaults.userConsents = userConsents
                    let stored = localStorage.storage[SPUserDefaults.GDPR_USER_CONSENTS_KEY] as! SPGDPRConsent
                    expect(stored).to(equal(userConsents))
                }
            }

            describe("dictionaryRepresentation") {
                it("returns a dictionary containing its attributes") {
                    let userConsents = self.randomUserConsents()
                    let tcfData = ["\(SPUserDefaults.IAB_KEY_PREFIX)foo": "bar"]
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    userDefaults.authId = "auth id"
                    userDefaults.consentUUID = "consent uuid"
                    userDefaults.consentString = "consent string"
                    userDefaults.meta = "meta"
                    userDefaults.userConsents = userConsents
                    userDefaults.tcfData = tcfData
                    let dict = userDefaults.dictionaryRepresentation()
                    expect((dict[SPUserDefaults.EU_CONSENT_KEY] as? String)).to(equal("consent string"))
                    expect((dict[SPUserDefaults.GDPR_UUID_KEY] as? String)).to(equal("consent uuid"))
                    expect((dict[SPUserDefaults.META_KEY] as? String)).to(equal("meta"))
                    expect((dict[SPUserDefaults.GDPR_AUTH_ID_KEY] as? String)).to(equal("auth id"))
                    expect((dict[SPUserDefaults.GDPR_USER_CONSENTS_KEY] as? SPGDPRConsent)).to(equal(userConsents))
                    expect((dict["\(SPUserDefaults.IAB_KEY_PREFIX)foo"] as? String)).to(equal("bar"))
                }

                it("returns a dictionary containing only its attributes") {
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    let attributes = [
                        SPUserDefaults.EU_CONSENT_KEY,
                        SPUserDefaults.GDPR_UUID_KEY,
                        SPUserDefaults.META_KEY,
                        SPUserDefaults.GDPR_AUTH_ID_KEY,
                        SPUserDefaults.GDPR_USER_CONSENTS_KEY
                    ]
                    let dict = userDefaults.dictionaryRepresentation().keys.filter { key in !attributes.contains(key) }
                    expect(dict).to(beEmpty())
                }
            }

            describe("clear") {
                it("sets consentString back to its default value") {
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    userDefaults.consentString = "foo"
                    userDefaults.clear()
                    expect(userDefaults.consentString).to(equal(""))
                }

                it("sets authId back to its default value") {
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    userDefaults.authId = "foo"
                    userDefaults.clear()
                    expect(userDefaults.authId).to(beNil())
                }

                it("sets consentUUID back to its default value") {
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    userDefaults.consentUUID = "foo"
                    userDefaults.clear()
                    expect(userDefaults.consentUUID).to(equal(""))
                }

                it("sets meta back to its default value") {
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    userDefaults.meta = "foo"
                    userDefaults.clear()
                    expect(userDefaults.meta).to(equal("{}"))
                }

                it("sets userConsents back to its default value") {
                    let userDefaults = SPUserDefaults(storage: localStorage)
                    userDefaults.userConsents = self.randomUserConsents()
                    userDefaults.clear()
                    expect(userDefaults.userConsents).to(equal(SPGDPRConsent.empty()))
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
