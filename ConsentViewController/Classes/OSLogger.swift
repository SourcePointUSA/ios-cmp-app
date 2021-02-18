//
//  OSLogger.swift
//  GDPRConsentViewController
//
//  Created by Andre Herculano on 06.10.19.
// swiftlint:disable all

import Foundation
import os

protocol SPLogger {
    func log(_ message: String)
    func debug(_ message: String)
    func error(_ message: String)
}

struct OSLogger: SPLogger {
    static let category = "SPSDK"

    var consentLog: OSLog? {
        if #available(iOS 10.0, *) {
            return OSLog(subsystem: Bundle.main.bundleIdentifier!, category: OSLogger.category)
        } else {
            return nil
        }
    }

    func log(_ message: String) {
        osLog("%s", message)
    }

    func debug(_ message: String) {
        osLog("%s", message)
    }

    func error(_ message: String) {
        osLog("%s", message)
    }

    private func osLog(_ message: StaticString, _ args: CVarArg) {
        if #available(iOS 10, *), let consentLog = consentLog {
            os_log(message, log: consentLog, type: .default, args)
        } else {
            print(message, args)
        }
    }
}
