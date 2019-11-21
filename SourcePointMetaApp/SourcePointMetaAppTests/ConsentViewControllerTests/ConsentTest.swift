//
//  ConsentTest.swift
//  ConsentViewControllerTests
//
//  Created by Vilas on 9/11/19.
//

import XCTest
@testable import ConsentViewController

class ConsentTest: XCTestCase {
    
     var consent : Consent?

    override func setUp() {
        consent = Consent(id: "5b76ebcd5582409726cdd85", name: "Facebook")
    }

    override func tearDown() {
    }
    
    /// this test method is used to test consent string method
    func testConsentDescription() {
        if consent?.description == "Consent(id: 5b76ebcd5582409726cdd85, name: Facebook)" {
            XCTAssert(true, "Successfully received the consent id and consent name")
        } else {
           XCTAssert(false, "Error to get the consent id and consent name")
        }
    }
}
