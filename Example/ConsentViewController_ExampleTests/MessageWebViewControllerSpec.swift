//
//  MessageWebViewControllerSpec.swift
//  ConsentViewController_ExampleTests
//
//  Created by Vilas on 3/16/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import WebKit
@testable import ConsentViewController

// swiftlint:disable function_body_length

class WebViewMock: WKWebView {
    var loadCalledWith: URLRequest!

    override func load(_ request: URLRequest) -> WKNavigation? {
        loadCalledWith = request
        return nil
    }
}

class MessageWebViewControllerSpec: QuickSpec, GDPRConsentDelegate, WKNavigationDelegate {
    override func spec() {
        var messageWebViewController: MessageWebViewController!
        var mockConsentDelegate: MockConsentDelegate!

        beforeEach {
            mockConsentDelegate = MockConsentDelegate()
            messageWebViewController = MessageWebViewController(propertyId: 1, pmId: "pmId", consentUUID: "uuid", timeout: 1)
            messageWebViewController.consentDelegate = mockConsentDelegate
        }

        describe("defaults") {
            describe("isSecondLayerMessage") {
                it("is set to false") {
                    expect(messageWebViewController.isSecondLayerMessage).to(beFalse())
                }
            }

            describe("consentUILoaded") {
                it("is set to false") {
                    expect(messageWebViewController.consentUILoaded).to(beFalse())
                }
            }

            describe("isPMLoaded") {
                it("is set to false") {
                    expect(messageWebViewController.isPMLoaded).to(beFalse())
                }
            }

            describe("connectivityManager") {
                it("is an instance of ConnectivityManager") {
                    expect(messageWebViewController.connectivityManager).to(beAnInstanceOf(ConnectivityManager.self))
                }
            }
        }

        describe("Test loadView method") {
            it("Test MessageWebViewController calls loadView method") {
                messageWebViewController.loadView()
                expect(messageWebViewController.webview).notTo(beNil(), description: "Webview initialized successfully")
            }
        }

        describe("GDPRConsentDelegate") {
            context("Test consentUIWillShow delegate method") {
                it("Test MessageWebViewController calls consentUIWillShow delegate method") {
                    messageWebViewController.gdprConsentUIWillShow()
                    expect(mockConsentDelegate.isConsentUIWillShowCalled).to(equal(false), description: "consentUIWillShow delegate method calls successfully")
                }
            }

            context("Test onMessageReady method") {
                it("Test MessageWebViewController calls messageWillShow delegate method") {
                    messageWebViewController.onMessageReady()
                    expect(mockConsentDelegate.isMessageWillShowCalled).to(equal(true), description: "messageWillShow delegate method calls successfully")
                }
            }

            context("Test gdprPMWillShow delegate method") {
                it("Test MessageWebViewController calls gdprPMWillShow delegate method") {
                    messageWebViewController.onPMReady()
                    expect(mockConsentDelegate.isGdprPMWillShowCalled).to(equal(true), description: "onPMReady delegate method calls successfully")
                }
            }

            context("Test consentUIDidDisappear delegate method") {
                it("Test MessageWebViewController calls consentUIDidDisappear delegate method") {
                    messageWebViewController.consentUIDidDisappear()
                    expect(mockConsentDelegate.isConsentUIDidDisappearCalled).to(equal(true), description: "consentUIDidDisappear delegate method calls successfully")
                }
            }

            context("Test onError delegate method") {
                it("Test MessageWebViewController calls onError delegate method") {
                    let error = GDPRConsentViewControllerError()
                    messageWebViewController.onError(error: error)
                    expect(mockConsentDelegate.isOnErrorCalled).to(equal(true), description: "onError delegate method calls successfully")
                }
            }

            context("Test messageDidDisappear delegate method") {
                it("Test MessageWebViewController calls messageDidDisappear delegate method") {
                    messageWebViewController.showPrivacyManagerFromMessageAction()
                    expect(mockConsentDelegate.isMessageDidDisappearCalled).to(equal(true), description: "messageDidDisappear delegate method calls successfully")
                }
            }

            context("Test gdprPMDidDisappear delegate method") {
                it("Test MessageWebViewController calls gdprPMDidDisappear delegate method") {
                    messageWebViewController.goBackAndClosePrivacyManager()
                    expect(mockConsentDelegate.isGdprPMDidDisappearCalled).to(equal(true), description: "gdprPMDidDisappear delegate method calls successfully")
                }
            }

            describe("onAction") {
                GDPRActionType.allCases.forEach { type in
                    it("calls the onAction on consent delegate for action of type \(type)") {
                        messageWebViewController.onAction(GDPRAction(type: type))
                        expect(mockConsentDelegate.isOnActionCalled).to(beTruthy())
                    }
                }

                context("for action type PMCancel") {
                    context("and the 2nd layer message is loaded") {
                        beforeEach {
                            messageWebViewController.isSecondLayerMessage = true
                            messageWebViewController.onAction(GDPRAction(type: .PMCancel))
                        }

                        it("calls the onAction with an action of type PMCancel") {
                            expect(mockConsentDelegate.onActionCalledWith.type).to(equal(.PMCancel))
                        }

                        it("sets the isSecondLayerMessage flag to false") {
                            expect(messageWebViewController.isSecondLayerMessage).to(beFalse())
                        }
                    }

                    context("and the 1st layer message is loaded") {
                        it("calls the onAction with an action of type Dismiss") {
                            messageWebViewController.isSecondLayerMessage = false
                            messageWebViewController.onAction(GDPRAction(type: .PMCancel))
                            expect(mockConsentDelegate.onActionCalledWith.type).to(equal(.Dismiss))
                        }
                    }
                }

                context("for action type ShowPrivacyManager") {
                    it("calls gdprMessageDidDisappear on the consent delegate") {
                        messageWebViewController.onAction(GDPRAction(type: .ShowPrivacyManager))
                        expect(mockConsentDelegate.isMessageDidDisappearCalled).to(beTruthy())
                    }

                    it("sets the isSecondLayerMessage flag to true") {
                        messageWebViewController.onAction(GDPRAction(type: .ShowPrivacyManager))
                        expect(messageWebViewController.isSecondLayerMessage).to(beTruthy())
                    }

                    context("and there's internet connection") {
                        it("loads the webview with the PM URL") {
                            let webviewMock = WebViewMock()
                            messageWebViewController.connectivityManager = ConnectivityMock(connected: true)
                            messageWebViewController.webview = webviewMock
                            messageWebViewController.onAction(GDPRAction(type: .ShowPrivacyManager))
                            expect(webviewMock.loadCalledWith.url).to(equal(messageWebViewController.pmUrl()))
                        }
                    }

                    context("and there's no internet connection") {
                        it("calls the onError callback") {
                            messageWebViewController.connectivityManager = ConnectivityMock(connected: false)
                            messageWebViewController.onAction(GDPRAction(type: .ShowPrivacyManager))
                            expect(mockConsentDelegate.isOnErrorCalled).to(beTruthy())
                        }
                    }
                }

                // all action types other than PMCancel and ShowPrivacyManager
                GDPRActionType
                    .allCases
                    .filter { !($0 == .PMCancel || $0 == .ShowPrivacyManager) }
                    .forEach { type in
                    context("when the action type is \(type)") {
                        context("and the consent UI is open") {
                            it("calls consentUIDidDisappear on the consent delegate") {
                                messageWebViewController.consentUILoaded = true
                                messageWebViewController.onAction(GDPRAction(type: type))
                                expect(mockConsentDelegate.isConsentUIDidDisappearCalled).to(beTruthy(), description: type.description)
                            }
                        }

                        context("and the consent UI is not open") {
                            it("calls consentUIDidDisappear on the consent delegate") {
                                messageWebViewController.consentUILoaded = false
                                messageWebViewController.onAction(GDPRAction(type: type))
                                expect(mockConsentDelegate.isConsentUIDidDisappearCalled).to(beFalse())
                            }
                        }

                        context("and the pm is loaded") {
                            beforeEach {
                                messageWebViewController.isPMLoaded = true
                                messageWebViewController.onAction(GDPRAction(type: type))
                            }

                            it("sets the isPMLoaded to false") {
                                expect(messageWebViewController.isPMLoaded).to(beFalse())
                            }

                            it("calls gdprPMDidDisappear on the consent delegate") {
                                expect(mockConsentDelegate.isGdprPMDidDisappearCalled).to(beTruthy())
                            }
                        }

                        context("and the pm is not loaded") {
                            it("calls gdprMessageDidDisappear on the consent delegate") {
                                messageWebViewController.isPMLoaded = false
                                messageWebViewController.onAction(GDPRAction(type: type))
                                expect(mockConsentDelegate.isMessageDidDisappearCalled).to(beTruthy())
                            }
                        }
                    }
                }
            }
        }

        describe("loadMessage") {
            context("when there's internet connection") {
                it("loads the webview with the url received as param") {
                    let webviewMock = WebViewMock()
                    messageWebViewController.connectivityManager = ConnectivityMock(connected: true)
                    messageWebViewController.webview = webviewMock
                    let url = URL(string: "www.example.com")!
                    messageWebViewController.loadMessage(fromUrl: url)
                    expect(webviewMock.loadCalledWith.url).to(equal(url))
                }
            }

            context("when there's no internet connection") {
                it("calls the onError callback") {
                    messageWebViewController.connectivityManager = ConnectivityMock(connected: false)
                    let url = URL(string: "www.example.com")!
                    messageWebViewController.loadMessage(fromUrl: url)
                    expect(mockConsentDelegate.isOnErrorCalled).to(beTruthy())
                }
            }
        }

        describe("loadPrivacyManager") {
            context("when there's internet connection") {
                it("loads the webview with the PM URL") {
                    let webviewMock = WebViewMock()
                    messageWebViewController.connectivityManager = ConnectivityMock(connected: true)
                    messageWebViewController.webview = webviewMock
                    messageWebViewController.loadPrivacyManager()
                    expect(webviewMock.loadCalledWith.url).to(equal(messageWebViewController.pmUrl()))
                }
            }

            context("when there's no internet connection") {
                it("calls the onError callback") {
                    messageWebViewController.connectivityManager = ConnectivityMock(connected: false)
                    messageWebViewController.loadPrivacyManager()
                    expect(mockConsentDelegate.isOnErrorCalled).to(beTruthy())
                }
            }
        }

        describe("pmURL") {
            it("returns an url with propertyId, pmId and consentUUID") {
                let pmUrl = URL(string: "https://notice.sp-prod.net/privacy-manager/index.html?message_id=pmId&site_id=1&consentUUID=uuid")
                expect(messageWebViewController.pmUrl()).to(equal(pmUrl))
            }
        }

        describe("Test viewWillDisappear methods") {
            it("Test MessageWebViewController calls viewWillDisappear method") {
                messageWebViewController.viewWillDisappear(false)
                expect(messageWebViewController.consentDelegate).to(beNil(), description: "ConsentDelegate gets cleared")
            }
        }
    }
}
