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
    func begin(_ name: StaticString)
    func end(_ name: StaticString)
    func end(_ name: StaticString, _ args: CVarArg...)
    func event(_ name: StaticString)
    func event(_ name: StaticString, _ args: CVarArg...)
}

enum SPLogLevel: String {
    case debug
    case prod
}

@available(iOS 12.0, tvOS 12.0, *)
struct ModernishLogger: SPLogger {
    let logger = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: .pointsOfInterest)

    func begin(_ name: StaticString) {
        os_signpost(.begin, log: logger, name: name)
    }

    func end(_ name: StaticString) {
        os_signpost(.end, log: logger, name: name)
    }

    func end(_ name: StaticString, _ args: CVarArg...) {
        os_signpost(.event, log: logger, name: name, "%@", args)
    }

    func event(_ name: StaticString) {
        os_signpost(.event, log: logger, name: name)
    }

    func event(_ name: StaticString, _ args: CVarArg...) {
        os_signpost(.event, log: logger, name: name, "%@", args)
    }

    func log(_ message: String) {
        osLog("%s", message)
    }

    func debug(_ message: String) {
        osLog("%s", type: .debug, message)
    }

    func error(_ message: String) {
        osLog("%s", type: .error, message)
    }

    private func osLog(_ message: StaticString, type: OSLogType? = .default, _ args: CVarArg) {
        os_log(message, log: logger, type: type ?? .default, args)
    }
}

struct LegacyLogger: SPLogger {
    let logger = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "SPSDK")

    func begin(_ name: StaticString) {
        log("Begin: \(name)")
    }

    func end(_ name: StaticString) {
        log("End: \(name)")
    }

    func end(_ name: StaticString, _ args: CVarArg...) {
        log("End: \(name) \(String(format: "%@", args))")
    }

    func event(_ name: StaticString) {
        log("Event: \(name)")
    }

    func event(_ name: StaticString, _ args: CVarArg...) {
        log("Event: \(name) \(String(format: "%@", args))")
    }

    func log(_ message: String) {
        osLog("%s", message)
    }

    func debug(_ message: String) {
        osLog("%s", type: .debug, message)
    }

    func error(_ message: String) {
        osLog("%s", type: .error, message)
    }

    private func osLog(_ message: StaticString, type: OSLogType? = .default, _ args: CVarArg) {
        os_log(message, log: logger, type: type ?? .default, args)
    }
}

struct NoopLogger: SPLogger {
    func begin(_ name: StaticString) {}

    func end(_ name: StaticString) {}

    func end(_ name: StaticString, _ args: CVarArg...) {}

    func event(_ name: StaticString) {}

    func event(_ name: StaticString, _ args: CVarArg...) {}

    func log(_ message: String) {}

    func debug(_ message: String) {}

    func error(_ message: String) {}
}

struct OSLogger: SPLogger {
    static let category = "SPSDK"
    static var standard: OSLogger { OSLogger() }
    private let logger: SPLogger

    static var defaultLevel: SPLogLevel { 
        SPLogLevel(rawValue:
            Bundle.main.object(forInfoDictionaryKey: "SPLogLevel") as? String ??
         Bundle.framework.object(forInfoDictionaryKey: "SPLogLevel") as? String ??
         "prod"
    ) ?? .prod}

    private init (level: SPLogLevel? = Self.defaultLevel) {
        if level == .prod {
            logger = NoopLogger()
        } else if #available(iOS 12.0, tvOS 12.0, *) {
            logger = ModernishLogger()
        } else {
            logger = LegacyLogger()
        }
    }

    func begin(_ name: StaticString) {
        logger.begin(name)
    }

    func end(_ name: StaticString) {
        logger.end(name)
    }

    func end(_ name: StaticString, _ args: CVarArg...) {
        logger.end(name, args)
    }

    func event(_ name: StaticString) {
        logger.event(name)
    }

    func event(_ name: StaticString, _ args: CVarArg...) {
        logger.event(name, args)
    }

    func log(_ message: String) {
        logger.log(message)
    }

    func debug(_ message: String) {
        logger.debug(message)
    }

    func error(_ message: String) {
        logger.error(message)
    }
}
