//
//  SPErrorSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Vilas on 19/03/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

@testable import ConsentViewController
import Nimble
import Quick

func emptyRequest() -> URLRequest {
    URLRequest(url: URL(string: "/")!) // swiftlint:disable:this force_unwrapping
}

func aResponseWith(status: Int) -> HTTPURLResponse {
    HTTPURLResponse(url: URL(string: "/")!, statusCode: status, httpVersion: nil, headerFields: nil)! // swiftlint:disable:this force_unwrapping
}

// swiftlint:disable function_body_length

class SPErrorSpec: QuickSpec {
    override func spec() {
        describe("SPErrorSpec") {
            describe("NoInternetConnection") {
                it("has spCode: no_internet_connection") {
                    expect(NoInternetConnection().spCode) == "sp_metric_no_internet_connection"
                }
            }

            describe("ConnectionTimeOutError") {
                it("has spCode: connection_timeout") {
                    expect(WebViewConnectionTimeOutError(url: nil, timeout: nil, campaignType: .unknown).spCode) == "sp_metric_webview_connection_timeout"
                }
            }

            describe("InvalidURLError") {
                it("has spCode: invalid_url") {
                    expect(InvalidURLError(urlString: "").spCode) == "sp_metric_invalid_url"
                }
            }

            describe("WebViewError") {
                it("has spCode: web_view_error") {
                    expect(WebViewError(campaignType: .gdpr).spCode) == "sp_metric_web_view_error"
                }
            }

            describe("InvalidResponseCustomError") {
                it("has spCode: invalid_response_custom_consent") {
                    expect(InvalidResponseCustomError().spCode) == "sp_metric_invalid_response_custom_consent"
                }
            }

            describe("InvalidEventPayloadError") {
                it("has spCode: invalid_event_payload") {
                    expect(InvalidEventPayloadError(campaignType: .gdpr).spCode) == "sp_metric_invalid_event_payload"
                }
            }

            describe("InvalidOnActionEventPayloadError") {
                it("has spCode: invalid_event_payload") {
                    expect(InvalidOnActionEventPayloadError(campaignType: .gdpr).spCode) == "sp_metric_invalid_onAction_event_payload"
                }
            }

            describe("RenderingAppError") {
                describe("if not code is provided") {
                    it("its spCode should be rendering_app_error") {
                        expect(RenderingAppError(campaignType: .gdpr, nil).spCode) == "sp_metric_rendering_app_error"
                    }
                }

                describe("if a code is provided") {
                    it("its spCode should be the same as the code provided") {
                        expect(RenderingAppError(campaignType: .gdpr, "foo").spCode) == "foo"
                    }
                }
            }

            describe("sp_metric_invalid_consent_UUID") {
                it("has spCode: invalid_request_error") {
                    expect(PostingCustomConsentWithoutConsentUUID().spCode) == "sp_metric_invalid_consent_UUID"
                }
            }

            describe("UnableToLoadJSReceiver") {
                it("has spCode: unable_to_load_jsreceiver") {
                    expect(UnableToLoadJSReceiver().spCode) == "sp_metric_unable_to_load_jsreceiver"
                }
            }

            it("Test InvalidPropertyNameError method") {
                let errorObject = InvalidPropertyNameError(message: "The operation couldn't be completed")
                expect(errorObject.description) == "The operation couldn't be completed"
            }

            describe("InvalidResponseGetMessagesEndpointError") {
                it("has spCode: sp_metric_invalid_response_get_messages") {
                    expect(InvalidResponseGetMessagesEndpointError().spCode) == "sp_metric_invalid_response_api_messages"
                }
            }

            describe("InvalidResponseMessageGDPREndpointError") {
                it("has spCode: sp_metric_invalid_response_message_gdpr") {
                    expect(InvalidResponseMessageGDPREndpointError().spCode) == "sp_metric_invalid_response_message_gdpr"
                }
            }

            describe("InvalidResponseMessageCCPAEndpointError") {
                it("has spCode: sp_metric_invalid_response_message_ccpa") {
                    expect(InvalidResponseMessageCCPAEndpointError().spCode) == "sp_metric_invalid_response_message_ccpa"
                }
            }

            describe("InvalidResponseGDPRPMViewEndpointError") {
                it("has spCode: sp_metric_invalid_response_privacy_manager_view_gdpr") {
                    expect(InvalidResponseGDPRPMViewEndpointError().spCode) == "sp_metric_invalid_response_privacy_manager_view_gdpr"
                }
            }

            describe("InvalidResponseCCPAPMViewEndpointError") {
                it("has spCode: sp_metric_invalid_response_privacy_manager_view_ccpa") {
                    expect(InvalidResponseCCPAPMViewEndpointError().spCode) == "sp_metric_invalid_response_privacy_manager_view_ccpa"
                }
            }

            describe("MissingChildPmIdError") {
                it("has spCode: sp_log_child_pm_id_custom_metrics") {
                    expect(MissingChildPmIdError(usedId: "ololo").spCode) == "sp_log_child_pm_id_custom_metrics"
                }
            }
        }
    }
}
