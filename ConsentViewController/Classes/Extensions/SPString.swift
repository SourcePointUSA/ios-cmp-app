//
//  SPString.swift
//  Pods
//
//  Created by Andre Herculano on 17.06.21.
//

import Foundation

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = self.stripOutHtml()?.data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.plain,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
        } catch {
            return nil
        }
    }
    var htmlToString: String { htmlToAttributedString?.string ?? "" }
    func stripOutHtml() -> String? {
        // replace &lt; with < and &gt; with >
        let decoded = self.replacingOccurrences(of: "&lt;", with: "<").replacingOccurrences(of: "&gt;", with: ">")
        // removes any CSS inline styling
        let noCSS = decoded.replacingOccurrences(of: "<style>[^>]+</style>", with: "", options: .regularExpression, range: nil)
        // removes any HTML tags
        let noHTML = noCSS.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        return noHTML
    }
}
