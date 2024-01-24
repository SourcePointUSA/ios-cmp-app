//
//  Date.swift
//  Pods
//
//  Created by Andre Herculano on 30.10.23.
//

// swiftlint:disable force_unwrapping

import Foundation

extension Date {
    static var yesterday: Date { Date().dayBefore }
    static var tomorrow: Date { Date().dayAfter }
    var dayBefore: Date {
        Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
}

// swiftlint:enable force_unwrapping
