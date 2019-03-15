//
//  ConsentError.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 12.03.19.
//

import Foundation

public protocol ConsentViewControllerError: LocalizedError, CustomStringConvertible {}

public struct InvalidURLError: ConsentViewControllerError {
    private let urlName: String
    private let urlString: String

    public var failureReason: String? { get { return "Failed to parse \(urlName)." } }
    public var errorDescription: String? { get { return "Could not convert \(urlString) into URL." } }
    public var helpAnchor: String? { get { return "Make sure \(urlName) has the correct value." } }

    init(urlName: String, urlString: String) {
        self.urlName = urlName
        self.urlString = urlString
    }
    public var description: String { get {return "\(failureReason!)\n\(errorDescription!)\n\(helpAnchor!)" } }
}

public struct SiteIDNotFound: ConsentViewControllerError {
    private let accountId: String
    private let siteName: String

    public var failureReason: String? { get { return "Could not find site ID)." } }
    public var errorDescription: String? { get { return "Could not find a site with name \(siteName) for your account id \(accountId)" } }
    public var helpAnchor: String? { get { return "Double check your account id and the site name." } }

    init(accountId: String, siteName: String) {
        self.accountId = accountId
        self.siteName = siteName
    }
    public var description: String { get {return "\(failureReason!)\n\(errorDescription!)\n\(helpAnchor!)" } }
}

public struct GdprStatusNotFound: ConsentViewControllerError {
    private let gdprStatusUrl: URL
    public var failureReason: String? { get { return "Could not get the GDPR status for this user." } }
    public var errorDescription: String? { get { return "Could not get the GDPR status from \(gdprStatusUrl)" } }
    public var helpAnchor: String? { get { return "Make sure \(gdprStatusUrl) is correct." } }

    init(gdprStatusUrl: URL) { self.gdprStatusUrl = gdprStatusUrl }
    public var description: String { get {return "\(failureReason!)\n\(errorDescription!)\n\(helpAnchor!)" } }
}

public struct ConsentsAPIError: ConsentViewControllerError {
    public var failureReason: String? { get { return "Failed to get Custom Consents" } }
    public var errorDescription: String? { get { return "Failed to either get custom consents or parse the endpoint's response" } }
    public var description: String { get {return "\(failureReason!)\n\(errorDescription!)" } }
}

public let WebViewErrors: [String : ConsentViewControllerError] = [
    "app.loadError": PrivacyManagerLoadError(),
    "app.saveError": PrivacyManagerSaveError()
]

public struct PrivacyManagerLoadError: ConsentViewControllerError {
    public var failureReason: String? { get { return "Failed start the Privacy Manager" } }
    public var errorDescription: String? { get { return "Could not load the Privacy Manager due to a javascript error." } }
    public var helpAnchor: String? { get { return "This is most probably happening due to a misconfiguration on the Publisher's portal." } }
    public var description: String { get {return "\(failureReason!)\n\(errorDescription!)\n\(helpAnchor!)" } }
}

public struct PrivacyManagerSaveError: ConsentViewControllerError {
    public var failureReason: String? { get { return "Failed save user consents on Privacy Manager" } }
    public var errorDescription: String? { get { return "Something wrong happened while saving the privacy settings on the Privacy Manager" } }
    public var helpAnchor: String? { get { return "This might have occurred due to faulty internet connection." } }
    public var description: String { get {return "\(failureReason!)\n\(errorDescription!)\n\(helpAnchor!)" } }
}

public struct PrivacyManagerUnknownError: ConsentViewControllerError {
    public var failureReason: String? { get { return "Something bad happened in the javascript world." } }
    public var description: String { get {return "\(failureReason!)\n" } }
}

public struct NoInternetConnection: ConsentViewControllerError {
    public var failureReason: String? { get { return "The device is not connected to the internet." } }
    public var description: String { get {return "\(failureReason!)\n" } }
}
