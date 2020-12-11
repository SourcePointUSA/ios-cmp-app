//
//  ConsentError.swift
//  GDPRConsentViewController
//
//  Created by Andre Herculano on 12.03.19.
//

import Foundation

@objcMembers public class GDPRConsentViewControllerError: NSError, LocalizedError {
    public var spCode: String { "generic_sdk_error" }
    public var spDescription: String { description }
    override public var description: String { "Something went wrong in the SDK" }
    public var failureReason: String? { description }

    init() { super.init(domain: "GDPRConsentViewController", code: 0, userInfo: nil) }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
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

    override public var description: String { "Error parsing response from \(endpoint): \(parsingError.debugDescription)" }
}

@objcMembers public class UnableToLoadJSReceiver: GDPRConsentViewControllerError {
    override public var description: String { "Unable to load the JSReceiver.js resource." }
}

@objcMembers public class MessageEventParsingError: GDPRConsentViewControllerError {
    let message: String

    init(message: String) {
        self.message = message
        super.init()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override public var description: String { "Could not parse message coming from the WebView \(message)" }
}

@objcMembers public class WebViewError: GDPRConsentViewControllerError {
    override public var spCode: String { "web_view_error" }
    override public var description: String {
        "Something went wrong in the webview (code: \(errorCode ?? 0), title: \(title ?? "")"
    }

    let errorCode: Int?
    let title: String?

    init(code: Int? = nil, title: String? = nil, stackTrace: String? = nil) {
        self.errorCode = code
        self.title = title
        super.init()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

@objcMembers public class InvalidArgumentError: GDPRConsentViewControllerError {
    override public var description: String { message }
    let message: String

    init(message: String) {
        self.message = message
        super.init()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

@objcMembers public class PostingConsentWithoutConsentUUID: GDPRConsentViewControllerError {
    override public var description: String {
        "Tried to post consent but the stored consentUUID is empty or nil. Make sure to call .loadMessage or .loadPrivacyManager first."
    }
}

@objcMembers public class InvalidURLError: GDPRConsentViewControllerError {
    override public var spCode: String { "invalid_url" }
    override public var description: String { "Could not parse URL: \(urlString)" }

    let urlString: String

    init(urlString: String) {
        self.urlString = urlString
        super.init()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

/// Invalid API Response Errors
@objcMembers public class InvalidResponseError: GDPRConsentViewControllerError {
    public override var failureReason: String? { decodingError?.failureReason ?? description }

    let decodingError: DecodingError?

    init(_ error: DecodingError? = nil) {
        decodingError = error
        super.init()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

@objcMembers public class InvalidResponseWebMessageError: InvalidResponseError {
    override public var spCode: String { "invalid_response_web_message" }
    override public var description: String { "The SDK got an unexpected response from /message-url endpoint" }
}

@objcMembers public class InvalidResponseNativeMessageError: InvalidResponseError {
    override public var spCode: String { "invalid_response_native_message" }
    override public var description: String { "The SDK got an unexpected response from /native-message endpoint" }
}

@objcMembers public class InvalidResponseConsentError: InvalidResponseError {
    override public var spCode: String { "invalid_response_consent" }
    override public var description: String { "The SDK got an unexpected response from /consent endpoint" }
}

@objcMembers public class InvalidResponseCustomError: InvalidResponseError {
    override public var spCode: String { "invalid_response_custom_consent" }
    override public var description: String { "The SDK got an unexpected response from /custom-consent endpoint" }
}

/// Network Errors
@objcMembers public class NoInternetConnection: GDPRConsentViewControllerError {
    override public var spCode: String { "no_internet_connection" }
    override public var description: String { "The device is not connected to the internet." }
}

@objcMembers public class ConnectionTimeOutError: GDPRConsentViewControllerError {
    override public var spCode: String { "connection_timeout" }
    override public var description: String { "Timed out when loading \(String(describing: url?.absoluteString)) after \(String(describing: timeout)) seconds" }

    let url: URL?
    let timeout: TimeInterval?

    init(url: URL?, timeout: TimeInterval?) {
        self.url = url
        self.timeout = timeout
        super.init()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

@objcMembers public class GenericNetworkError: GDPRConsentViewControllerError {
    override public var spCode: String { "generic_network_request_\(response?.statusCode ?? 999)" }
    override public var description: String {
        "The server responsed with \(response?.statusCode ?? 999) when performing \(request.httpMethod ?? "<no verb>") \(response?.url?.absoluteString ?? "<no url>")"
    }

    let request: URLRequest
    let response: HTTPURLResponse?

    init(request: URLRequest, response: HTTPURLResponse?) {
        self.request = request
        self.response = response
        super.init()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

@objcMembers public class InternalServerError: GenericNetworkError {
    override public var spCode: String { "internal_server_error_\(response?.statusCode ?? 500)" }
}

@objcMembers public class ResourceNotFoundError: GenericNetworkError {
    override public var spCode: String { "resource_not_found_\(response?.statusCode ?? 400)" }
}
