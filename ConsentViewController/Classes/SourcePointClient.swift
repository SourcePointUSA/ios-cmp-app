//
//  SourcePointClient.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 13.03.19.
//

import Foundation

protocol HttpClient {
    func get(url: URL) -> Data?
}

class SimpleClient: HttpClient {
    func get(url: URL) -> Data? {
        let semaphore = DispatchSemaphore( value: 0 )
        var responseData: Data?
        let task = URLSession.shared.dataTask(with: url) { data, reponse, error in
            responseData = data
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        return responseData
    }
}

struct ConsentsResponse : Codable {
    let consentedVendors: [VendorConsent]
    let consentedPurposes: [PurposeConsent]
}

class SourcePointClient {
    private let client: HttpClient

    private let accountId: String
    private let siteName: String

    private let mmsUrl: URL
    private let cmpUrl: URL

    init(accountId: Int, siteName: String, stagingCampaign: Bool, mmsUrl: URL, cmpUrl: URL, messageUrl: URL) throws {
        self.accountId = String(accountId)
        self.siteName = siteName
        self.mmsUrl = mmsUrl
        self.cmpUrl = cmpUrl

        self.client = SimpleClient()
    }

    public func getSiteId() throws -> String {
        guard
            let getIdUrl = URL(string: "/get_site_data?account_id=" + accountId + "&href=https://" + siteName, relativeTo: mmsUrl),
            let result = client.get(url: getIdUrl),
            let parsedResult = try JSONSerialization.jsonObject(with: result, options: []) as? [String:Int],
            let siteId = parsedResult["site_id"]
        else {
            throw ConsentViewControllerError.APIError(
                message: "Could not get Site ID. Are you sure you provided the correct Account Id and Site Name?"
            )
        }

        return String(siteId)
    }

    public func getGdprStatus() throws -> Bool {
        guard
            let getGdprStatusUrl = URL(string: "/consent/v2/gdpr-status", relativeTo: cmpUrl),
            let result = client.get(url: getGdprStatusUrl),
            let parsedResult = try JSONSerialization.jsonObject(with: result, options: []) as? [String: Int],
            let gdprStatus = parsedResult["gdprApplies"]
        else {
            throw ConsentViewControllerError.APIError(
                message: "Could not get GDPR status."
            )
        }
        return gdprStatus == 1
    }

    public func getCustomConsents(
        forSiteId siteId: String,
        consentUUID: String,
        euConsent: String)
    throws -> ConsentsResponse {
        let path = "/consent/v2/\(siteId)/custom-vendors"
        let search = "?consentUUID=\(consentUUID)&euconsent=\(euConsent)"
        let decoder = JSONDecoder()

        guard
            let getCustomConsentsUrl = URL(string: path + search, relativeTo: cmpUrl),
            let consentsResponse = client.get(url: getCustomConsentsUrl),
            let consents = try? decoder.decode(ConsentsResponse.self, from: consentsResponse)
        else {
            throw ConsentViewControllerError.APIError(message: "Could not get consents from the API.")
        }

        return consents
    }
}
