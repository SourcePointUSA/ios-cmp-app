//
//  SPString.swift
//  Pods
//
//  Created by Andre Herculano on 17.06.21.
//

import Foundation

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = self.stripOutCss()?.data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
        } catch {
            return nil
        }
    }
    var htmlToString: String { htmlToAttributedString?.string ?? "" }
    func stripOutCss(stripHtml: Bool = false) -> String? {
        // replace &lt; with < and &gt; with >
        let decoded = self.replacingOccurrences(of: "&lt;", with: "<").replacingOccurrences(of: "&gt;", with: ">")
        // removes any CSS inline styling
        let noCSS = decoded.replacingOccurrences(of: "<style>[^>]+</style>", with: "", options: .regularExpression, range: nil)
        // removes any HTML tags
        var result = noCSS
        if stripHtml {
            result = result.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        }
        return result
    }
}
