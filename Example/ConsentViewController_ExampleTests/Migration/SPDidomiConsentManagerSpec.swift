//
//  SPDidomiConsentManagerSpec.swift
//  ConsentViewController_ExampleTests
//
//  Integration tests of `SPDidomiConsentManager` (the Sourcepoint API on top of the real Didomi SDK),
//  using the local GDPR config of the test bundle.
//

@testable import ConsentViewController
import Didomi
import Foundation
import Nimble
import Quick
import XCTest

// swiftlint:disable force_try function_body_length line_length

private let config = "SourcepointConfigGDPR"
private let gameAccountsVendor = "5ff4d000a228633ac048be41"
private let gameAccountsPurpose = "608bad95d08d3112188e0e36"
private let otherVendor = "5e7ced57b8e05c485246cce0"

class SPDidomiConsentManagerSpec: QuickSpec {
    override class func spec() {
        var delegate: MockDidomiDelegate!
        var manager: SPDidomiConsentManager!

        func makeManager(timeout: TimeInterval? = nil) -> SPDidomiConsentManager {
            let manager = SPDidomiConsentManager(
                apiKey: "eea5ad63-29d4-4552-9dac-2edebe1fe518",
                noticeId: "BVP3EcHb",
                language: .BrowserDefault,
                configFileName: config,
                delegate: delegate
            )
            if let timeout { manager.messageTimeoutInSeconds = timeout }
            return manager
        }

        func clearConsentData() {
            let userDefaults = UserDefaults.standard
            userDefaults.dictionaryRepresentation().keys.filter { key in
                key.contains("IAB") || key.lowercased().contains("didomi") || key.hasPrefix("sp_") || key.hasPrefix("sp.")
            }.forEach { userDefaults.removeObject(forKey: $0) }
            userDefaults.synchronize()
        }

        func grant(of vendorId: String, in userData: SPUserData?) -> Bool? {
            userData?.gdpr?.consents?.vendorGrants[vendorId]?.granted
        }

        beforeEach {
            if Didomi.shared.isReady() { Didomi.shared.reset() }
            clearConsentData()
            BundleSwizzler.enableConfigFileRedirection(config)
            delegate = MockDidomiDelegate()
        }

        afterEach {
            // Didomi is a singleton: let it finish starting up so it doesn't leak into the next test
            if manager != nil { expect(Didomi.shared.isReady()).toEventually(beTrue(), timeout: .seconds(10)) }
            BundleSwizzler.disableConfigFileRedirection()
            if Didomi.shared.isReady() { Didomi.shared.reset() }
            clearConsentData()
            manager = nil
            delegate = nil
        }

        describe("id translation") {
            it("matches Sourcepoint ids through the namespace, falling back to the Didomi id") {
                let ids = SPDidomiConsentManager.didomiIds(
                    forSourcepointIds: ["sp-1", "didomi-only", "unknown"],
                    in: [("didomi-1", "sp-1"), ("didomi-only", nil), ("didomi-3", "sp-3")]
                )
                expect(ids).to(equal(["didomi-1", "didomi-only"]))
            }
        }

        describe("userData") {
            it("is empty, and doesn't make Didomi complain, before the SDK is ready") {
                manager = makeManager()
                expect(manager.userData.gdpr).to(beNil())
                expect(manager.gdprApplies).to(beFalse())
                expect(delegate.count(.error)).to(equal(0))
            }
        }

        describe("loadMessage") {
            it("forwards Didomi's view controller to onSPUIReady so the host can present it") {
                manager = makeManager()
                manager.loadMessage(forAuthId: nil, publisherData: SPPublisherData())
                expect(delegate.count(.uiReady)).toEventually(equal(1), timeout: .seconds(10))
                expect(delegate.count(.error)).to(equal(0))
                expect(delegate.count(.consentReady)).to(equal(0))
                expect(delegate.count(.finished)).to(equal(0))
            }
        }

        describe("onConsentReady") {
            it("is called for every consent change, even if it didn't come from the UI") {
                manager = makeManager()
                manager.loadMessage(forAuthId: nil, publisherData: SPPublisherData())
                expect(delegate.count(.uiReady)).toEventually(equal(1), timeout: .seconds(10))

                Didomi.shared.setUserAgreeToAll()
                expect(delegate.count(.consentReady)).toEventually(beGreaterThan(0), timeout: .seconds(5))
                expect(grant(of: gameAccountsVendor, in: delegate.consentReadyUserData)).to(beTrue())

                let calls = delegate.count(.consentReady)
                manager.rejectAll(campaignType: .gdpr)
                expect(delegate.count(.consentReady)).toEventually(beGreaterThan(calls), timeout: .seconds(5))
                expect(grant(of: gameAccountsVendor, in: delegate.consentReadyUserData)).to(beFalse())
            }
        }

        describe("custom consent") {
            beforeEach {
                manager = makeManager()
                manager.loadMessage(forAuthId: nil, publisherData: SPPublisherData())
                expect(delegate.count(.uiReady)).toEventually(equal(1), timeout: .seconds(10))
                // the user rejected everything
                manager.rejectAll(campaignType: .gdpr)
                expect(grant(of: gameAccountsVendor, in: manager.userData)).toEventually(beFalse(), timeout: .seconds(5))
            }

            it("adds consent to the given vendors and categories, on top of the existing consent, and calls the handler") {
                var consent: SPGDPRConsent?
                var calls = 0
                manager.customConsentGDPR(vendors: [gameAccountsVendor], categories: [gameAccountsPurpose], legIntCategories: []) {
                    calls += 1
                    consent = $0
                }
                expect(consent).toEventuallyNot(beNil(), timeout: .seconds(5))
                expect(calls).to(equal(1))
                expect(consent?.vendorGrants[gameAccountsVendor]?.granted).to(beTrue())
                expect(consent?.vendorGrants[gameAccountsVendor]?.purposeGrants[gameAccountsPurpose]).to(beTrue())
                expect(consent?.vendorGrants[otherVendor]?.granted).to(beFalse())
                expect(consent?.acceptedCategories).to(contain(gameAccountsPurpose))
                expect(grant(of: gameAccountsVendor, in: manager.userData)).to(beTrue())
            }

            it("removes consent with deleteCustomConsentGDPR") {
                var consent: SPGDPRConsent?
                manager.customConsentGDPR(vendors: [gameAccountsVendor], categories: [gameAccountsPurpose], legIntCategories: []) { _ in }
                expect(grant(of: gameAccountsVendor, in: manager.userData)).toEventually(beTrue(), timeout: .seconds(5))
                manager.deleteCustomConsentGDPR(vendors: [gameAccountsVendor], categories: [gameAccountsPurpose], legIntCategories: []) {
                    consent = $0
                }
                expect(consent).toEventuallyNot(beNil(), timeout: .seconds(5))
                expect(consent?.vendorGrants[gameAccountsVendor]?.granted).to(beFalse())
                expect(consent?.acceptedCategories).toNot(contain(gameAccountsPurpose))
            }

            it("leaves ids Didomi doesn't know untouched") {
                var consent: SPGDPRConsent?
                manager.customConsentGDPR(vendors: ["not-a-vendor", gameAccountsVendor], categories: ["not-a-purpose"], legIntCategories: []) {
                    consent = $0
                }
                expect(consent).toEventuallyNot(beNil(), timeout: .seconds(5))
                expect(consent?.vendorGrants["not-a-vendor"]).to(beNil())
                expect(consent?.acceptedCategories).toNot(contain("not-a-purpose"))
                expect(consent?.vendorGrants[otherVendor]?.granted).to(beFalse())
            }
        }

        describe("messageTimeoutInSeconds") {
            it("defaults to the legacy 30 seconds") {
                manager = makeManager()
                expect(manager.messageTimeoutInSeconds).to(equal(30))
            }

            it("calls onError when the message is not ready within the timeout") {
                manager = makeManager(timeout: 0.001)
                manager.loadMessage(forAuthId: nil, publisherData: SPPublisherData())
                expect(delegate.count(.error)).toEventually(equal(1), timeout: .seconds(5))
                // the load is over: a notice that would be needed once Didomi is ready is not shown for it
                expect(Didomi.shared.isReady()).toEventually(beTrue(), timeout: .seconds(10))
                expect(delegate.count(.uiReady)).toNever(beGreaterThan(0), until: .seconds(2))
                expect(delegate.count(.error)).to(equal(1))
            }

            it("doesn't call onError when the message is ready in time") {
                manager = makeManager(timeout: 5)
                manager.loadMessage(forAuthId: nil, publisherData: SPPublisherData())
                expect(delegate.count(.uiReady)).toEventually(equal(1), timeout: .seconds(10))
                expect(delegate.count(.error)).toNever(beGreaterThan(0), until: .seconds(6))
            }

            it("is disabled when 0") {
                manager = makeManager(timeout: 0)
                manager.loadMessage(forAuthId: nil, publisherData: SPPublisherData())
                expect(delegate.count(.uiReady)).toEventually(equal(1), timeout: .seconds(10))
                expect(delegate.count(.error)).to(equal(0))
            }
        }

        describe("returning users") {
            it("get onConsentReady and onSPFinished, once each, and no UI, when no message is needed") {
                manager = makeManager()
                manager.loadMessage(forAuthId: nil, publisherData: SPPublisherData())
                expect(delegate.count(.uiReady)).toEventually(equal(1), timeout: .seconds(10))
                Didomi.shared.setUserAgreeToAll()
                expect(delegate.count(.consentReady)).toEventually(beGreaterThan(0), timeout: .seconds(5))

                delegate = MockDidomiDelegate()
                manager = makeManager(timeout: 3)
                manager.loadMessage(forAuthId: nil, publisherData: SPPublisherData())
                expect(delegate.count(.finished)).toEventually(equal(1), timeout: .seconds(10))
                expect(delegate.events).to(equal([.consentReady, .finished]))
                expect(grant(of: gameAccountsVendor, in: delegate.finishedUserData)).to(beTrue())
                // the timeout was cancelled
                expect(delegate.count(.error)).toNever(beGreaterThan(0), until: .seconds(4))
                expect(delegate.count(.uiReady)).to(equal(0))
            }
        }

        describe("errors") {
            beforeEach {
                manager = makeManager()
                manager.loadMessage(forAuthId: nil, publisherData: SPPublisherData())
                expect(delegate.count(.uiReady)).toEventually(equal(1), timeout: .seconds(10))
                Didomi.shared.setUserAgreeToAll()
                expect(Didomi.shared.shouldUserStatusBeCollected()).toEventually(beFalse(), timeout: .seconds(5))
            }

            it("from Didomi reach the delegate, keeping the user's consent by default") {
                manager.didomiEventListener.onError(SPError())
                expect(delegate.count(.error)).toEventually(equal(1), timeout: .seconds(5))
                expect(Didomi.shared.shouldUserStatusBeCollected()).toNever(beTrue(), until: .seconds(1))
            }

            it("remove the user's consent if cleanUserDataOnError is true") {
                manager.cleanUserDataOnError = true
                manager.didomiEventListener.onError(SPError())
                expect(delegate.count(.error)).toEventually(equal(1), timeout: .seconds(5))
                expect(Didomi.shared.shouldUserStatusBeCollected()).toEventually(beTrue(), timeout: .seconds(5))
            }
        }

        describe("onSPFinished") {
            it("is called once, even if the notice and the preferences on top of it finish (more than once) in a row") {
                manager = makeManager()
                manager.loadMessage(forAuthId: nil, publisherData: SPPublisherData())
                expect(delegate.count(.uiReady)).toEventually(equal(1), timeout: .seconds(10))
                manager.loadGDPRPrivacyManager(withId: "any")
                expect(delegate.count(.uiReady)).toEventually(equal(2), timeout: .seconds(5))

                Didomi.shared.hidePreferences()
                Didomi.shared.hideNotice()
                expect(delegate.count(.uiFinished)).toEventually(beGreaterThanOrEqualTo(2), timeout: .seconds(5))
                expect(delegate.count(.finished)).toEventually(equal(1), timeout: .seconds(5))
                expect(delegate.count(.finished)).toNever(beGreaterThan(1), until: .seconds(2))
            }
        }

        describe("onAction") {
            it("carries the publisher data given to loadMessage") {
                manager = makeManager()
                manager.loadMessage(forAuthId: nil, publisherData: ["foo": AnyEncodable("bar"), "answer": AnyEncodable(42)])
                expect(delegate.count(.uiReady)).toEventually(equal(1), timeout: .seconds(10))

                manager.didomiEventListener.onAction(SPAction(type: .AcceptAll))
                expect(delegate.count(.action)).toEventually(equal(1), timeout: .seconds(5))
                expect(delegate.actions.first?.publisherData).to(equal(["foo": "bar", "answer": "42"]))
            }
        }

        describe("authId") {
            it("doesn't block the message flow, for the notice to be shown") {
                manager = makeManager()
                manager.loadMessage(forAuthId: "user-1", publisherData: SPPublisherData())
                expect(delegate.count(.uiReady) + delegate.count(.consentReady)).toEventually(beGreaterThan(0), timeout: .seconds(20))
                expect(delegate.count(.error)).to(equal(0))
            }
        }
    }
}

// swiftlint:enable force_try function_body_length line_length
