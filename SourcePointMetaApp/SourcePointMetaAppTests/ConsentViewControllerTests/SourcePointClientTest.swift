//
//  SourcePointClientTest.swift
//  ConsentViewControllerTests
//
//  Created by Vilas on 9/2/19.
//

import XCTest
@testable import ConsentViewController

class SourcePointClientTest: XCTestCase {
    
    var sourcepointClient: SourcePointClient?
    
    override func setUp() {
        let testData = readDataFromPlist()
        let accountId = testData?.value(forKey: "AccountId") as! Int
        let siteId = testData?.value(forKey: "SiteId") as! Int
        let showPM = testData?.value(forKey: "ShowPM") as! Bool
        let PMId = testData?.value(forKey: "PMId") as! String
        let campaign = testData?.value(forKey: "Campaign") as! String
        let siteUrl = testData?.value(forKey: "SiteUrl") as! String
        let mmsUrl = testData?.value(forKey: "MmsUrl") as! String
        let cmpUrl = testData?.value(forKey: "CmpUrl") as! String
        let messageUrl = testData?.value(forKey: "MessageUrl") as! String
        sourcepointClient = try! SourcePointClient(accountId: accountId, siteId: siteId, pmId: PMId, showPM: showPM, siteUrl: URL(string: siteUrl)!, campaign: campaign, mmsUrl: URL(string: mmsUrl)!, cmpUrl: URL(string: cmpUrl)!, messageUrl: URL(string: messageUrl)!)
    }
    
    /// this method is used to read test data from plist
    func readDataFromPlist()-> NSDictionary? {
        if let path = Bundle(for: type(of: self)).path(forResource: "TestData", ofType: "plist") {
            let testData = NSDictionary(contentsOfFile: path)
            return testData
        }
        return nil
    }
    
    override func tearDown() {
    }
    
    /// this test method is used to test getGdprStatus method working as expected or not
    func testGetGdprStatus() {
        var finished = false
        sourcepointClient?.getGdprStatus { (gdprStatus, error) in
            
            print("Gdpr Status", gdprStatus ?? "Not found")
            if error != nil {
                XCTAssert(false, "failed to get GDPR status from endpoint")
            } else {
                XCTAssert(true, "succeed to get GDPR status from endpoint")
            }
            finished = true
        }
        
        while !finished {
            RunLoop.current.run(mode: .default, before: Date.distantFuture)
        }
    }
    
     /// this test method is used to test getMessageUrl method working as expected or not
    func testGetMessageUrlWithAuthID() {
        let targetingParamModel = ["TargetingParamModel": "false"]
        let url = try! sourcepointClient?.getMessageUrl(forTargetingParams: targetingParamModel, debugLevel: "OFF", newPM: false, authId: "sourcepointtest")
        if let urlString = url?.absoluteString {
            if urlString.isEmpty {
                XCTAssert(false, "failed to create the url")
            }else {
                XCTAssert(true, "succeed to create the url")
            }
        }
    }
    
     /// this test method is used to test getMessageUrl method working as expected or not
    func testGetMessageUrlWithoutAuthID() {
        let targetingParamModel = ["TargetingParamModel": "false"]
        let url = try! sourcepointClient?.getMessageUrl(forTargetingParams: targetingParamModel, debugLevel: "OFF", newPM: false, authId: nil)
        if let urlString = url?.absoluteString {
            if urlString.isEmpty {
                XCTAssert(false, "failed to create the url")
            }else {
                XCTAssert(true, "succeed to create the url")
            }
        }
    }
    
     /// this test method is used to test getCustomConsents method working as expected or not
    func testgetCustomConsents() {
        var finished = false
        sourcepointClient?.getCustomConsents(forSiteId: "2372", consentUUID: "f645bb5b-f190-4eb7-a588-2e3d6e1886e1", euConsent: "BOmUHleOmUHleAGABBENCj-AAAAqKADABUADQAUg", completionHandler: { (consents, error) in
            
            print("consents", consents ?? "Not found")
            if error != nil {
                XCTAssert(false, "failed to get consents from endpoint")
            } else {
                XCTAssert(true, "succeed to get consents from endpoint")
            }
            finished = true
        })
        while !finished {
            RunLoop.current.run(mode: .default, before: Date.distantFuture)
        }
    }
    
    /// this test method is used to test validate method working as expected or not
    func testValidateURLMethodTest() {
        let testData = readDataFromPlist()
        let siteUrl = testData?.value(forKey: "SiteUrl") as! String
        let mmsUrl = testData?.value(forKey: "MmsUrl") as! String
        let siteIdUrl = try! Utils.validate(
            attributeName: "siteIdUrl",
            urlString: mmsUrl+"/get_site_data?account_id=" + "22" + "&href=" + siteUrl
        )
        if siteIdUrl.absoluteString.isEmpty {
            XCTAssert(false, "failed to create the url")
        }else {
            XCTAssert(true, "succeed to create the url")
        }
    }
    
     /// this test method is used to test get method working as expected or not
    func testDataTaskMethodTest() {
        let client = SimpleClient()
           var finished = false
        let getSiteIdUrl = URL(string: "https://mms.sp-prod.net/get_site_data?account_id=22&href=https://mobile.demo")
        client.get(url: getSiteIdUrl!, completionHandler: {(data) in
            if data != nil {
                XCTAssert(true, "succeed to receive the data from endpoint")
            }else {
                XCTAssert(false, "failed to receive the data from endpoint")
            }
            finished = true
        })
        while !finished {
            RunLoop.current.run(mode: .default, before: Date.distantFuture)
        }
    }
}
