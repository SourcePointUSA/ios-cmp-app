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
    override func spec() {
        describe("osVersion") {
            it("should contain the major version in its return") {
                let version = SPDevice.standard.osVersion
                if #available(iOS 16, *) {
                    expect(version).to(contain("16."))
                } else if #available(iOS 15, *) {
                    expect(version).to(contain("15."))
                } else if #available(iOS 14, *) {
                    expect(version).to(contain("14."))
                } else if  #available(iOS 13, *) {
                    expect(version).to(contain("13."))
                } else if  #available(iOS 12, *) {
                    expect(version).to(contain("12."))
                } else if  #available(iOS 11, *) {
                    expect(version).to(contain("11."))
                } else if  #available(iOS 10, *) {
                    expect(version).to(contain("10."))
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
