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
    func appendQueryItems(_ parameters: [String: String]) -> URL? {
        if var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) {
            urlComponents.queryItems = (urlComponents.queryItems ?? []) + Array(parameters.keys).sorted().map { key in
                URLQueryItem(name: key, value: parameters[key])
            }
            return urlComponents.url
        }
        return nil
    }
}
