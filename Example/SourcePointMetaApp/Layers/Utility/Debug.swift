//
//  Debug.swift
//  SourcepointMetaApp
//
//  Created by Vilas on 3/22/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import Foundation

class Log {

    // shared manager instance
    static let sharedLog = Log()

    var intFor: Int

    init() {
        intFor = 42
    }

    func DLog(message: String, function: String = #function) {
        #if DEBUG
        print("\(function): \(message)")
        #endif
    }
}
