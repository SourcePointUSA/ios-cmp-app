//
//  SPDeviceManager.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 23.12.20.
//

import Foundation
import UIKit

protocol SPDeviceManager {
    var osVersion: String { get }
    var deviceFamily: String { get }
}

struct SPDevice: SPDeviceManager {
    static var standard: SPDevice { SPDevice() }

    /// Returns the Version of the OS. E.g 1.2
    /// - SeeAlso: UIDevice.current.systemVersion
    var osVersion: String {
        UIDevice.current.systemVersion
    }

    /// Tries to get the device family from its unix. If none can be found it returns `apple-unknown`.
    /// Example: iphone-11.5
    var deviceFamily: String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
            return simulatorModelIdentifier
        }

        var sysinfo = utsname()
        uname(&sysinfo)
        let deviceModel = String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)?.trimmingCharacters(in: .controlCharacters)

        return deviceModel ?? "apple-unknown"
    }
}
