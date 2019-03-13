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

class SourcePointClient {
    private let client: HttpClient

    private let accountId: String
    private let siteName: String

    private let mmsUrl: URL

    init(accountId: Int, siteName: String, stagingCampaign: Bool, mmsUrl: URL, cmpUrl: URL, messageUrl: URL) throws {
        self.accountId = String(accountId)
        self.siteName = siteName
        self.mmsUrl = mmsUrl

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

}
