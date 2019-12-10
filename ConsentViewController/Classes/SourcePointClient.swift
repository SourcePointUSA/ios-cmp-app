//
//  SourcePointClient.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 13.03.19.
//

import Foundation

typealias OnSuccess = (Data) -> Void
typealias OnError = (Error?) -> Void

protocol HttpClient {
    func get(url: URL, completionHandler handler : @escaping (Data?, Error?) -> Void)
    func get(url: URL, onSuccess: @escaping OnSuccess, onError: OnError?)
}

class SimpleClient: HttpClient {
    func get(url: URL, onSuccess: @escaping (Data) -> Void, onError: OnError?) {
        URLSession.shared.dataTask(with: url) { data, _response, error in
            DispatchQueue.main.async {
                guard let data = data else {
                    onError?(error)
                    return
                }
                onSuccess(data)
            }
        }.resume()
    }
    
    func get(url: URL, completionHandler cHandler : @escaping (Data?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async { cHandler(data, error) }
        }.resume()
    }
}

struct ConsentsResponse : Codable {
    let consentedVendors: [VendorConsent]
    let consentedPurposes: [PurposeConsent]
}

struct MessageResponse: Codable, Equatable {
    let url: URL?
}

typealias TargetingParams = [String:Any]

class SourcePointClient {
    static let GET_MESSAGE_URL = URL(string: "https://fake_wrapper_api.com")!
    
    private let client: HttpClient

    private let accountId: Int
    private let propertyId: Int
    private let pmId: String
    private let showPM: Bool
    private let runMessaging: Bool
    private let propertyUrl: URL
    private let mmsUrl: URL
    private let cmpUrl: URL
    private let messageUrl: URL
    private let statusGdprUrl: URL
    private let campaign: String

    init(accountId: Int, propertyId:Int, pmId:String, showPM:Bool, propertyUrl: URL, campaign: String, mmsUrl: URL, cmpUrl: URL, messageUrl: URL, client: HttpClient) throws {
        self.accountId = accountId
        self.propertyId = propertyId
        self.pmId = pmId
        self.showPM = showPM
        self.runMessaging = !showPM
        self.propertyUrl = propertyUrl
        self.mmsUrl = mmsUrl
        self.cmpUrl = cmpUrl
        self.messageUrl = messageUrl
        self.campaign = campaign

        statusGdprUrl = try Utils.validate(
            attributeName: "statusGDPRUrl",
            urlString: cmpUrl.absoluteString + "/consent/v2/gdpr-status"
        )

        self.client = client
    }
    
    convenience init(accountId: Int, propertyId: Int, pmId: String, showPM: Bool, propertyUrl: URL, campaign: String, mmsUrl: URL, cmpUrl: URL, messageUrl: URL) throws {
        try self.init(accountId: accountId, propertyId: propertyId, pmId: pmId, showPM: showPM, propertyUrl: propertyUrl, campaign: campaign, mmsUrl: mmsUrl, cmpUrl: cmpUrl, messageUrl: messageUrl, client: SimpleClient())
    }

    func getGdprStatus(completionHandler cHandler : @escaping (Int?,ConsentViewControllerError?) -> Void) {
        client.get(url: statusGdprUrl) { (result, _error) in
            if let _result = result, let parsedResult = (try? JSONSerialization.jsonObject(with: _result, options: [])) as? [String: Int] {
                let gdprStatus = parsedResult["gdprApplies"]
                cHandler(gdprStatus,nil)
            } else {
                cHandler(nil, GdprStatusNotFound(gdprStatusUrl: self.statusGdprUrl))
            }
        }
    }

    // TODO: validate customConsentsURL with Utils.validate
    func getCustomConsents(forPropertyId propertyId: String, consentUUID: String,euConsent: String, completionHandler cHandler : @escaping (ConsentsResponse?, ConsentViewControllerError?) -> Void) {

        let path = "/consent/v2/\(propertyId)/custom-vendors"
        let search = "?consentUUID=\(consentUUID)&euconsent=\(euConsent)"
        let decoder = JSONDecoder()

        if let getCustomConsentsUrl = URL(string: path + search, relativeTo: cmpUrl) {
            client.get(url: getCustomConsentsUrl) { (result, _error) in
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

    func getSDKWebURL(forTargetingParams params: TargetingParams, debugLevel: String, newPM: Bool, authId: String?) throws -> URL {
        var url: URL
        var components = URLComponents()
        var queryItems: [String:String] = [:]

        do {
            queryItems = [
                "_sp_accountId": String(accountId),
                "_sp_PMId": pmId,
                "_sp_siteId": String(propertyId),
                "_sp_siteHref": propertyUrl.absoluteString,
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
    
    func getMessageUrl(accountId: Int, propertyId: Int, onSuccess: @escaping (MessageResponse) -> Void, onError: OnError?) {
        let _onError: OnError = { error in onError?(GetMessageAPIError(parsingError: error)) }
        let _onSuccess: OnSuccess = { data in
            do { onSuccess(try JSONDecoder().decode(MessageResponse.self, from: data))
            } catch { _onError(error) }
        }
        
        client.get(
            url: URL(string: "getMessageUrl", relativeTo: SourcePointClient.GET_MESSAGE_URL)!,
            onSuccess: _onSuccess,
            onError: _onError
        )
    }
}
