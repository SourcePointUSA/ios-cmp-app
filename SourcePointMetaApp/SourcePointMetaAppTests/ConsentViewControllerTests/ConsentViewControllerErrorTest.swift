//
//  ConsentViewControllerErrorTest.swift
//  ConsentViewControllerTests
//
//  Created by Vilas on 9/9/19.
//

import XCTest
@testable import ConsentViewController

class ConsentViewControllerErrorTest: XCTestCase {
    
    var consentViewControllerError: ConsentViewControllerError?
    
    override func setUp() {
        consentViewControllerError = ConsentViewControllerError()
    }
    
    override func tearDown() {
        
    }
    
    /// this test method is used to test parsing error method
    func testUnableToParseConsentStringError() {
        let errorObject = UnableToParseConsentStringError(euConsent: "BOl9F8EOl9F8EAGABBENCi-AAAAp6ABAFIA")
        if errorObject.description == "Could not parse the raw string BOl9F8EOl9F8EAGABBENCi-AAAAp6ABAFIA into a ConsentString" {
            XCTAssert(true, "Error handling for the consent parsing failure is successfully handled")
        } else {
            XCTAssert(false, "Error handling for the consent parsing failure is not handled properly")
        }
    }
    
    /// this test method is used to test property Id not found error method
    func testPropertyIDNotFound() {
        let errorObject = PropertyIDNotFound(accountId: "212", property: "mobile.demo")
        if errorObject.description == "Could not find a site with name mobile.demo for the account id 212" {
            XCTAssert(true, "Error handling for the site ID failure is successfully handled")
        } else {
            XCTAssert(false, "Error handling for the property ID failure is not handled properly")
        }
    }
    
    /// this test method is used to test invalid message url error method
    func testInvalidMessageURLError() {
        let errorObject = InvalidMessageURLError(urlString: "https://mms.sp-prod.net/get_site_data?account_id=22&href=https://mobile.dem")
        if errorObject.description == "Could not parse https://mms.sp-prod.net/get_site_data?account_id=22&href=https://mobile.dem with its query params into URL." {
            XCTAssert(true, "Error handling for the Invalid Message URL failure is successfully handled")
        } else {
            XCTAssert(false, "Error handling for the Invalid Message URL failure is not handled properly")
        }
    }
    
    /// this test method is used to test invalid url error method
    func testInvalidURLError() {
        let errorObject = InvalidURLError(urlName: "PropertyUrl", urlString: "https://mms.sp-prod.net/get_site_data?account_id=22&href=https://mobile.dem")
        if errorObject.description == "Could not convert https://mms.sp-prod.net/get_site_data?account_id=22&href=https://mobile.dem into URL.\nMake sure siteIdUrl has the correct value." {
            XCTAssert(true, "Error handling for the Invalid URL failure is successfully handled")
        } else {
            XCTAssert(false, "Error handling for the Invalid URL failure is not handled properly")
        }
    }
    
    /// this test method is used to test GDPR status not error method
    func testGdprStatusNotFound() {
        let errorObject = GdprStatusNotFound(gdprStatusUrl: URL(string: "https://sourcepoint.mgr.consensu.org/consent/v2/gdpr-status")!)
        if errorObject.description == "Could not get the GDPR status from https://sourcepoint.mgr.consensu.org/consent/v2/gdpr-status" {
            XCTAssert(true, "Error handling for GDPR status not found is successfully handled")
        } else {
            XCTAssert(false, "Error handling for GDPR status not found is not handled properly")
        }
    }
    
    /// this test method is used to test consent api error method
    func testConsentsAPIError() {
        let errorObject = ConsentsAPIError()
        if errorObject.description == "Failed to either get custom consents or unable to parse the endpoint\'s response" {
            XCTAssert(true, "Error handling if Consent API throws error is successfully handled")
        } else {
            XCTAssert(false, "Error handling if Consent API throws error is not handled properly")
        }
    }
    
    /// this test method is used to test privacy manager load error method
    func testPrivacyManagerLoadError() {
        let errorObject = PrivacyManagerLoadError()
        if errorObject.description == "Could not load the Privacy Manager due to a javascript error.\nThis is most probably happening due to a misconfiguration on the Publisher\'s portal." {
            XCTAssert(true, "Error handling if Privacy Manager is failed to load is successfully handled")
        } else {
            XCTAssert(false, "Error handling if Privacy Manager is failed to load is not handled properly")
        }
    }
    
    /// this test method is used to test privacy manager save error method
    func testPrivacyManagerSaveError() {
        let errorObject = PrivacyManagerSaveError()
        if errorObject.description == "Something wrong happened while saving the privacy settings on the Privacy Manager" {
            XCTAssert(true, "Error handling if Privacy Manager is failed to save the user consents is successfully handled")
        } else {
            XCTAssert(false, "Error handling if Privacy Manager is failed to save the user consents is not handled properly")
        }
    }
    
    /// this test method is used to test privacy manager unknown message response error method
    func testPrivacyManagerUnknownMessageResponse() {
        let bodyData = ["willShowMessage": 1]
        let errorObject = PrivacyManagerUnknownMessageResponse(name: "onReceiveMessageData", body: bodyData)
        if errorObject.description == "Couldn\'t parse message in userContentController. Called with name: onReceiveMessageData and body: [\"willShowMessage\": Optional(1)]\n" {
            XCTAssert(true, "Error handling if Privacy Manager is failed to save the user consents is successfully handled")
        } else {
            XCTAssert(false, "Error handling if Privacy Manager is failed to save the user consents is not handled properly")
        }
    }
    
    /// this test method is used to test privacy manager unknown error method
    func testPrivacyManagerUnknownError() {
        let errorObject = PrivacyManagerUnknownError()
        if errorObject.description == "Something bad happened in the javascript world.\n" {
            XCTAssert(true, "Error handling for something failed at Javascript side is handled successfully")
        } else {
            XCTAssert(false, "Error handling for something failed at Javascript side is not handled properly")
        }
    }
    
    /// this test method is used to test no internet connection error method
    func testNoInternetConnection() {
        let errorObject = NoInternetConnection()
        if errorObject.description == "The device is not connected to the internet.\n" {
            XCTAssert(true, "Error handling for device is connected to Internet or not is handled successfully")
        } else {
            XCTAssert(false, "Error handling for device is connected to Internet or not is not handled properly")
        }
    }
    
    /// this test method is used to test message timeout error method
    func testMessageTimeout() {
        let errorObject = MessageTimeout()
        if errorObject.description == "The Message request has timed out.\n" {
            XCTAssert(true, "Error handling for timeout error is handled successfully")
        } else {
            XCTAssert(false, "Error handling for timeout error is not handled properly")
        }
    }
}
