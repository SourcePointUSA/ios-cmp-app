//
//  ObjC_ExampleAppUITests.swift
//  ObjC-ExampleAppUITests
//
//  Created by Vilas on 08/02/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import Quick
import Nimble
@testable import ConsentViewController

class ObjC_ExampleAppUITests: QuickSpec {
    var app: ExampleApp!

    override func spec() {
        beforeSuite {
            self.continueAfterFailure = false
            self.app = ExampleApp()
        }

        beforeEach {
            self.app.relaunch(clean: true)
        }

        if #available(iOS 14.0, *) {
            xit("Accept ATT pre-prompt") {
                expect(self.app.attPrePromptMessage).to(showUp())
                self.app.acceptATTButton.tap()
                // TODO: interact with the native ATT alert
            }
        }

        it("Accept all through message") {
            expect(self.app.consentMessage).to(showUp())
            self.app.acceptAllButton.tap()
            expect(self.app.consentMessage).to(disappear())
        }
    }
}
