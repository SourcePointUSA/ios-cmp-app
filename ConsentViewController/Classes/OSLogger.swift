//
//  OSLogger.swift
//  GDPRConsentViewController
//
//  Created by Andre Herculano on 06.10.19.
// swiftlint:disable all

import Foundation
import os

protocol SPLogger {
    func log(_ message: String, _ args: [String: String])
    func debug(_ message: String, _ args: [String: String])
    func error(_ message: String, _ args: [String: String])
}

struct OSLogger: SPLogger {
    static let category = "GPDRConsent"

    var consentLog: OSLog? {
        return OSLog(subsystem: Bundle.main.bundleIdentifier!, category: OSLogger.category)
    }

    func log(_ message: String, _ args: [String: String] = [:]) {
        osLog("%s", [message, args])
    }

    func debug(_ message: String, _ args: [String: String] = [:]) {
        osLog("%s", [message, args])
    }

    func error(_ message: String, _ args: [String: String] = [:]) {
        osLog("%s", [message, args])
    }

    private func osLog(_ message: StaticString, _ args: CVarArg) {
        if let consentLog = consentLog {
            os_log(message, log: consentLog, type: .default, args)
        } else {
            print(message, args)
        }
    }
}
