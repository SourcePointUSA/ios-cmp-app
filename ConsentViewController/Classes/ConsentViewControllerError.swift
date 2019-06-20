//
//  ConsentError.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 12.03.19.
//

import Foundation

@objcMembers public class ConsentViewControllerError: NSError, LocalizedError {
    init() {
        super.init(domain: "ConsentViewController", code: 0, userInfo: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@objcMembers public class UnableToParseConsentStringError: ConsentViewControllerError {
    private var euConsent: String

    public var failureReason: String? { get { return "Unable to parse consent string" } }
    public var errorDescription: String? { get { return "Could not parse the raw string \(euConsent) into a ConsentString" } }

    init(euConsent: String) {
        self.euConsent = euConsent
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override public var description: String { get { return "\(errorDescription!)" } }
}

@objcMembers public class InvalidMessageURLError: ConsentViewControllerError {
    private var urlString: String

    public var failureReason: String? { get { return "Failed to parse Message URL." } }
    public var errorDescription: String? { get { return "Could not parse \(urlString) with its query params into URL." } }
    override public var helpAnchor: String? { get { return "Please make sure the query params are URL encodable." } }

    init(urlString: String) {
        self.urlString = urlString
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override public var description: String { get { return "\(errorDescription!)" } }
}

@objcMembers public class InvalidURLError: ConsentViewControllerError {
    private let urlName: String, urlString: String

    public var failureReason: String? { get { return "Failed to parse \(urlName)." } }
    public var errorDescription: String? { get { return "Could not convert \(urlString) into URL." } }
    override public var helpAnchor: String? { get { return "Make sure \(urlName) has the correct value." } }

    init(urlName: String, urlString: String) {
        self.urlName = urlName
        self.urlString = urlString
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override public var description: String { get { return "\(errorDescription!)\n\(helpAnchor!)" } }
}

@objcMembers public class SiteIDNotFound: ConsentViewControllerError {
    private let accountId: String, siteName: String

    public var failureReason: String? { get { return "Could not find site ID." } }
    public var errorDescription: String? { get { return "Could not find a site with name \(siteName) for the account id \(accountId)" } }
    override public var helpAnchor: String? { get { return "Double check your account id and the site name." } }

    init(accountId: String, siteName: String) {
        self.accountId = accountId
        self.siteName = siteName
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override public var description: String { get { return
        "\(errorDescription!)" } }
}

@objcMembers public class GdprStatusNotFound: ConsentViewControllerError {
    private let gdprStatusUrl: URL
    public var failureReason: String? { get { return "Could not get the GDPR status for this user." } }
    public var errorDescription: String? { get { return "Could not get the GDPR status from \(gdprStatusUrl)" } }
    override public var helpAnchor: String? { get { return "Make sure \(gdprStatusUrl) is correct." } }

    init(gdprStatusUrl: URL) {
        self.gdprStatusUrl = gdprStatusUrl
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override public var description: String { get { return
        "\(errorDescription!)"
        } }
}

@objcMembers public class ConsentsAPIError: ConsentViewControllerError {
    public var failureReason: String? { get { return "Failed to get Custom Consents" } }
    public var errorDescription: String? { get { return "Failed to either get custom consents or unable to parse the endpoint's response" } }
    override public var description: String { get { return "\(errorDescription!)" } }
}

public let WebViewErrors: [String : ConsentViewControllerError] = [
    "app.loadError": PrivacyManagerLoadError(),
    "app.saveError": PrivacyManagerSaveError()
]

@objcMembers public class PrivacyManagerLoadError: ConsentViewControllerError {
    public var failureReason: String? { get { return "Failed to start the Privacy Manager" } }
    public var errorDescription: String? { get { return "Could not load the Privacy Manager due to a javascript error." } }
    override public var helpAnchor: String? { get { return "This is most probably happening due to a misconfiguration on the Publisher's portal." } }
    override public var description: String { get { return "\(errorDescription!)\n\(helpAnchor!)" } }
}

@objcMembers public class PrivacyManagerSaveError: ConsentViewControllerError {
    public var failureReason: String? { get { return "Failed to save user consents on Privacy Manager" } }
    public var errorDescription: String? { get { return "Something wrong happened while saving the privacy settings on the Privacy Manager" } }
    override public var helpAnchor: String? { get { return "This might have occurred due to faulty internet connection." } }
    override public var description: String { get { return "\(errorDescription!)" } }
}

@objcMembers public class PrivacyManagerUnknownMessageResponse: ConsentViewControllerError {
    private let name: String, body: [String:Any?]
    init(name: String, body: [String:Any?]) {
        self.name = name
        self.body = body
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public var failureReason: String? { get {
        return "Couldn't parse message in userContentController. Called with name: \(name) and body: \(body)"
        }}
    override public var description: String { get { return "\(failureReason!)\n" } }
}

@objcMembers public class PrivacyManagerUnknownError: ConsentViewControllerError {
    public var failureReason: String? { get { return "Something bad happened in the javascript world." } }
    override public var description: String { get { return "\(failureReason!)\n" } }
}

@objcMembers public class NoInternetConnection: ConsentViewControllerError {
    public var failureReason: String? { get { return "The device is not connected to the internet." } }
    override public var description: String { get { return "\(failureReason!)\n" } }
}

@objcMembers public class MessageTimeout: ConsentViewControllerError {
    public var failureReason: String? { get { return "The Message request has timed out." } }
    override public var description: String { get { return "\(failureReason!)\n" } }
}
