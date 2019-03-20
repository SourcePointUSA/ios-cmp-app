//
//  SourcePointClient.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 13.03.19.
//

import Foundation

protocol HttpClient { func get(url: URL) -> Data? }

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

typealias TargetingParams = [String:Any]

class SourcePointClient {
    private let client: HttpClient

    private let accountId: String

    private let siteUrl: URL
    private let mmsUrl: URL
    private let cmpUrl: URL
    private let messageUrl: URL

    private let siteIdUrl: URL
    private let statusGdprUrl: URL

    private let stagingCampaign: Bool

    init(accountId: String, siteUrl: URL, stagingCampaign: Bool, mmsUrl: URL, cmpUrl: URL, messageUrl: URL) throws {
        self.accountId = accountId
        self.siteUrl = siteUrl
        self.mmsUrl = mmsUrl
        self.cmpUrl = cmpUrl
        self.messageUrl = messageUrl
        self.stagingCampaign = stagingCampaign

        siteIdUrl = try Utils.validate(
            attributeName: "siteIdUrl",
            urlString: mmsUrl.absoluteString+"/get_site_data?account_id=" + accountId + "&href=" + siteUrl.absoluteString
        )
        statusGdprUrl = try Utils.validate(
            attributeName: "statusGDPRUrl",
            urlString: cmpUrl.absoluteString + "/consent/v2/gdpr-status"
        )

        self.client = SimpleClient()
    }

    func getSiteId() throws -> String {
        guard
            let result = client.get(url: siteIdUrl),
            let parsedResult = try? JSONSerialization.jsonObject(with: result, options: []) as? [String:Int],
            let siteId = parsedResult?["site_id"]
        else { throw SiteIDNotFound(accountId: accountId, siteName: siteUrl.host!) }

        return String(siteId)
    }

    func getGdprStatus() throws -> Int {
        guard
            let result = client.get(url: statusGdprUrl),
            let parsedResult = try? JSONSerialization.jsonObject(with: result, options: []) as? [String: Int],
            let gdprStatus = parsedResult?["gdprApplies"]
        else {
            throw GdprStatusNotFound(gdprStatusUrl: statusGdprUrl)
        }
        return gdprStatus
    }

    // TODO: validate customConsentsURL with Utils.validate
    func getCustomConsents(
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
        else { throw ConsentsAPIError() }

        return consents
    }

    private func encode(targetingParams params: TargetingParams) throws -> String {
        let data = try JSONSerialization.data(withJSONObject: params)
        return String(data: data, encoding: String.Encoding.utf8)!
    }

    func getMessageUrl(forTargetingParams params: TargetingParams, debugLevel: String) throws -> URL {
        var url: URL
        var components = URLComponents()

        do {
            components.queryItems = [
                "_sp_accountId": accountId,
                "_sp_cmp_inApp": "true",
                "_sp_writeFirstPartyCookies": "true",
                "_sp_siteHref": siteUrl.absoluteString,
                "_sp_msg_domain": mmsUrl.host!,
                "_sp_cmp_origin": cmpUrl.host!,
                "_sp_msg_targetingParams": try encode(targetingParams: params),
                "_sp_debug_level": debugLevel,
                "_sp_msg_stageCampaign": String(stagingCampaign)
                ].map { URLQueryItem(name: $0.key, value: $0.value) }
            url = components.url(relativeTo: messageUrl)!
        } catch {
            throw InvalidMessageURLError(urlString: messageUrl.absoluteString)
        }

        return url
    }
}
