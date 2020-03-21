//
//  GDPRMessageViewControllerSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Vilas on 3/18/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import ConsentViewController

class GDPRMessageViewControllerSpec: QuickSpec {

    override func spec() {
        let messageViewController = GDPRMessageViewController()
        
        describe("Test GDPRMessageUIDelegate methods") {
          
            context("Test loadMessage delegate method") {
                it("Test GDPRMessageViewController calls loadMessage delegate method") {
                    let WRAPPER_API = URL(string: "https://wrapper-api.sp-prod.net/tcfv2/v1/gdpr/")!
                    messageViewController.loadMessage(fromUrl: WRAPPER_API)
                    expect(messageViewController).notTo(beNil(), description: "loadMessage delegate method calls successfully")
                }
            }
            context("Test loadPrivacyManager delegate method") {
                it("Test GDPRMessageViewController calls loadPrivacyManager delegate method") {
                    messageViewController.loadPrivacyManager()
                    expect(messageViewController).notTo(beNil(), description: "loadPrivacyManager delegate method calls successfully")
                }
            }
        }
    }
}
