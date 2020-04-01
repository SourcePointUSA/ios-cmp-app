//
//  ConsentError.swift
//  GDPRConsentViewController
//
//  Created by Andre Herculano on 12.03.19.
//

import Foundation

@objcMembers public class GDPRConsentViewControllerError: NSError, LocalizedError {
    init() {
        super.init(domain: "GDPRConsentViewController", code: 0, userInfo: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@objcMembers public class GeneralRequestError: GDPRConsentViewControllerError {
    public let url, response, error: String

    public var failureReason: String? { get { return "The request to: \(url) failed with response: \(response) and error: \(error)" } }
    public var errorDescription: String? { get { return "Error while requesting from: \(url)" } }

    init(_ url: URL?, _ response: URLResponse?, _ error: Error?) {
        self.url = url?.absoluteString ?? "<Unknown Url>"
        self.response = response?.description ?? "<Unknown Response>"
        self.error = error?.localizedDescription ?? "<Unknown Error>"
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override public var description: String { get { return "\(failureReason!)" } }
}

@objcMembers public class APIParsingError: GDPRConsentViewControllerError {
    private let parsingError: Error?
    private let endpoint: String

    init(_ endpoint: String, _ error: Error?) {
        self.endpoint = endpoint
        self.parsingError = error
        super.init()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override public var description: String { get { return "Error parsing response from \(endpoint): \(parsingError.debugDescription)" } }
    public var errorDescription: String? { get { return description } }
    public var failureReason: String? { get { return description } }
}

@objcMembers public class NoInternetConnection: GDPRConsentViewControllerError {
    public var failureReason: String? { get { return "The device is not connected to the internet." } }
    override public var description: String { get { return "\(failureReason!)\n" } }
}

@objcMembers public class MessageEventParsingError: GDPRConsentViewControllerError {
    let message: String

    init(message: String) {
        self.message = message
        super.init()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public var failureReason: String? { get { return "Could not parse message coming from the WebView \(message)" } }
    override public var description: String { get { return "\(failureReason!)\n" } }
}

@objcMembers public class WebViewError: GDPRConsentViewControllerError {
    public var failureReason: String? { get { return "Something went wrong in the webview" } }
    override public var description: String { get { return "\(failureReason!)\n" } }
}

@objcMembers public class URLParsingError: GDPRConsentViewControllerError {
    let urlString: String

    init(urlString: String) {
        self.urlString = urlString
        super.init()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public var failureReason: String? { get { return "Could not parse URL: \(urlString)" } }
    override public var description: String { get { return "\(failureReason!)\n" } }
}

@objcMembers public class InvalidArgumentError: GDPRConsentViewControllerError {
    let message: String

    init(message: String) {
        self.message = message
        super.init()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public var failureReason: String? { get { return message } }
    override public var description: String { get { return message } }
}
