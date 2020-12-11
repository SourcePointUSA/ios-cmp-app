//
//  GDPRConsentViewControllerErrorSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Vilas on 19/03/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import ConsentViewController

class GDPRConsentViewControllerErrorSpec: QuickSpec {

    override func spec() {
        let url = "https://notice.sp-prod.net/?message_id=59706"
        describe("Test GDPRConsentViewControllerError methods") {

            describe("GenericNetworkError") {
                it("has spCode: generic_network_request") {
                    expect(GenericNetworkError(request: URLRequest(url: URL()), response: nil).spCode).to(equal("generic_network_request"))
                }
            }

            it("Test APIParsingError method") {
                let errorObject = APIParsingError(url, nil)
                expect(errorObject.description).to(equal("Error parsing response from https://notice.sp-prod.net/?message_id=59706: nil"))
            }

            it("Test NoInternetConnection method") {
                let errorObject = NoInternetConnection()
                expect(errorObject.failureReason).to(equal("The device is not connected to the internet."))
            }

            it("Test MessageEventParsingError method") {
                let errorObject = MessageEventParsingError(message: "The operation couldn't be completed")
                expect(errorObject.failureReason).to(equal("Could not parse message coming from the WebView The operation couldn't be completed"))
            }

            it("Test WebViewError method") {
                let errorObject = WebViewError()
                expect(errorObject.failureReason).to(equal("Something went wrong in the webview (code: 0, title: , stackTrace: )"))
            }

            it("Test URLParsingError method") {
                let errorObject = URLParsingError(urlString: url)
                expect(errorObject.failureReason).to(equal("Could not parse URL: https://notice.sp-prod.net/?message_id=59706"))
            }

            it("Test InvalidArgumentError method") {
                let errorObject = InvalidArgumentError(message: "The operation couldn't be completed")
                expect(errorObject.description).to(equal("The operation couldn't be completed"))
            }
        }
    }
}
