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

class OSLogger: SPLogger {
    static let TOO_MANY_ARGS_ERROR = StaticString("Cannot log messages with more than 5 argumetns")
    static let category = "GPDRConsent"

    let consentLog: OSLog?

    init(category: String) {
        if #available(iOS 10.0, *) {
            consentLog = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: category)
        } else {
            consentLog = nil
        }
    }
    
    convenience init() {
        self.init(category: OSLogger.category)
    }

    func log(_ message: String) {
        log("%s", [message])
    }

    func debug(_ message: String) {
        log("%s", [message])
    }

    func error(_ message: String) {
        log("%s", [message])
    }

    func log(_ message: StaticString, _ args: [CVarArg]) {
        if #available(iOS 10.0, *) {
            switch args.count {
                case 0: log(message)
                case 1: log(message, args[0])
                case 2: log(message, args[0], args[1])
                case 3: log(message, args[0], args[1], args[2])
                case 4: log(message, args[0], args[1], args[2], args[3])
                case 5: log(message, args[0], args[1], args[2], args[3], args[4])
                default:
                    print(OSLogger.TOO_MANY_ARGS_ERROR)
                    os_log(OSLogger.TOO_MANY_ARGS_ERROR)
            }
        } else {
            print(message)
        }
    }

    //  It's not possible to forward variadic parameters in Swift so this is a gross workaround
    @available(iOS 10.0, *)
    private func log(_ message: StaticString) {
        os_log(message, log: consentLog!, type: .default)
    }
    @available(iOS 10.0, *)
    private func log(_ message: StaticString, _ a: CVarArg) {
        os_log(message, log: consentLog!, type: .default, a)
    }
    @available(iOS 10.0, *)
    private func log(_ message: StaticString, _ a: CVarArg, _ b: CVarArg) {
        os_log(message, log: consentLog!, type: .default, a, b)
    }
    @available(iOS 10.0, *)
    private func log(_ message: StaticString, _ a: CVarArg, _ b: CVarArg, _ c: CVarArg) {
        os_log(message, log: consentLog!, type: .default, a, b, c)
    }
    @available(iOS 10.0, *)
    private func log(_ message: StaticString, _ a: CVarArg, _ b: CVarArg, _ c: CVarArg, _ d: CVarArg) {
        os_log(message, log: consentLog!, type: .default, a, b, c, d)
    }
    @available(iOS 10.0, *)
    private func log(_ message: StaticString, _ a: CVarArg, _ b: CVarArg, _ c: CVarArg, _ d: CVarArg, _ e: CVarArg) {
        os_log(message, log: consentLog!, type: .default, a, b, c, d, e)
    }
}
