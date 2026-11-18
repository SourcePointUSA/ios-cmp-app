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

class SPDidomiConsentManagerSpec: QuickSpec {
    override class func spec() {
        var delegate: MockDidomiDelegate!
        var manager: SPDidomiConsentManager!
        // Didomi needs a container to build the notice
        let container = UIViewController()

        func makeManager(timeout: TimeInterval? = nil) -> SPDidomiConsentManager {
            let manager = SPDidomiConsentManager(
                apiKey: "eea5ad63-29d4-4552-9dac-2edebe1fe518",
                noticeId: "BVP3EcHb",
                language: .BrowserDefault,
                configFileName: config,
                delegate: delegate
            )
            manager.didomiUIController = container
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
    }
}
