//
//  SPGCMDataSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Andre Herculano on 06.02.24.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Foundation
import Nimble
import Quick


class SPGCMDataSpec: QuickSpec {
    override func spec() {
        it("is codable") {
            let rawGcm = Result { """
                {
                    "ad_user_data": "granted"
                }
                """.data(using: .utf8)
            }
            do {
                let gcm = try rawGcm.decoded() as SPGCMData
                expect(gcm.adUserData).to(equal(.granted))
            } catch {
                fail(String(describing: error))
            }
        }
    }
}

class SPGCMDataStatusSpec: QuickSpec {
    override func spec() {
        it("is codable") {
            let rawStatus = Result { "\"granted\"".data(using: .utf8) }
            do {
                let status = try rawStatus.decoded() as SPGCMData.Status
                expect(status).to(equal(.granted))
            } catch {
                fail(String(describing: error))
            }
        }
    }
}
