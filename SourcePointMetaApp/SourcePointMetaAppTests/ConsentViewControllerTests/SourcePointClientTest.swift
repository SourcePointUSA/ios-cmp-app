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
    var accountId: Int = 0
    var siteId: Int = 0
    var siteUrl: String = ""
    var campaign: String = ""
    var pmId: String = ""
    var showPM: Bool = false
    var authId: String = ""
    var mmsUrl: String = ""
    var cmpUrl: String = ""
    var messageUrl: String = ""
    var consentUUID: String = ""
    var euConsent: String = ""
    
    
    override func setUp() {
        readDataFromPlist()
        sourcepointClient = try! SourcePointClient(accountId: accountId, siteId: siteId, pmId: pmId, showPM: showPM, siteUrl: URL(string: siteUrl)!, campaign: campaign, mmsUrl: URL(string: mmsUrl)!, cmpUrl: URL(string: cmpUrl)!, messageUrl: URL(string: messageUrl)!)
    }
    
    /// this method is used to read test data from plist
    func readDataFromPlist() {
        if let path = Bundle(for: type(of: self)).path(forResource: "TestData", ofType: "plist") {
            let testData = NSDictionary(contentsOfFile: path)
            accountId = testData?.value(forKey: "AccountId") as! Int
            siteId = testData?.value(forKey: "SiteId") as! Int
            showPM = testData?.value(forKey: "ShowPM") as! Bool
            pmId = testData?.value(forKey: "PMId") as! String
            campaign = testData?.value(forKey: "Campaign") as! String
            siteUrl = testData?.value(forKey: "SiteUrl") as! String
            mmsUrl = testData?.value(forKey: "MmsUrl") as! String
            cmpUrl = testData?.value(forKey: "CmpUrl") as! String
            messageUrl = testData?.value(forKey: "MessageUrl") as! String
            consentUUID = testData?.value(forKey: "ConsentUUID") as! String
            euConsent = testData?.value(forKey: "EUConsent") as! String
        }
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
        sourcepointClient?.getCustomConsents(forSiteId: "\(siteId)", consentUUID: consentUUID, euConsent: euConsent, completionHandler: { (consents, error) in
            
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
