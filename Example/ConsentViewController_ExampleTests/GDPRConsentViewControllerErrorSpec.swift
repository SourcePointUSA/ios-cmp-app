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

func emptyRequest() -> URLRequest {
    return URLRequest(url: URL(string: "/")!)
}

func aResponseWith(status: Int) -> HTTPURLResponse {
    return HTTPURLResponse(url: URL(string: "/")!, statusCode: status, httpVersion: nil, headerFields: nil)!
}

// swiftlint:disable function_body_length

class GDPRConsentViewControllerErrorSpec: QuickSpec {
    override func spec() {
        let url = "https://notice.sp-prod.net/?message_id=59706"
        describe("GDPRConsentViewControllerErrorSpec") {
            describe("GenericNetworkError") {
                it("has spCode: generic_network_request_{response.status}") {
                    let error = GenericNetworkError(request: emptyRequest(), response: nil)
                    expect(error.spCode).to(equal("generic_network_request_999"))
                }
            }

            describe("NoInternetConnection") {
                it("has spCode: no_internet_connection") {
                    expect(NoInternetConnection().spCode).to(equal("no_internet_connection"))
                }
            }

            describe("InternalServerError") {
                it("has spCode: internal_server_error_{response.statusCode}") {
                    let error = InternalServerError(request: emptyRequest(), response: aResponseWith(status: 502))
                    expect(error.spCode).to(equal("internal_server_error_502"))
                }
            }

            describe("ResourceNotFoundError") {
                it("has spCode: resource_not_found_{response.statusCode}") {
                    let error = ResourceNotFoundError(request: emptyRequest(), response: aResponseWith(status: 404))
                    expect(error.spCode).to(equal("resource_not_found_404"))
                }
            }

            describe("ConnectionTimeOutError") {
                it("has spCode: connection_timeout") {
                    expect(ConnectionTimeOutError(url: nil, timeout: nil).spCode).to(equal("connection_timeout"))
                }
            }

            describe("InvalidURLError") {
                it("has spCode: invalid_url") {
                    expect(InvalidURLError(urlString: "").spCode).to(equal("invalid_url"))
                }
            }

            describe("WebViewError") {
                it("has spCode: web_view_error") {
                    expect(WebViewError().spCode).to(equal("web_view_error"))
                }
            }

            describe("InvalidResponseWebMessageError") {
                it("has spCode: invalid_response_web_message") {
                    expect(InvalidResponseWebMessageError().spCode).to(equal("invalid_response_web_message"))
                }
            }

            describe("InvalidResponseNativeMessageError") {
                it("has spCode: invalid_response_native_message") {
                    expect(InvalidResponseNativeMessageError().spCode).to(equal("invalid_response_native_message"))
                }
            }

            describe("InvalidResponseConsentError") {
                it("has spCode: invalid_response_consent") {
                    expect(InvalidResponseConsentError().spCode).to(equal("invalid_response_consent"))
                }
            }

            describe("InvalidResponseCustomError") {
                it("has spCode: invalid_response_custom_consent") {
                    expect(InvalidResponseCustomError().spCode).to(equal("invalid_response_custom_consent"))
                }
            }

            describe("InvalidEventPayloadError") {
                it("has spCode: invalid_event_payload") {
                    expect(InvalidEventPayloadError().spCode).to(equal("invalid_event_payload"))
                }
            }

            describe("InvalidOnActionEventPayloadError") {
                it("has spCode: invalid_event_payload") {
                    expect(InvalidOnActionEventPayloadError().spCode).to(equal("invalid_onAction_event_payload"))
                }
            }

            describe("RenderingAppError") {
                describe("if not code is provided") {
                    it("its spCode should be rendering_app_error") {
                        expect(RenderingAppError(nil).spCode).to(equal("rendering_app_error"))
                    }
                }

                describe("if a code is provided") {
                    it("its spCode should be the same as the code provided") {
                        expect(RenderingAppError("foo").spCode).to(equal("foo"))
                    }
                }
            }

            describe("InvalidRequestError") {
                it("has spCode: invalid_request_error") {
                    expect(InvalidRequestError().spCode).to(equal("invalid_request_error"))
                }
            }

            it("Test APIParsingError method") {
                let errorObject = APIParsingError(url, nil)
                expect(errorObject.description).to(equal("Error parsing response from https://notice.sp-prod.net/?message_id=59706: nil"))
            }

            it("Test InvalidArgumentError method") {
                let errorObject = InvalidArgumentError(message: "The operation couldn't be completed")
                expect(errorObject.description).to(equal("The operation couldn't be completed"))
            }
        }
    }
}
