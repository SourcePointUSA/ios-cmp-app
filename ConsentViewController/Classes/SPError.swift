import Foundation
// swiftlint:disable line_length
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

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

@objcMembers public class UnableToFindView: SPError {
    override public var spCode: String { "sp_metric_unable_to_find_view" }
    override public var description: String { "Unable to find view with id: (\(viewId))" }

    let viewId: String

    init(withId id: String) {
        viewId = id
        super.init()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

@objcMembers public class UnableToLoadJSReceiver: SPError {
    override public var spCode: String { "sp_metric_unable_to_load_jsreceiver" }
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

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

@objcMembers public class InvalidPropertyNameError: SPError {
    override public var spCode: String { "sp_metric_invalid_property_name" }
    override public var description: String { message }
    let message: String

    init(message: String) {
        self.message = message
        super.init()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

@objcMembers public class MissingChildPmIdError: SPError {
    override public var spCode: String { "sp_log_child_pm_id_custom_metrics" }
    override public var description: String { "SDK was called loadPrivacyManager for \(campaignType) campaign with useGroupPmIfAvailable = true. ID \(usedId) was used. CHILD PM ID is missing!!!" }
    let usedId: String

    init(usedId: String) {
        self.usedId = usedId
        super.init()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

/// Invalid Rendering App (JSReceiver) event payloads
@objcMembers public class InvalidEventPayloadError: SPError {
    override public var failureReason: String { description }
    override public var spCode: String { "sp_metric_invalid_event_payload" }
    override public var description: String {
        "Could not parse the event: \(name) with body: \(body)"
    }

    let name, body: String

    init(campaignType: SPCampaignType, _ name: String? = nil, body: String? = nil) {
        self.name = name ?? "<no name>"
        self.body = body ?? "<no body>"
        super.init()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

@objcMembers public class InvalidOnActionEventPayloadError: InvalidEventPayloadError {
    override public var spCode: String { "sp_metric_invalid_onAction_event_payload" }
}

@objcMembers public class InvalidURLError: SPError {
    override public var spCode: String { "sp_metric_invalid_url" }
    override public var description: String { "Could not parse URL: \(urlString)" }

    let urlString: String

    init(urlString: String) {
        self.urlString = urlString
        super.init()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

@objcMembers public class RenderingAppError: SPError {
    override public var spCode: String { renderingAppErrorCode ?? "sp_metric_rendering_app_error" }
    public let renderingAppErrorCode: String?

    init(campaignType: SPCampaignType, _ renderingAppErrorCode: String?) {
        self.renderingAppErrorCode = renderingAppErrorCode
        super.init()
        self.campaignType = campaignType
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

@objcMembers public class RenderingAppTimeoutError: SPError {
    override public var spCode: String { "sp_metric_rendering_app_timeout" }
    override public var description: String { "Something went wrong while loading the Rendering App. onMessageReady was not called within the specified timeout." }
}

@objcMembers public class UnableToInjectMessageIntoRenderingApp: SPError {
    override public var spCode: String { "sp_metric_unable_to_stringify_msgJSON" }
    override public var description: String { "The SDK could convert the message into JSON." }
}

/// Invalid API Response Errors
@objcMembers public class InvalidResponseWebMessageError: SPError {
    override public var spCode: String { "sp_metric_invalid_response_web_message" }
    override public var description: String { "The SDK got an unexpected response from /message endpoint" }
}

@objcMembers public class InvalidResponseGetMessagesEndpointError: SPError {
    override public var spCode: String { InvalidResponsAPICode.MESSAGES.code }
    override public var description: String { "The SDK got an unexpected response from /get_messages endpoint" }
}

@objcMembers public class InvalidGetMessagesParams: SPError {
    override public var spCode: String { "sp_invalid_get_messages_param" }
    override public var description: String { "The request params to /messages are invalid" }
}

@objcMembers public class InvalidResponseMessageGDPREndpointError: SPError {
    override public var spCode: String { "sp_metric_invalid_response_message_gdpr" }
    override public var description: String { "The SDK got an unexpected response from /message/gdpr endpoint" }
}

@objcMembers public class InvalidResponseMessageCCPAEndpointError: SPError {
    override public var spCode: String { "sp_metric_invalid_response_message_ccpa" }
    override public var description: String { "The SDK got an unexpected response from /message/ccpa endpoint" }
}

@objcMembers public class InvalidResponseGDPRPMViewEndpointError: SPError {
    override public var spCode: String { "sp_metric_invalid_response_privacy_manager_view_gdpr" }
    override public var description: String { "The SDK got an unexpected response from /consent/tcfv2/privacy-manager/privacy-manager-view endpoint" }
}

@objcMembers public class InvalidResponseCCPAPMViewEndpointError: SPError {
    override public var spCode: String { "sp_metric_invalid_response_privacy_manager_view_ccpa" }
    override public var description: String { "The SDK got an unexpected response from /ccpa/privacy-manager/privacy-manager-view endpoint" }
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

@objcMembers public class InvalidResponseDeleteCustomError: SPError {
    override public var spCode: String { "sp_metric_invalid_response_delete_custom_consent" }
    override public var description: String { "The SDK got an unexpected response from /consent/tcfv2/consent/v3/custom/ endpoint" }
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

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

@objcMembers public class GenericNetworkError: SPError {
    override public var spCode: String { "sp_metric_url_loading_error" }
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

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

@objcMembers public class ConnectionTimeoutAPIError: SPError {
    override public var spCode: String { "sp_metric_connection_timeout\(apiCode.code))" }
    let apiCode: InvalidResponsAPICode
    init(apiCode: InvalidResponsAPICode) {
        self.apiCode = apiCode
        super.init()
    }
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

@objcMembers public class PostingConsentWithoutConsentUUID: SPError {
    override public var spCode: String { "sp_metric_invalid_consent_UUID" }
    override public var description: String {
        "Tried to post consent but the stored consentUUID is empty or nil. Make sure to call .loadMessage or .loadGDPRPrivacyManager or loadCCPAPrivacyManager."
    }

    override public var campaignType: SPCampaignType { get { .gdpr } set {} }
}

@objcMembers public class InvalidMetaDataQueryParamsError: SPError {
    override public var spCode: String { "sp_metric_invalid_meta_data_query_params" }
}

@objcMembers public class InvalidMetaDataResponseError: SPError {
    override public var spCode: String { InvalidResponsAPICode.META_DATA.code }
}

@objcMembers public class InvalidConsentStatusQueryParamsError: SPError {
    override public var spCode: String { "sp_metric_invalid_consent_status_query_params" }
}

@objcMembers public class InvalidConsentStatusResponseError: SPError {
    override public var spCode: String { InvalidResponsAPICode.CONSENT_STATUS.code }
}

@objcMembers public class InvalidPvDataQueryParamsError: SPError {
    override public var spCode: String { "sp_metric_invalid_pv_data_query_params" }
}

@objcMembers public class InvalidPvDataResponseError: SPError {
    override public var spCode: String { InvalidResponsAPICode.PV_DATA.code }
}

@objcMembers public class InvalidChoiceAllParamsError: SPError {
    override public var spCode: String { "sp_metric_invalid_choice_all_query_params" }
}

@objcMembers public class InvalidChoiceAllResponseError: SPError {
    override public var spCode: String { "sp_metric_invalid_choice_all_response" }
}

// swiftlint:disable:next type_name
@objcMembers public class UnableToConvertConsentSnapshotIntoJsonError: SPError {
    override public var spCode: String { "sp_metric_error_converting_consent_snapshot_to_json" }
}

@objcMembers public class InvalidJSONEncodeResult: SPError {
    override public var spCode: String { "sp_metric_error_invalid_JSON_encode_result" }
}

public enum InvalidResponsAPICode: String {
    case META_DATA = "_meta-data"
    case CONSENT_STATUS = "_consent-status"
    case PV_DATA = "_pv-data"
    case MESSAGES = "_messages"
    case EMPTY = ""
    var code: String {
        "sp_metric_invalid_response_api\(rawValue)"
    }
}
