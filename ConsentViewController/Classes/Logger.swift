//
//  Logger.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 06.10.19.
//

import Foundation
import os

@objcMembers public class Logger {
    static let TOO_MANY_ARGS_ERROR = StaticString("Cannot log messages with more than 5 argumetns")

    let consentLog: OSLog?

    public init() {
        if #available(iOS 10.0, *) {
            consentLog = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "Consent")
        } else {
            consentLog = nil
        }
    }

    public func log(_ message: StaticString, _ args: [CVarArg]) {
        if #available(iOS 10.0, *) {
            switch args.count {
                case 0: log(message)
                case 1: log(message, args[0])
                case 2: log(message, args[0], args[1])
                case 3: log(message, args[0], args[1], args[2])
                case 4: log(message, args[0], args[1], args[2], args[3])
                case 5: log(message, args[0], args[1], args[2], args[3], args[4])
                default:
                    print(Logger.TOO_MANY_ARGS_ERROR)
                    os_log(Logger.TOO_MANY_ARGS_ERROR)
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
