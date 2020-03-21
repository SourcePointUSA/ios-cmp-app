//
//  ConsentStringSDKSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Vilas on 20/03/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import ConsentViewController

class StringSpec: QuickSpec {
    
    override func spec() {
        
        describe("Test String methods") {
            
            it("Test fromWebSafe method") {
                let webSafe = "Test-String_forWeb".fromWebSafe()
                expect(webSafe).to(equal("Test+String/forWeb"))
            }
            
            it("Test toWebSafe method") {
                let webSafe = "Test+String/forWeb".toWebSafe()
                expect(webSafe).to(equal("Test-String_forWeb"))
            }
            
            it("Test base64Padded variable value") {
                let padding = "Web".base64Padded
                expect(padding).to(equal("Web="))
            }
        }
    }
}

class DataSpec: QuickSpec {
    override func spec() {
        
        describe("Test Data methods") {
            
            let data = "{\"url\": \"https://notice.sp-prod.net/?message_id=59706\"}".data(using: .utf8)
            
            it("Test bytes method") {
                let byteArray = data?.bytes(fromBit: 12, toBit: 90123456)
                expect(byteArray).to(equal([0, 39, 87, 38, 194, 35, 162, 2, 38]))
            }
            
            it("Test data method") {
                let byteArray = data?.data(fromBit: 12, toBit: 90123456)
                expect(byteArray?.count).to(equal(9))
            }
            
            it("Test intValue method") {
                let intValue = data?.intValue(fromBit: 12, toBit: 90123456)
                expect(intValue).to(equal(11073348069204482))
            }
            

            it("Test byte method") {
                let byteInt = data?.byte(forBit: 12)
                expect(byteInt).to(equal(1))
            }
        }
    }
}

class ConsentStringSpec: QuickSpec {
    
    func getConsentString() -> ConsentString {
        return try! ConsentString(consentString: "COwkbAyOwkbAyAGABBENAeCAAAAAAAAAAAAAAAAAAAAA")
    }
    
    override func spec() {
        
        var consentString: ConsentString?
        
        describe("Test ConsentString methods") {
            
            beforeEach {
                consentString = self.getConsentString()
            }
            it("Test consentString variable") {
                let consentString = consentString?.consentString
                expect(consentString).to(equal("COwkbAyOwkbAyAGABBENAeCAAAAAAAAAAAAAAAAAAAAA"))
            }
            
            it("Test cmpId variable") {
                let cmpId = consentString?.cmpId
                expect(cmpId).to(equal(6))
            }
            
            it("Test consentScreen variable") {
                let consentScreen = consentString?.consentScreen
                expect(consentScreen).to(equal(1))
            }
            
            it("Test consentLanguage variable") {
                let consentLanguage = consentString?.consentLanguage
                expect(consentLanguage).to(equal("EN"))
            }
            
            it("Test purposesAllowed variable") {
                let purposesAllowed = consentString?.purposesAllowed
                expect(purposesAllowed).to(equal([5]))
            }
            
            it("Test maxVendorId variable") {
                let maxVendorId = consentString?.maxVendorId
                expect(maxVendorId).to(equal(0))
            }
            
            it("Test purposeAllowed method") {
                let purposesAllowed = consentString?.purposeAllowed(forPurposeId: 20)
                expect(purposesAllowed).to(equal(false))
            }
            
            it("Test isVendorAllowed method") {
                let isVendorAllowed = consentString?.isVendorAllowed(vendorId: -15)
                expect(isVendorAllowed).to(equal(false))
            }
        }
    }
}

class LoggerSpec: QuickSpec {
    
    override func spec() {
        
        var logger: Logger?
        
        describe("Test Logger method") {
            
            beforeEach {
                logger = Logger()
            }
            it("Test log method") {
                logger?.log("Error: %{public}@", ["Something Went Wrong"])
                _ = expect("[Consent] Error: Something Went Wrong")
            }
        }
    }
}

