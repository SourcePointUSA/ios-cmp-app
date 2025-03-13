import Foundation
// swiftlint:disable line_length
@objcMembers public class SPError: NSError, LocalizedError {
    public var spCode: String { "sp_metric_generic_sdk_error_\(code)" }

    override public var description: String { "Something went wrong in the SDK" }
    public var failureReason: String { originalError.debugDescription }
    public var originalError: Error?
    var coreError: CoreSPError?
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

@objcMembers public class ClientRequestTimeoutError: SPError {
    let apiSufix: InvalidResponsAPICode
    let timeoutValue: TimeInterval?

    // swiftlint:disable:next force_unwrapping
    var timeoutString: String { timeoutValue != nil ? String(timeoutValue!) : "" }

    override public var spCode: String {
        "sp_metric_client_side_timeout\(apiSufix.code)_\(timeoutString)"
    }
    override public var description: String {
        "The request could not be fullfiled within the timeout (\(timeoutString)) specified by the client"
    }

    init(apiSufix: InvalidResponsAPICode, timeoutValue: TimeInterval?) {
        self.apiSufix = apiSufix
        self.timeoutValue = timeoutValue
        super.init()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

@objcMembers public class GenericNetworkError: SPError {
    let apiSufix: InvalidResponsAPICode
    let error: NSError

    override public var spCode: String { "sp_metric_generic_network_error\(apiSufix.code)_\(error.code)" }
    override public var description: String {
        "Something went wrong when calling \(apiSufix.code)"
    }

    init(apiSufix: InvalidResponsAPICode, error: NSError) {
        self.apiSufix = apiSufix
        self.error = error
        super.init()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

@objcMembers public class UnableToInjectMessageIntoRenderingApp: SPError {
    override public var spCode: String { "sp_metric_unable_to_stringify_msgJSON" }
    override public var description: String { "The SDK could convert the message into JSON." }
}

@objcMembers public class InvalidResponseGetMessagesEndpointError: SPError {
    override public var spCode: String { "sp_metric_invalid_response_api\(InvalidResponsAPICode.MESSAGES.code)" }
    override public var description: String { return optionalDecription }
    var optionalDecription: String = "The SDK got an unexpected response from /get_messages endpoint"
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

@objcMembers public class PostingCustomConsentWithoutConsentUUID: SPError {
    override public var spCode: String { "sp_metric_invalid_consent_UUID" }
    override public var description: String {
        "Tried to post consent but the stored consentUUID is empty or nil. Make sure to call .loadMessage or .loadGDPRPrivacyManager or loadCCPAPrivacyManager."
    }

    override public var campaignType: SPCampaignType { get { .gdpr } set {} }
}

@objcMembers public class InvalidResponseCustomError: SPError {
    override public var spCode: String { "sp_metric_invalid_response_custom_consent" }
    override public var description: String { return optionalDecription }
    var optionalDecription: String = "The SDK got an unexpected response from /custom-consent endpoint"
}

@objcMembers public class InvalidResponseDeleteCustomError: SPError {
    override public var spCode: String { "sp_metric_invalid_response_delete_custom_consent" }
    override public var description: String { return optionalDecription }
    var optionalDecription: String = "The SDK got an unexpected response from /consent/tcfv2/consent/v3/custom/ endpoint"
}

/// Network Errors
@objcMembers public class NoInternetConnection: SPError {
    override public var spCode: String { "sp_metric_no_internet_connection" }
    override public var description: String { "The device is not connected to the internet." }
}

@objcMembers public class WebViewConnectionTimeOutError: SPError {
    override public var spCode: String { "sp_metric_webview_connection_timeout" }
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

@objcMembers public class InvalidResponseAPIError: SPError {
    override public var spCode: String {
        "sp_metric_invalid_response_api\(apiCode.code)_\(statusCode)"
    }
    let apiCode: InvalidResponsAPICode
    let statusCode: String

    init(apiCode: InvalidResponsAPICode, statusCode: String) {
        self.apiCode = apiCode
        self.statusCode = statusCode
        super.init()
    }
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

@objcMembers public class ReportActionError: SPError {
    override public var spCode: String { "sp_metric_report_action_exception" }
    override public var description: String { return optionalDecription }
    var optionalDecription: String = "Unable to report action"
}

// swiftlint:disable:next type_name
@objcMembers public class UnableToConvertConsentSnapshotIntoJsonError: SPError {
    override public var spCode: String { "sp_metric_error_converting_consent_snapshot_to_json" }
}

@objcMembers public class InvalidJSONEncodeResult: SPError {
    override public var spCode: String { "sp_metric_error_invalid_JSON_encode_result" }
}

@objcMembers public class InvalidReportActionEvent: SPError {
    override public var spCode: String { "sp_metric_error_invalid_JSON_encode_result" }
}

public enum InvalidResponsAPICode: String {
    case META_DATA = "_meta-data"
    case CONSENT_STATUS = "_consent-status"
    case PV_DATA = "_pv-data"
    case MESSAGES = "_messages"
    case ERROR_METRICS = "_error-metrics"
    case CCPA_ACTION = "_CCPA-action"
    case GDPR_ACTION = "_GDPR-action"
    case USNAT_ACTION = "_USNAT-action"
    case IDFA_STATUS = "_IDFA-status"
    case CCPA_PRIVACY_MANAGER = "_CCPA-privacy-manager"
    case CHOICE_ALL = "_choice-all"
    case GDPR_PRIVACY_MANAGER = "_GDPR-privacy-manager"
    case CCPA_MESSAGE = "_CCPA-message"
    case GDPR_MESSAGE = "_GDPR-message"
    case DELETE_CUSTOM_CONSENT = "_delete-custom-consent-GDPR"
    case EMPTY = ""
    var code: String {
        "\(rawValue)"
    }
}

// swiftlint:enable line_length
