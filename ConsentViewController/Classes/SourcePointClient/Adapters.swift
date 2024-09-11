//
//  Adapters.swift
//  Pods
//
//  Created by Andre Herculano on 10/9/24.
//

import Foundation
import SPMobileCore

extension SPDate {
    init(string: String) {
        originalDateString = string
        date = Self.format.date(from: originalDateString) ?? Date()
    }
}
