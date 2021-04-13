////
//  MessageWebViewControllerSpec.swift
//  ConsentViewController_ExampleTests
////
//  Created by Vilas on 3/16/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
////
//
//import Quick
//import Nimble
//import WebKit
//@testable import ConsentViewController
//
//
//class MessageWebViewControllerSpec: QuickSpec, GDPRConsentDelegate, WKNavigationDelegate {
//    override func spec() {
//        var messageWebViewController: MessageWebViewController!
//        var mockConsentDelegate: MockConsentDelegate!
//        let userContentController = WKUserContentController()
//        let consentLanguage = "EN"
//
//        beforeEach {
//            mockConsentDelegate = MockConsentDelegate()
//            messageWebViewController = MessageWebViewController(propertyId: 1, pmId: "1234", consentUUID: "uuid", messageLanguage: .English, pmTab: .Purposes, timeout: 1)
//            messageWebViewController.consentDelegate = mockConsentDelegate
//        }
//
//        describe("defaults") {
//            describe("isSecondLayerMessage") {
//                it("is set to false") {
//                    expect(messageWebViewController.isSecondLayerMessage).to(beFalse())
//                }
//            }
//
//            describe("consentUILoaded") {
//                it("is set to false") {
//                    expect(messageWebViewController.consentUILoaded).to(beFalse())
//                }
//            }
//
//            describe("isPMLoaded") {
//                it("is set to false") {
//                    expect(messageWebViewController.isPMLoaded).to(beFalse())
//                }
//            }
//
//            describe("connectivityManager") {
//                it("is an instance of ConnectivityManager") {
//                    expect(messageWebViewController.connectivityManager).to(beAnInstanceOf(ConnectivityManager.self))
//                }
//            }
//        }
//
//        // responsible for the interface between javascript and native code
//        describe("userContentController") {
//            context("when it receives a 'onMessageReady' message") {
//                it("calls the onConsenUIWillShow on the consent delegate") {
//                    let message = MessageMock(["name": "onMessageReady"])
//                    messageWebViewController.userContentController(userContentController, didReceive: message)
//                    expect(mockConsentDelegate.isConsentUIWillShowCalled).to(beTrue())
//                }
//
//                it("calls the onMessageWillShow on the consent delegate") {
//                    let message = MessageMock(["name": "onMessageReady"])
//                    messageWebViewController.userContentController(userContentController, didReceive: message)
//                    expect(mockConsentDelegate.isMessageWillShowCalled).to(beTrue())
//                }
//            }
//
//            context("when it receives a 'onPMReady' message") {
//                it("calls the onConsenUIWillShow on the consent delegate") {
//                    let message = MessageMock(["name": "onPMReady"])
//                    messageWebViewController.userContentController(userContentController, didReceive: message)
//                    expect(mockConsentDelegate.isConsentUIWillShowCalled).to(beTrue())
//                }
//
//                it("calls the onMessageWillShow on the consent delegate") {
//                    let message = MessageMock(["name": "onPMReady"])
//                    messageWebViewController.userContentController(userContentController, didReceive: message)
//                    expect(mockConsentDelegate.isGdprPMWillShowCalled).to(beTrue())
//                }
//            }
//
//            context("when it receives a 'onAction' message") {
//                [1, 11, 12, 13, 15].forEach { type in
//                    context("and the action type is \(type)") {
//                        let actionType = SPActionType(rawValue: type)!
//                        it("calls the onAction on the consent delegate with \(actionType)") {
//                            let message = MessageMock([
//                                "name": "onAction",
//                                "body": ["type": type, "id": "id", "payload": ["foo": "bar"], "consentLanguage": "EN"]
//                            ])
//                            let expectedAction = SPAction(type: actionType, id: "id", consentLanguage: consentLanguage, payload: "{\"foo\":\"bar\"}".data(using: .utf8)!)
//                            messageWebViewController.userContentController(userContentController, didReceive: message)
//                            expect(mockConsentDelegate.onActionCalledWith).to(equal(expectedAction))
//                        }
//                    }
//                }
//
//                context("and the action type is 2") {
//                    it("calls the onAction on the consent delegate with Dismiss") {
//                        let message = MessageMock([
//                            "name": "onAction",
//                            "body": ["type": 2, "id": "id", "payload": [:], "consentLanguage": "EN"]
//                        ])
//                        let expectedAction = SPAction(type: .Dismiss, id: "id", consentLanguage: consentLanguage, payload: "{}".data(using: .utf8)!)
//                        messageWebViewController.userContentController(userContentController, didReceive: message)
//                        expect(mockConsentDelegate.onActionCalledWith).to(equal(expectedAction))
//                    }
//                }
//
//                context("the action type is 12") {
//                    context("and the pm_url attribute is valid") {
//                        it("uses message_id from pm_url which is associated with message") {
//                            let webviewMock = WebViewMock()
//                            messageWebViewController.connectivityManager = ConnectivityMock(connected: true)
//                            messageWebViewController.webview = webviewMock
//                            let message = MessageMock([
//                                "name": "onAction",
//                                "body": [
//                                    "type": 12,
//                                    "id": "id",
//                                    "payload": ["pm_url": "https://notice.sp-prod.net/privacy-manager/index.html?message_id=122058"],
//                                    "consentLanguage": "EN"
//                                ]])
//                            messageWebViewController.userContentController(userContentController, didReceive: message)
//                            expect(messageWebViewController.pmId).to(equal("122058"))
//                        }
//                    }
//
//                    context("and the pm_url attribute is invalid") {
//                        it("uses its own pmId as message_id") {
//                            let webviewMock = WebViewMock()
//                            messageWebViewController.connectivityManager = ConnectivityMock(connected: true)
//                            messageWebViewController.webview = webviewMock
//                            let message = MessageMock([
//                                "name": "onAction",
//                                "body": ["type": 12, "id": "id", "payload": ["pm_url": "pm_url"], "consentLanguage": "EN"]
//                            ])
//                            messageWebViewController.userContentController(userContentController, didReceive: message)
//                            expect(messageWebViewController.pmId).to(equal("1234"))
//                        }
//                    }
//                }
//            }
//
//            context("when it receives a 'onError' message") {
//                it("calls the onError on the consent delegate") {
//                    let message = MessageMock(["name": "onError", "body": ["error": "foo"]])
//                    messageWebViewController.userContentController(userContentController, didReceive: message)
//                    expect(mockConsentDelegate.isOnErrorCalled).to(beTrue())
//                }
//            }
//        }
//
//        describe("Test loadView method") {
//            it("Test MessageWebViewController calls loadView method") {
//                messageWebViewController.loadView()
//                expect(messageWebViewController.webview).notTo(beNil(), description: "Webview initialized successfully")
//            }
//        }
//
//        describe("GDPRConsentDelegate") {
//            describe("consentUIWillShow") {
//                it("calls consentUIWillShow delegate method") {
//                    messageWebViewController.gdprConsentUIWillShow()
//                    expect(mockConsentDelegate.isConsentUIWillShowCalled).to(beTrue())
//                }
//            }
//
//            context("Test onMessageReady method") {
//                it("Test MessageWebViewController calls messageWillShow delegate method") {
//                    messageWebViewController.onMessageReady()
//                    expect(mockConsentDelegate.isMessageWillShowCalled).to(equal(true), description: "messageWillShow delegate method calls successfully")
//                }
//            }
//
//            context("Test gdprPMWillShow delegate method") {
//                it("Test MessageWebViewController calls gdprPMWillShow delegate method") {
//                    messageWebViewController.onPMReady()
//                    expect(mockConsentDelegate.isGdprPMWillShowCalled).to(equal(true), description: "onPMReady delegate method calls successfully")
//                }
//            }
//
//            context("Test consentUIDidDisappear delegate method") {
//                it("Test MessageWebViewController calls consentUIDidDisappear delegate method") {
//                    messageWebViewController.consentUIDidDisappear()
//                    expect(mockConsentDelegate.isConsentUIDidDisappearCalled).to(equal(true), description: "consentUIDidDisappear delegate method calls successfully")
//                }
//            }
//
//            context("Test onError delegate method") {
//                it("Test MessageWebViewController calls onError delegate method") {
//                    let error = SPError()
//                    messageWebViewController.onError(error: error)
//                    expect(mockConsentDelegate.isOnErrorCalled).to(equal(true), description: "onError delegate method calls successfully")
//                }
//            }
//
//            context("Test messageDidDisappear delegate method") {
//                it("Test MessageWebViewController calls messageDidDisappear delegate method") {
//                    messageWebViewController.showPrivacyManagerFromMessageAction()
//                    expect(mockConsentDelegate.isMessageDidDisappearCalled).to(equal(true), description: "messageDidDisappear delegate method calls successfully")
//                }
//            }
//
//            context("Test gdprPMDidDisappear delegate method") {
//                it("Test MessageWebViewController calls gdprPMDidDisappear delegate method") {
//                    messageWebViewController.goBackAndClosePrivacyManager()
//                    expect(mockConsentDelegate.isGdprPMDidDisappearCalled).to(equal(true), description: "gdprPMDidDisappear delegate method calls successfully")
//                }
//            }
//        }
//
//            describe("onAction") {
//                SPActionType.allCases.forEach { type in
//                    it("calls the onAction on consent delegate for action of type \(type)") {
//                        messageWebViewController.onAction(SPAction(type: type))
//                        expect(mockConsentDelegate.isOnActionCalled).to(beTruthy())
//                    }
//                }
//
//                context("for action type PMCancel") {
//                    context("and the 2nd layer message is loaded") {
//                        beforeEach {
//                            messageWebViewController.isSecondLayerMessage = true
//                            messageWebViewController.onAction(SPAction(type: .PMCancel))
//                        }
//
//                        it("calls the onAction with an action of type PMCancel") {
//                            expect(mockConsentDelegate.onActionCalledWith.type).to(equal(.PMCancel))
//                        }
//
//                        it("sets the isSecondLayerMessage flag to false") {
//                            expect(messageWebViewController.isSecondLayerMessage).to(beFalse())
//                        }
//                    }
//
//                    context("and the 1st layer message is loaded") {
//                        it("calls the onAction with an action of type Dismiss") {
//                            messageWebViewController.isSecondLayerMessage = false
//                            messageWebViewController.onAction(SPAction(type: .PMCancel))
//                            expect(mockConsentDelegate.onActionCalledWith.type).to(equal(.Dismiss))
//                        }
//                    }
//                }
//
//                context("for action type ShowPrivacyManager") {
//                    it("calls gdprMessageDidDisappear on the consent delegate") {
//                        messageWebViewController.onAction(SPAction(type: .ShowPrivacyManager))
//                        expect(mockConsentDelegate.isMessageDidDisappearCalled).to(beTruthy())
//                    }
//
//                    it("sets the isSecondLayerMessage flag to true") {
//                        messageWebViewController.onAction(SPAction(type: .ShowPrivacyManager))
//                        expect(messageWebViewController.isSecondLayerMessage).to(beTruthy())
//                    }
//
//                    context("and there's internet connection") {
//                        it("loads the webview with the PM URL") {
//                            let webviewMock = WebViewMock()
//                            messageWebViewController.connectivityManager = ConnectivityMock(connected: true)
//                            messageWebViewController.webview = webviewMock
//                            messageWebViewController.onAction(SPAction(type: .ShowPrivacyManager))
//                            let expectedPMURL = "https://cdn.privacy-mgmt.com/privacy-manager/index.html?site_id=1&consentUUID=uuid&message_id=1234&pmTab=purposes"
//                            expect(webviewMock.loadCalledWith.url?.absoluteString).to(equal(expectedPMURL))
//                        }
//                    }
//
//                    context("and there's no internet connection") {
//                        it("calls the onError callback") {
//                            messageWebViewController.connectivityManager = ConnectivityMock(connected: false)
//                            messageWebViewController.onAction(SPAction(type: .ShowPrivacyManager))
//                            expect(mockConsentDelegate.isOnErrorCalled).to(beTruthy())
//                        }
//                    }
//                }
//
//                // all action types other than PMCancel and ShowPrivacyManager
//                SPActionType
//                    .allCases
//                    .filter { !($0 == .PMCancel || $0 == .ShowPrivacyManager) }
//                    .forEach { type in
//                    context("when the action type is \(type)") {
//                        context("and the consent UI is open") {
//                            it("calls consentUIDidDisappear on the consent delegate") {
//                                messageWebViewController.consentUILoaded = true
//                                messageWebViewController.onAction(SPAction(type: type))
//                                expect(mockConsentDelegate.isConsentUIDidDisappearCalled).to(beTruthy(), description: type.description)
//                            }
//                        }
//
//                        context("and the consent UI is not open") {
//                            it("calls consentUIDidDisappear on the consent delegate") {
//                                messageWebViewController.consentUILoaded = false
//                                messageWebViewController.onAction(SPAction(type: type))
//                                expect(mockConsentDelegate.isConsentUIDidDisappearCalled).to(beFalse())
//                            }
//                        }
//
//                        context("and the pm is loaded") {
//                            beforeEach {
//                                messageWebViewController.isPMLoaded = true
//                                messageWebViewController.onAction(SPAction(type: type))
//                            }
//
//                            it("sets the isPMLoaded to false") {
//                                expect(messageWebViewController.isPMLoaded).to(beFalse())
//                            }
//
//                            it("calls gdprPMDidDisappear on the consent delegate") {
//                                expect(mockConsentDelegate.isGdprPMDidDisappearCalled).to(beTruthy())
//                            }
//                        }
//
//                        context("and the pm is not loaded") {
//                            it("calls gdprMessageDidDisappear on the consent delegate") {
//                                messageWebViewController.isPMLoaded = false
//                                messageWebViewController.onAction(SPAction(type: type))
//                                expect(mockConsentDelegate.isMessageDidDisappearCalled).to(beTruthy())
//                            }
//                        }
//                    }
//                }
//            }
//
//        describe("loadMessage") {
//            context("when there's internet connection") {
//                it("loads the webview with the url received as param") {
//                    let webviewMock = WebViewMock()
//                    messageWebViewController.connectivityManager = ConnectivityMock(connected: true)
//                    messageWebViewController.webview = webviewMock
//                    let url = URL(string: "www.example.com")!
//                    messageWebViewController.loadMessage(fromUrl: url)
//                    let expectedURL = URL(string: "\(url.absoluteString)?consentLanguage=EN&consentUUID=uuid")
//                    expect(webviewMock.loadCalledWith.url).to(equal(expectedURL))
//                }
//            }
//
//            context("when there's no internet connection") {
//                it("calls the onError callback") {
//                    messageWebViewController.connectivityManager = ConnectivityMock(connected: false)
//                    let url = URL(string: "www.example.com")!
//                    messageWebViewController.loadMessage(fromUrl: url)
//                    expect(mockConsentDelegate.isOnErrorCalled).to(beTruthy())
//                }
//            }
//
//            context("when there's internet connect but load of message fails with bad server response") {
//                it("call the onError callback") {
//                    let webView = WKWebView()
//                    messageWebViewController.connectivityManager = ConnectivityMock(connected: true)
//                    messageWebViewController.webview = webView
//                    let navigation = webView.load(URLRequest(url: URL(string: "www.example.com")!))
//
//                    let error = URLError(.badServerResponse)
//                    messageWebViewController.webView(webView, didFailProvisionalNavigation: navigation, withError: error)
//
//                    expect(mockConsentDelegate.isOnErrorCalled).to(beTruthy())
//                }
//            }
//        }
//
//        describe("loadPrivacyManager") {
//            context("when there's internet connection") {
//                it("loads the webview with the PM URL") {
//                    let webviewMock = WebViewMock()
//                    messageWebViewController.connectivityManager = ConnectivityMock(connected: true)
//                    messageWebViewController.webview = webviewMock
//                    messageWebViewController.loadPrivacyManager()
//                    let expectedPMURL = "https://cdn.privacy-mgmt.com/privacy-manager/index.html?site_id=1&consentUUID=uuid&message_id=1234&pmTab=purposes"
//                    expect(webviewMock.loadCalledWith.url?.absoluteString).to(equal(expectedPMURL))
//                }
//            }
//
//            context("when there's no internet connection") {
//                it("calls the onError callback") {
//                    messageWebViewController.connectivityManager = ConnectivityMock(connected: false)
//                    messageWebViewController.loadPrivacyManager()
//                    expect(mockConsentDelegate.isOnErrorCalled).to(beTruthy())
//                }
//            }
//        }
//
//        describe("pmURL") {
//            it("returns an url with propertyId, consentUUID and messageId") {
//                let pmUrl = URL(string: "https://cdn.privacy-mgmt.com/privacy-manager/index.html?site_id=1&consentUUID=uuid&message_id=1234&pmTab=purposes")
//                expect(messageWebViewController.pmUrl()).to(equal(pmUrl))
//            }
//        }
//
//        describe("Test viewWillDisappear methods") {
//            it("Test MessageWebViewController calls viewWillDisappear method") {
//                messageWebViewController.viewWillDisappear(false)
//                expect(messageWebViewController.consentDelegate).to(beNil(), description: "ConsentDelegate gets cleared")
//            }
//        }
//    }
//}
