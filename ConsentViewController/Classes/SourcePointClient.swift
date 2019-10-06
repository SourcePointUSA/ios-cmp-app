//
//  SourcePointClient.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 13.03.19.
//

import Foundation

protocol HttpClient { func get(url: URL, completionHandler handler : @escaping (Data?) -> Void) }

class SimpleClient: HttpClient {
    func get(url: URL, completionHandler cHandler : @escaping (Data?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, reponse, error in
            DispatchQueue.main.async { cHandler(data) }
        }
        task.resume()
    }
}

struct ConsentsResponse : Codable {
    let consentedVendors: [VendorConsent]
    let consentedPurposes: [PurposeConsent]
}

typealias TargetingParams = [String:Any]

class SourcePointClient {
    private let client: HttpClient

    private let accountId: Int
    private let siteId: Int
    private let pmId: String
    private let showPM: Bool
    private let runMessaging: Bool
    private let siteUrl: URL
    private let mmsUrl: URL
    private let cmpUrl: URL
    private let messageUrl: URL
    private let statusGdprUrl: URL
    private let campaign: String

    init(accountId: Int, siteId:Int, pmId:String, showPM:Bool, siteUrl: URL, campaign: String, mmsUrl: URL, cmpUrl: URL, messageUrl: URL) throws {
        self.accountId = accountId
        self.siteId = siteId
        self.pmId = pmId
        self.showPM = showPM
        self.runMessaging = !showPM
        self.siteUrl = siteUrl
        self.mmsUrl = mmsUrl
        self.cmpUrl = cmpUrl
        self.messageUrl = messageUrl
        self.campaign = campaign

        statusGdprUrl = try Utils.validate(
            attributeName: "statusGDPRUrl",
            urlString: cmpUrl.absoluteString + "/consent/v2/gdpr-status"
        )

        self.client = SimpleClient()
    }

    func getGdprStatus(completionHandler cHandler : @escaping (Int?,ConsentViewControllerError?) -> Void) {
        client.get(url: statusGdprUrl) { (result) in
            if let _result = result, let parsedResult = (try? JSONSerialization.jsonObject(with: _result, options: [])) as? [String: Int] {
                let gdprStatus = parsedResult["gdprApplies"]
                cHandler(gdprStatus,nil)
            } else {
                cHandler(nil, GdprStatusNotFound(gdprStatusUrl: self.statusGdprUrl))
            }
        }
    }

    // TODO: validate customConsentsURL with Utils.validate
    func getCustomConsents(forSiteId siteId: String, consentUUID: String,euConsent: String, completionHandler cHandler : @escaping (ConsentsResponse?, ConsentViewControllerError?) -> Void) {

        let path = "/consent/v2/\(siteId)/custom-vendors"
        let search = "?consentUUID=\(consentUUID)&euconsent=\(euConsent)"
        let decoder = JSONDecoder()

        if let getCustomConsentsUrl = URL(string: path + search, relativeTo: cmpUrl) {
            client.get(url: getCustomConsentsUrl) { (result) in
                if let _result = result, let consents = try? decoder.decode(ConsentsResponse.self, from: _result) {
                    cHandler(consents, nil)
                }else {
                    cHandler(nil, ConsentsAPIError())
                }
            }
        }
    }

    private func encode(targetingParams params: TargetingParams) throws -> String {
        let data = try JSONSerialization.data(withJSONObject: params)
        return String(data: data, encoding: String.Encoding.utf8)!
    }

    func getMessageUrl(forTargetingParams params: TargetingParams, debugLevel: String, newPM: Bool, authId: String?) throws -> URL {
        var url: URL
        var components = URLComponents()
        var queryItems: [String:String] = [:]

        do {
            queryItems = [
                "_sp_accountId": String(accountId),
                "_sp_PMId": pmId,
                "_sp_siteId": String(siteId),
                "_sp_siteHref": siteUrl.absoluteString,
                "_sp_runMessaging" : String(runMessaging),
                "_sp_showPM": String(showPM),
                "_sp_mms_Domain": mmsUrl.absoluteString,
                "_sp_cmp_origin": "\(cmpUrl)",
                "_sp_targetingParams": try encode(targetingParams: params),
                "_sp_env": campaign
            ]
            if(authId != nil) { queryItems["_sp_authId"] = authId }
            components.queryItems = queryItems.map { URLQueryItem(name: $0.key, value: $0.value) }
            url = components.url(relativeTo: messageUrl)!
        } catch {
            throw InvalidMessageURLError(urlString: messageUrl.absoluteString)
        }

        return url
    }
}
