//
//  ConsentError.swift
//  GDPRConsentViewController
//
//  Created by Andre Herculano on 12.03.19.
//

import Foundation

@objcMembers public class GDPRConsentViewControllerError: NSError, LocalizedError {
    public var spCode: String { "generic_sdk_error" }
    public var spDescription: String { "Something went wrong in the SDK" }
    
    init() {
        super.init(domain: "GDPRConsentViewController", code: 0, userInfo: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@objcMembers public class GeneralRequestError: GDPRConsentViewControllerError {
    public let url, response, error: String

    public var failureReason: String? { return "The request to: \(url) failed with response: \(response) and error: \(error)" }
    public var errorDescription: String? { return "Error while requesting from: \(url)" }

    init(_ url: URL?, _ response: URLResponse?, _ error: Error?) {
        self.url = url?.absoluteString ?? "<Unknown Url>"
        self.response = response?.description ?? "<Unknown Response>"
        self.error = error?.localizedDescription ?? "<Unknown Error>"
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override public var description: String { return "\(failureReason!)" }
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

    override public var description: String { return "Error parsing response from \(endpoint): \(parsingError.debugDescription)" }
    public var errorDescription: String? { return description }
    public var failureReason: String? { return description }
}

@objcMembers public class UnableToLoadJSReceiver: GDPRConsentViewControllerError {
    public var failureReason: String? { return "Unable to load the JSReceiver.js resource." }
    override public var description: String { return "\(failureReason!)" }
}

@objcMembers public class MessageEventParsingError: GDPRConsentViewControllerError {
    let message: String

    init(message: String) {
        self.message = message
        super.init()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public var failureReason: String? { return "Could not parse message coming from the WebView \(message)" }
    override public var description: String { return "\(failureReason!)" }
}

@objcMembers public class WebViewError: GDPRConsentViewControllerError {
    let spCode: Int?
    let title, stackTrace: String?

    init(code: Int? = nil, title: String? = nil, stackTrace: String? = nil) {
        self.spCode = code
        self.title = title
        self.stackTrace = stackTrace
        super.init()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public var failureReason: String? { return "Something went wrong in the webview (code: \(spCode ?? 0), title: \(title ?? ""), stackTrace: \(stackTrace ?? ""))" }
    override public var description: String { return "\(failureReason!)" }
}

@objcMembers public class URLParsingError: GDPRConsentViewControllerError {
    let urlString: String

    init(urlString: String) {
        self.urlString = urlString
        super.init()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public var failureReason: String? { return "Could not parse URL: \(urlString)" }
    override public var description: String { return "\(failureReason!)" }
}

@objcMembers public class InvalidArgumentError: GDPRConsentViewControllerError {
    let message: String

    init(message: String) {
        self.message = message
        super.init()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    public var failureReason: String? { return message }
    override public var description: String { return message }
}

@objcMembers public class PostingConsentWithoutConsentUUID: GDPRConsentViewControllerError {
    public var failureReason: String? { return "Tried to post consent but the stored consentUUID is empty or nil. Make sure to call .loadMessage or .loadPrivacyManager first." }
    override public var description: String { return "\(failureReason!)" }
}

/// Network Errors
@objcMembers public class NoInternetConnection: GDPRConsentViewControllerError {
    override public var spDescription: String { "User has no Internet connection." }
    override public var spCode: String { "no_internet_connection" }
    
    public var failureReason: String? { "The device is not connected to the internet." }
    override public var description: String { "\(failureReason!)" }
}

@objcMembers public class MessageTimeout: GDPRConsentViewControllerError {
    override public var spDescription: String { description }
    override public var spCode: String { "connection_timeout" }
    
    let url: URL?
    let timeout: TimeInterval?
    
    init(url: URL?, timeout: TimeInterval?) {
        self.url = url
        self.timeout = timeout
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public var failureReason: String? { return description }
    override public var description: String { return "Timed out when loading \(String(describing: url?.absoluteString)) after \(String(describing: timeout)) seconds" }
}

@objcMembers public class InternalServerError: GDPRConsentViewControllerError {
    override public var spDescription: String { description }
    override public var spCode: String { "internal_server_error_\(request.httpMethod ?? "500")" }
    
    let request: URLRequest
    let response: HTTPURLResponse
    
    init(request: URLRequest, response: HTTPURLResponse) {
        self.request = request
        self.response = response
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public var failureReason: String? { return description }
    override public var description: String { return "The server responsed with \(response.statusCode) when performing \(request.httpMethod ?? "<no verb>") \(response.url?.absoluteString ?? "<no url>")" }
}
