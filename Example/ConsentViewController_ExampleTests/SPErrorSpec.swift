//
//  SPErrorSpec.swift
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
// swiftlint:disable trailing_whitespace

class SPErrorSpec: QuickSpec {
    override func spec() {
        describe("SPErrorSpec") {
            describe("GenericNetworkError") {
                context("when no response object is provided") {
                    it("has spCode: generic_network_request_999") {
                        let error = GenericNetworkError(request: emptyRequest(), response: nil)
                        expect(error.spCode).to(equal("sp_metric_generic_network_request_999"))
                    }
                }

                context("when we know the response status") {
                    it("has spCode: generic_network_request_{response.status}") {
                        let error = GenericNetworkError(request: emptyRequest(), response: aResponseWith(status: 500))
                        expect(error.spCode).to(equal("sp_metric_generic_network_request_500"))
                    }
                }
            }

            describe("NoInternetConnection") {
                it("has spCode: no_internet_connection") {
                    expect(NoInternetConnection().spCode).to(equal("sp_metric_no_internet_connection"))
                }
            }

            describe("InternalServerError") {
                it("has spCode: internal_server_error_{response.statusCode}") {
                    let error = InternalServerError(request: emptyRequest(), response: aResponseWith(status: 502))
                    expect(error.spCode).to(equal("sp_metric_internal_server_error_502"))
                }
            }

            describe("ResourceNotFoundError") {
                it("has spCode: resource_not_found_{response.statusCode}") {
                    let error = ResourceNotFoundError(request: emptyRequest(), response: aResponseWith(status: 404))
                    expect(error.spCode).to(equal("sp_metric_resource_not_found_404"))
                }
            }

            describe("ConnectionTimeOutError") {
                it("has spCode: connection_timeout") {
                    expect(ConnectionTimeOutError(url: nil, timeout: nil, campaignType: .unknown).spCode).to(equal("sp_metric_connection_timeout"))
                }
            }

            describe("InvalidURLError") {
                it("has spCode: invalid_url") {
                    expect(InvalidURLError(urlString: "").spCode).to(equal("sp_metric_invalid_url"))
                }
            }

            describe("WebViewError") {
                it("has spCode: web_view_error") {
                    expect(WebViewError(campaignType: .gdpr).spCode).to(equal("sp_metric_web_view_error"))
                }
            }

            describe("InvalidResponseWebMessageError") {
                it("has spCode: invalid_response_web_message") {
                    expect(InvalidResponseWebMessageError().spCode).to(equal("sp_metric_invalid_response_web_message"))
                }
            }

            describe("InvalidResponseNativeMessageError") {
                it("has spCode: invalid_response_native_message") {
                    expect(InvalidResponseNativeMessageError().spCode).to(equal("sp_metric_invalid_response_native_message"))
                }
            }

            describe("InvalidResponseConsentError") {
                it("has spCode: invalid_response_consent") {
                    expect(InvalidResponseConsentError().spCode).to(equal("sp_metric_invalid_response_consent"))
                }
            }

            describe("InvalidResponseCustomError") {
                it("has spCode: invalid_response_custom_consent") {
                    expect(InvalidResponseCustomError().spCode).to(equal("sp_metric_invalid_response_custom_consent"))
                }
            }

            describe("InvalidEventPayloadError") {
                it("has spCode: invalid_event_payload") {
                    expect(InvalidEventPayloadError(campaignType: .gdpr).spCode).to(equal("sp_metric_invalid_event_payload"))
                }
            }

            describe("InvalidOnActionEventPayloadError") {
                it("has spCode: invalid_event_payload") {
                    expect(InvalidOnActionEventPayloadError(campaignType: .gdpr).spCode).to(equal("sp_metric_invalid_onAction_event_payload"))
                }
            }

            describe("RenderingAppError") {
                describe("if not code is provided") {
                    it("its spCode should be rendering_app_error") {
                        expect(RenderingAppError(campaignType: .gdpr, nil).spCode).to(equal("sp_metric_rendering_app_error"))
                    }
                }

                describe("if a code is provided") {
                    it("its spCode should be the same as the code provided") {
                        expect(RenderingAppError(campaignType: .gdpr, "foo").spCode).to(equal("foo"))
                    }
                }
            }

            describe("InvalidRequestError") {
                it("has spCode: invalid_request_error") {
                    expect(InvalidRequestError().spCode).to(equal("sp_metric_invalid_request_error"))
                }
            }

            describe("UnableToLoadJSReceiver") {
                it("has spCode: unable_to_load_jsreceiver") {
                    expect(UnableToLoadJSReceiver().spCode).to(equal("sp_metric_unable_to_load_jsreceiver"))
                }
            }

            it("Test InvalidArgumentError method") {
                let errorObject = InvalidArgumentError(message: "The operation couldn't be completed")
                expect(errorObject.description).to(equal("The operation couldn't be completed"))
            }
            
            describe("InvalidResponseGetMessagesEndpointMessageError") {
                it("has spCode: sp_metric_invalid_response_get_messages") {
                    expect(InvalidResponseGetMessagesEndpointMessageError().spCode).to(equal("sp_metric_invalid_response_get_messages"))
                }
            }
            
            describe("InvalidResponseMessageGDPREndpointMessageError") {
                it("has spCode: sp_metric_invalid_response_message_gdpr") {
                    expect(InvalidResponseMessageGDPREndpointMessageError().spCode).to(equal("sp_metric_invalid_response_message_gdpr"))
                }
            }
            
            describe("InvalidResponseMessageCCPAEndpointMessageError") {
                it("has spCode: sp_metric_invalid_response_message_ccpa") {
                    expect(InvalidResponseMessageCCPAEndpointMessageError().spCode).to(equal("sp_metric_invalid_response_message_ccpa"))
                }
            }
            
            describe("InvalidResponseGDPRPrivacyManagerViewEndpointMessageError") {
                it("has spCode: sp_metric_invalid_response_privacy_manager_view_gdpr") {
                    expect(InvalidResponseGDPRPrivacyManagerViewEndpointMessageError().spCode).to(equal("sp_metric_invalid_response_privacy_manager_view_gdpr"))
                }
            }
            
            describe("InvalidResponseCCPAPrivacyManagerViewEndpointMessageError") {
                it("has spCode: sp_metric_invalid_response_privacy_manager_view_ccpa") {
                    expect(InvalidResponseCCPAPrivacyManagerViewEndpointMessageError().spCode).to(equal("sp_metric_invalid_response_privacy_manager_view_ccpa"))
                }
            }
        }
    }
}
