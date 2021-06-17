import Foundation

@objcMembers public class SPError: NSError, LocalizedError {
    public var spCode: String { "sp_metric_generic_sdk_error" }
    public var spDescription: String { description }
    override public var description: String { "Something went wrong in the SDK" }
    public var failureReason: String { originalError.debugDescription }
    public var originalError: Error?
    public var campaignType: SPCampaignType = .unknown

    init() { super.init(domain: "SPConsentManager", code: 0, userInfo: nil) }
    convenience init(campaignType: SPCampaignType) {
        self.init()
        self.campaignType = campaignType
    }
    convenience init(error: Error) {
        self.init()
        originalError = error
    }
    convenience init(error: Error, campaignType: SPCampaignType) {
        self.init()
        originalError = error
        self.campaignType = campaignType
    }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

@objcMembers public class UnableToFindView: SPError {
    public override var spCode: String { "sp_metric_unable_to_find_view" }
    override public var description: String { "Unable to find view with id: (\(viewId))" }

    let viewId: String

    init(withId id: String) {
        viewId = id
        super.init()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

@objcMembers public class UnableToLoadJSReceiver: SPError {
    public override var spCode: String { "sp_metric_unable_to_load_jsreceiver" }
    override public var description: String { "Unable to load the JSReceiver.js resource." }
}

@objcMembers public class WebViewError: SPError {
    override public var spCode: String { "sp_metric_web_view_error" }
    override public var description: String {
        "Something went wrong in the webview (code: \(errorCode ?? 0), title: \(title ?? "")"
    }

    let errorCode: Int?
    let title: String?

    init(campaignType: SPCampaignType, code: Int? = nil, title: String? = nil, stackTrace: String? = nil) {
        self.errorCode = code
        self.title = title
        super.init()
        self.campaignType = campaignType
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

@objcMembers public class InvalidArgumentError: SPError {
    override public var description: String { message }
    let message: String

    init(message: String) {
        self.message = message
        super.init()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

/// Invalid Rendering App (JSReceiver) event payloads
@objcMembers public class InvalidEventPayloadError: SPError {
    public override var failureReason: String { description }
    public override var spCode: String { "sp_metric_invalid_event_payload" }
    public override var description: String {
        "Could not parse the event: \(name) with body: \(body)"
    }

    let name, body: String

    init(campaignType: SPCampaignType, _ name: String? = nil, body: String? = nil) {
        self.name = name ?? "<no name>"
        self.body = body ?? "<no body>"
        super.init()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

@objcMembers public class InvalidOnActionEventPayloadError: InvalidEventPayloadError {
    public override var spCode: String { "sp_metric_invalid_onAction_event_payload" }
}

@objcMembers public class InvalidURLError: SPError {
    override public var spCode: String { "sp_metric_invalid_url" }
    override public var description: String { "Could not parse URL: \(urlString)" }

    let urlString: String

    init(urlString: String) {
        self.urlString = urlString
        super.init()
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

@objcMembers public class RenderingAppError: SPError {
    public override var spCode: String { renderingAppErrorCode ?? "sp_metric_rendering_app_error" }
    public let renderingAppErrorCode: String?

    init(campaignType: SPCampaignType, _ renderingAppErrorCode: String?) {
        self.renderingAppErrorCode = renderingAppErrorCode
        super.init()
        self.campaignType = campaignType
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

@objcMembers public class UnableToInjectMessageIntoRenderingApp: SPError {
    public override var spCode: String { "sp_metric_unable_to_stringify_msgJSON" }
    override public var description: String { "The SDK could convert the message into JSON." }
}

/// Invalid API Response Errors
@objcMembers public class InvalidResponseWebMessageError: SPError {
    override public var spCode: String { "sp_metric_invalid_response_web_message" }
    override public var description: String { "The SDK got an unexpected response from /message endpoint" }
}

@objcMembers public class InvalidResponseNativeMessageError: SPError {
    override public var spCode: String { "sp_metric_invalid_response_native_message" }
    override public var description: String { "The SDK got an unexpected response from /native-message endpoint" }
}

@objcMembers public class InvalidResponseConsentError: SPError {
    override public var spCode: String { "sp_metric_invalid_response_consent" }
    override public var description: String { "The SDK got an unexpected response from /consent endpoint" }
}

@objcMembers public class InvalidResponseCustomError: SPError {
    override public var spCode: String { "sp_metric_invalid_response_custom_consent" }
    override public var description: String { "The SDK got an unexpected response from /custom-consent endpoint" }
}

/// Network Errors
@objcMembers public class NoInternetConnection: SPError {
    override public var spCode: String { "sp_metric_no_internet_connection" }
    override public var description: String { "The device is not connected to the internet." }
}

@objcMembers public class ConnectionTimeOutError: SPError {
    override public var spCode: String { "sp_metric_connection_timeout" }
    override public var description: String { "Timed out when loading \(String(describing: url?.absoluteString)) after \(String(describing: timeout)) seconds" }

    let url: URL?
    let timeout: TimeInterval?

    init(url: URL?, timeout: TimeInterval?, campaignType: SPCampaignType) {
        self.url = url
        self.timeout = timeout
        super.init()
        self.campaignType = campaignType
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

@objcMembers public class GenericNetworkError: SPError {
    override public var spCode: String { "sp_metric_generic_network_request_\(response?.statusCode ?? 999)" }
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
    override public var spCode: String { "sp_metric_internal_server_error_\(response?.statusCode ?? 500)" }
}

@objcMembers public class ResourceNotFoundError: GenericNetworkError {
    override public var spCode: String { "sp_metric_resource_not_found_\(response?.statusCode ?? 400)" }
}

/// Invalid Request Error
@objcMembers public class InvalidRequestError: SPError {
    override public var spCode: String { "sp_metric_invalid_request_error" }
}

@objcMembers public class PostingConsentWithoutConsentUUID: InvalidRequestError {
    override public var description: String {
        "Tried to post consent but the stored consentUUID is empty or nil. Make sure to call .loadMessage or .loadPrivacyManager first."
    }
    // swiftlint:disable:next unused_setter_value
    public override var campaignType: SPCampaignType { get { .gdpr } set {} }
}
