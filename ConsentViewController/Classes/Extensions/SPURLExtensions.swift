//
//  GDPRURLExtensions.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 09.12.20.
//

import Foundation

extension URL {
    /// - Parameter parameters: parameters dictionary.
    /// - Returns: URL with appending given query parameters.
    public func appendQueryItems(_ parameters: [String: String?]) -> URL? {
        let filteredParams = parameters.filter { _, value in value != nil }

        if var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) {
            urlComponents.queryItems = (urlComponents.queryItems ?? []) + Array(filteredParams.keys).sorted().map { key in
                URLQueryItem(name: key, value: filteredParams[key] ?? "")
            }
            return urlComponents.url
        }
        return nil
    }
}
