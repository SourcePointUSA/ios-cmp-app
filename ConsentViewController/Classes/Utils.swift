//
//  Utils.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 15.03.19.
//

import Foundation

struct Utils {
    static func validate(attributeName: String, urlString: String) throws -> URL{
        guard let url = URL(string: urlString) else {
            throw InvalidURLError(urlName: attributeName, urlString: urlString)
        }
        return url
    }
}
