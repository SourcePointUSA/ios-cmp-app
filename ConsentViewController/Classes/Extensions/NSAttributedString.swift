//
//  NSAttributedString.swift
//  Pods
//
//  Created by Dmytro Fedko on 15.12.2021.
//

import Foundation

extension NSAttributedString {
    func replaceHTMLTag(tag: String, withAttributes attributes: [NSAttributedString.Key: Any]) -> NSAttributedString? {
        let openTag = "<\(tag)>"
        let closeTag = "</\(tag)>"

        let resultingText: NSMutableAttributedString = self.mutableCopy() as! NSMutableAttributedString
        while true {
            let plainString = resultingText.string as NSString
            let openTagRange = plainString.range(of: openTag)
            if openTagRange.length == 0 { break }
            
            let affectedLocation = openTagRange.location + openTagRange.length
            let searchRange = NSRange(location: affectedLocation, length: plainString.length - affectedLocation)
            let closeTagRange = plainString.range(of: closeTag, options: NSString.CompareOptions.init(rawValue: 0), range: searchRange)

            resultingText.setAttributes(attributes, range: NSRange(location: affectedLocation, length: closeTagRange.location - affectedLocation))
            resultingText.deleteCharacters(in: closeTagRange)
            resultingText.deleteCharacters(in: openTagRange)
        }
        return resultingText as NSAttributedString
    }
}
