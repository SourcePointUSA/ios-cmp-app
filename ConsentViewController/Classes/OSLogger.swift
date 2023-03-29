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

enum SPLogLevel: String {
    case debug
    case prod
}

struct OSLogger: SPLogger {
    static let category = "SPSDK"
    static var standard: OSLogger { OSLogger() }

    let consentLog = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: OSLogger.category)
    let level = SPLogLevel(rawValue: Bundle.framework.object(forInfoDictionaryKey: "SPLogLevel") as? String ?? "debug")

    func log(_ message: String) {
        if level == .debug {
            osLog("%s", message)
        }
    }

    func debug(_ message: String) {
        if level == .debug {
            osLog("%s", message)
        }
    }

    func error(_ message: String) {
        if level == .debug {
            osLog("%s", message)
        }
    }

    private func osLog(_ message: StaticString, _ args: CVarArg) {
        os_log(message, log: consentLog, type: .default, args)
    }
}
