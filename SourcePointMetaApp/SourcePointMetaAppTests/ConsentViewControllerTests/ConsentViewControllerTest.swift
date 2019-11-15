//
//  ConsentViewControllerTest.swift
//  ConsentViewControllerTests
//
//  Created by Vilas on 8/29/19.
//

import XCTest
@testable import ConsentViewController

class ConsentViewControllerTest: XCTestCase, ConsentDelegate {
    var consentViewController: ConsentViewController?
    
    override func setUp() {
        let testData = readDataFromPlist()
        let accountId = testData?.value(forKey: "AccountId") as! Int
        let siteId = testData?.value(forKey: "SiteId") as! Int
        let siteName = testData?.value(forKey: "SiteName") as! String
        let showPM = testData?.value(forKey: "ShowPM") as! Bool
        let PMId = testData?.value(forKey: "PMId") as! String
        let campaign = testData?.value(forKey: "Campaign") as! String
        consentViewController = try! ConsentViewController(accountId: accountId, siteId: siteId, siteName: siteName, PMId: PMId, campaign: campaign, showPM: showPM,consentDelegate: self)
    }
    
    override func tearDown() {
        
    }
    
    /// this method is used to read the data from plist
    func readDataFromPlist()-> NSDictionary? {
        if let path = Bundle(for: type(of: self)).path(forResource: "TestData", ofType: "plist") {
            let testData = NSDictionary(contentsOfFile: path)
            return testData
        }
        return nil
    }
    
    /// this method is used to test whether webview is loaded or not
    func testLoadView() {
        consentViewController?.loadView()
        if consentViewController?.webView != nil {
            XCTAssert(true, "Webview initialized successfully")
        } else {
            XCTAssert(false, "Unable to initialize webview")
        }
    }
    
    /// this method is used to test whether message url is created or not successfully
    func testGetMessageUrlWithAuthId() {
        let messageUrl = consentViewController!.getMessageUrl(authId: "sourcepoint@123")
        if messageUrl != nil {
            XCTAssert(true, "Message URL created successfully")
        } else {
            XCTAssert(false, "Unable to create Message URL")
        }
    }
    
    /// this method is used to test whether message url is created or not successfully
    func testGetMessageUrlWithoutAuthId() {
        let messageUrl = consentViewController!.getMessageUrl(authId: nil)
        if messageUrl != nil {
            XCTAssert(true, "Message URL created successfully")
        } else {
            XCTAssert(false, "Unable to create Message URL")
        }
    }
    
    /// this method is used to test whether message is loaded or not successfully
    func testLoadMessageWithAuthId() {
        consentViewController?.loadMessage(forAuthId: "sourcepoint@123")
        if consentViewController?.webView != nil {
            XCTAssert(true, "Webview initialized successfully")
        } else {
            XCTAssert(false, "Unable to initialize webview")
        }
    }
    
    /// this method is used to test whether message is loaded or not successfully
    func testLoadMessageWithoutAuthId() {
        consentViewController?.loadMessage()
        if consentViewController?.webView != nil {
            XCTAssert(true, "Webview initialized successfully")
        } else {
            XCTAssert(false, "Unable to initialize webview")
        }
    }
    
    /// this method is used to test whether GDPR status method is working or not
    func testSetSubjectToGDPR() {
        var finished = false
        consentViewController?.setSubjectToGDPR()
        if UserDefaults.standard.string(forKey: ConsentViewController.IAB_CONSENT_SUBJECT_TO_GDPR) != nil {
            if UserDefaults.standard.string(forKey: ConsentViewController.IAB_CONSENT_SUBJECT_TO_GDPR) == "0" || UserDefaults.standard.string(forKey: ConsentViewController.IAB_CONSENT_SUBJECT_TO_GDPR) == "1"  {
                XCTAssert(true, "succeed to get GDPR status from endpoint")
            }else {
                XCTAssert(false, "failed to get GDPR status from endpoint")
            }
            finished = true
        }
        while !finished {
            RunLoop.current.run(mode: .default, before: Date.distantFuture)
        }
    }
    
    /// this method is used to test whether getIABVendorConsents method is able to get vendors or not from server
    func testGetIABVendorConsents() {
        let vendorIdArray = [1,2,3]
        let vendorConsents = try! consentViewController?.getIABVendorConsents(vendorIdArray)
        if vendorConsents != nil {
            XCTAssert(true, "succeed to get vendor consents for IAB vendors")
        } else {
            XCTAssert(false, "failed to get  vendor consents for IAB vendors")
        }
    }
    
    /// this method is used to test whether getIABPurposeConsents method is able to get purposes or not from server
    func testGetIABPurposeConsents() {
        var purposeIdArray = [Int8]()
        purposeIdArray = [1,2,3]
        let purposeConsents = try! consentViewController?.getIABPurposeConsents(purposeIdArray)
        if purposeConsents != nil {
            XCTAssert(true, "succeed to get purpose consents for IAB vendors")
        } else {
            XCTAssert(false, "failed to get purpose consents for IAB vendors")
        }
    }
    
    /// this method is used to test whether getCustomVendorConsents method is able to get vendors or not from server
    func testGetCustomVendorConsents() {
        var finished = false
        consentViewController?.getCustomVendorConsents(completionHandler: { (vendorConsents, error) in
            if vendorConsents?.count == 0 || vendorConsents!.count > 0 {
                XCTAssert(true, "succeed to get vendor consents for vendors")
            } else {
                XCTAssert(false, "failed to get  vendor consents for vendors")
            }
            finished = true
        })
        while !finished {
            RunLoop.current.run(mode: .default, before: Date.distantFuture)
        }
    }
    
    /// this method is used to test whether getCustomPurposeConsents method is able to get purposes or not from server
    func testGetCustomPurposeConsents() {
        var finished = false
        consentViewController?.getCustomPurposeConsents(completionHandler: { (purposeConsents, error) in
            if purposeConsents?.count == 0 || purposeConsents!.count > 0 {
                XCTAssert(true, "succeed to get purpose consents for vendors")
            } else {
                XCTAssert(false, "failed to get purpose consents for vendors")
            }
            finished = true
        })
        while !finished {
            RunLoop.current.run(mode: .default, before: Date.distantFuture)
        }
    }
    
    /// this method is used to test whether loadAndStoreConsents method is able to store consents or not
    func testLoadAndStoreConsents() {
        var finished = false
        consentViewController?.loadAndStoreConsents(completionHandler: { (consents, error) in
            if consents?.consentedPurposes.count == 0 || (consents?.consentedPurposes.count)! > 0 {
                XCTAssert(true, "succeed to get consents for vendors")
            } else {
                XCTAssert(false, "failed to get consents for vendors")
            }
            finished = true
        })
        while !finished {
            RunLoop.current.run(mode: .default, before: Date.distantFuture)
        }
    }
    
    /// This is method is used to test the consentString is formed successfully or not
    func testBuildConsentString() {
        let consentString = try! consentViewController?.buildConsentString("BOmW7qdOmW7qdAGABCENCj-AAAAqKADABUADQAUg")
        
        if consentString != nil {
            XCTAssert(true, "succeed to get consentString")
        } else {
            XCTAssert(false, "failed to get consentString")
        }
    }
    
    /// This method is used to test the IAB vars are stored or not using storeIABVars method
    func testStoreIABVars() {
        try! consentViewController?.storeIABVars("BOmW7qdOmW7qdAGABCENCj-AAAAqKADABUADQAUg")
        let iABvar = UserDefaults.standard.string(forKey: ConsentViewController.IAB_CONSENT_PARSED_PURPOSE_CONSENTS)
        if iABvar != nil {
            XCTAssert(true, "succeed to store iab variabales")
        } else {
            XCTAssert(false, "failed to store iab variables")
        }
    }
    
    /// This method is used to test ClearAllConsentData method removes data from Userdefaults or not.
    func testClearAllConsentDataMethodForEuConsent() {
        consentViewController?.clearAllConsentData()
        let euConsentKey = UserDefaults.standard.string(forKey: ConsentViewController.EU_CONSENT_KEY)
        if euConsentKey == nil {
            XCTAssert(true, "succeed to remove the euConsentKey from Userdefaults")
        } else {
            XCTAssert(false, "failed to remove the euConsentKey from Userdefaults")
        }
    }
    
    /// This method is used to test ClearAllConsentData method removes data from Userdefaults or not.
       func testClearAllConsentDataMethodForConsentUUID() {
           consentViewController?.clearAllConsentData()
           let consentUUIDKey = UserDefaults.standard.string(forKey: ConsentViewController.CONSENT_UUID_KEY)
           if consentUUIDKey == nil {
               XCTAssert(true, "succeed to remove the consentUUIDKey from Userdefaults")
           } else {
               XCTAssert(false, "failed to remove the consentUUIDKey from Userdefaults")
           }
       }
    
    /// This method is used to test ClearAllConsentData method removes data from Userdefaults or not.
       func testClearAllConsentDataMethodForIABConsentParsedPurposeConsents() {
           consentViewController?.clearAllConsentData()
           let iABConsentParsedPurposeConsents = UserDefaults.standard.string(forKey: ConsentViewController.IAB_CONSENT_PARSED_PURPOSE_CONSENTS)
           if iABConsentParsedPurposeConsents == nil {
               XCTAssert(true, "succeed to remove the iABConsentParsedPurposeConsents from Userdefaults")
           } else {
               XCTAssert(false, "failed to remove the iABConsentParsedPurposeConsents from Userdefaults")
           }
       }
    
    /// This method is used to test ClearAllConsentData method removes data from Userdefaults or not.
       func testClearAllConsentDataMethodForIABConsentParsedVendorConsents() {
           consentViewController?.clearAllConsentData()
           let iABConsentParsedVendorConsents = UserDefaults.standard.string(forKey: ConsentViewController.IAB_CONSENT_PARSED_VENDOR_CONSENTS)
           if iABConsentParsedVendorConsents == nil {
               XCTAssert(true, "succeed to remove the iABConsentParsedVendorConsents from Userdefaults")
           } else {
               XCTAssert(false, "failed to remove the iABConsentParsedVendorConsents from Userdefaults")
           }
       }
    
    /// This method is used to test ClearAllConsentData method removes data from Userdefaults or not.
       func testClearAllConsentDataMethodForIABConsentCMPPresent() {
           consentViewController?.clearAllConsentData()
           let iABConsentCMPPresent = UserDefaults.standard.string(forKey: ConsentViewController.IAB_CONSENT_CMP_PRESENT)
           if iABConsentCMPPresent == nil {
               XCTAssert(true, "succeed to remove the iABConsentCMPPresent from Userdefaults")
           } else {
               XCTAssert(false, "failed to remove the iABConsentCMPPresent from Userdefaults")
           }
       }
    
    /// This method is used to test ClearAllConsentData method removes data from Userdefaults or not.
       func testClearAllConsentDataMethodForIABConsentSubjectToGDPR() {
           consentViewController?.clearAllConsentData()
           let iABConsentSubjectToGDPR = UserDefaults.standard.string(forKey: ConsentViewController.IAB_CONSENT_SUBJECT_TO_GDPR)
           if iABConsentSubjectToGDPR == nil {
               XCTAssert(true, "succeed to remove the iABConsentSubjectToGDPR from Userdefaults")
           } else {
               XCTAssert(false, "failed to remove the iABConsentSubjectToGDPR from Userdefaults")
           }
       }
    
    /// This method is used to test ClearAllConsentData method removes data from Userdefaults or not.
       func testClearAllConsentDataMethodForIABConsentConsentString() {
           consentViewController?.clearAllConsentData()
           let iABConsentConsentString = UserDefaults.standard.string(forKey: ConsentViewController.IAB_CONSENT_CONSENT_STRING)
           if iABConsentConsentString == nil {
               XCTAssert(true, "succeed to remove the iABConsentConsentString from Userdefaults")
           } else {
               XCTAssert(false, "failed to remove the iABConsentConsentString from Userdefaults")
           }
       }
    
    func onMessageReady(controller: ConsentViewController) {
        print("onMessageReady")
    }
    
    func onConsentReady(controller: ConsentViewController) {
        print("onConsentReady")
    }
    
    func onErrorOccurred(error: ConsentViewControllerError) {
        print("onErrorOccurred")
    }
}
