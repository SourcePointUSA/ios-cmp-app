//
//  SPDeviceSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 23.12.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Foundation
import Nimble
import Quick

class SPDeviceSpec: QuickSpec {
    override class func spec() {
        describe("osVersion") {
            it("should contain the major version in its return") {
                let version = SPDevice.standard.osVersion
                if #available(iOS 26, *) {
                    expect(version).to(contain("26."))
                } else if #available(iOS 18, *) {
                    expect(version).to(contain("18."))
                } else {
                    expect(version) == "apple-unknown"
                }
            }
        }

        describe("deviceFamily") {
            it("should include iphone on its return") {
                expect(SPDevice.standard.deviceFamily).to(contain("iPhone"))
            }
        }
    }
}
