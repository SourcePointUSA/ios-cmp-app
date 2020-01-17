//
//  String.swift
//  gdprConsentStringSwift
//
//  Created by Daniel Kanaan on 4/17/18.
//  Copyright © 2018 Daniel Kanaan. All rights reserved.
//

import Foundation

extension String {
    
    var base64Padded:String {
        get {
            return self.padding(toLength: ((self.count + 3) / 4) * 4,withPad: "=",startingAt: 0)
        }
    }

    public func fromWebSafe() -> String {
        return self
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
    }
    
    public func toWebSafe() -> String {
        return self
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
    }
}
