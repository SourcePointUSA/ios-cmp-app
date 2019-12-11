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
    static let WRAPPER_API = URL(string: "https://fake_wrapper_api.com")!
    static let CMP_URL = URL(string: "https://sourcepoint.mgr.consensu.org")!
    static let GET_GDPR_STATUS_URL = URL(string: "consent/v2/gdpr-status", relativeTo: CMP_URL)!
    static let GET_MESSAGE_URL = URL(string: "getMessageUrl", relativeTo: SourcePointClient.WRAPPER_API)!
    
    private let client: HttpClient
    private lazy var jsonDecoder: JSONDecoder = { return JSONDecoder() }()
    
    private let accountId: Int
    private let propertyId: Int
    private let pmId: String
    private let campaign: String

    init(accountId: Int, propertyId:Int, pmId:String, campaign: String, client: HttpClient) {
        self.accountId = accountId
        self.propertyId = propertyId
        self.pmId = pmId
        self.campaign = campaign
        self.client = client
    }
    
    convenience init(accountId: Int, propertyId: Int, pmId: String, campaign: String) {
        self.init(accountId: accountId, propertyId: propertyId, pmId: pmId, campaign: campaign, client: SimpleClient())
    }

    func getGdprStatus(completionHandler cHandler : @escaping (Int?,ConsentViewControllerError?) -> Void) {
        client.get(url: SourcePointClient.GET_GDPR_STATUS_URL) { (result, _error) in
            if let _result = result, let parsedResult = (try? JSONSerialization.jsonObject(with: _result, options: [])) as? [String: Int] {
                let gdprStatus = parsedResult["gdprApplies"]
                cHandler(gdprStatus,nil)
            } else {
                cHandler(nil, GdprStatusNotFound(gdprStatusUrl: SourcePointClient.GET_GDPR_STATUS_URL))
            }
        }
    }
    
    func getCustomConsentsUrl(propertyId id: String, consentUUID uuid: String, euconsent: String) -> URL? {
        return URL(
            string: "/consent/v2/\(id)/custom-vendors?consentUUID=\(uuid)&euconsent=\(euconsent)",
            relativeTo: SourcePointClient.CMP_URL
        )
    }

    // TODO: validate customConsentsURL with Utils.validate
    func getCustomConsents(forPropertyId propertyId: String, consentUUID: String, euConsent: String, completionHandler cHandler : @escaping (ConsentsResponse?, ConsentViewControllerError?) -> Void) {
        if let customConsentsUrl = getCustomConsentsUrl(propertyId: propertyId, consentUUID: consentUUID, euconsent: euConsent) {
            client.get(url: customConsentsUrl) { [weak self] (result, _error) in
                if let _result = result, let consents = try? self?.jsonDecoder.decode(ConsentsResponse.self, from: _result) {
                    cHandler(consents, nil)
                }else {
                    cHandler(nil, ConsentsAPIError())
                }
            }
        }
    }

    func getMessageUrl(accountId: Int, propertyId: Int, onSuccess: @escaping (MessageResponse) -> Void, onError: OnError?) {
        let _onError: OnError = { error in onError?(GetMessageAPIError(parsingError: error)) }
        let _onSuccess: OnSuccess = { [weak self] data in
            do {
                onSuccess(try (self?.jsonDecoder.decode(MessageResponse.self, from: data))!)
            } catch {
                _onError(error)
            }
        }
        client.get(url: SourcePointClient.GET_MESSAGE_URL, onSuccess: _onSuccess, onError: _onError)
    }
}
