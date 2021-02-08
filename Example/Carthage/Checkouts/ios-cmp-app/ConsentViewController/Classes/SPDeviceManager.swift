//
//  SPDeviceManager.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 23.12.20.
//

import Foundation
import UIKit

protocol SPDeviceManager {
    func osVersion () -> String
    func deviceFamily () -> String
}

struct SPDevice: SPDeviceManager {
    /// Returns the Version of the OS. E.g 1.2
    /// - SeeAlso: UIDevice.current.systemVersion
    func osVersion() -> String {
        return UIDevice.current.systemVersion
    }

    /// Tries to get the device family from its unix. If none can be found it returns `apple-unknown`.
    /// Example: iphone-11.5
    func deviceFamily() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
            return simulatorModelIdentifier
        }

        var sysinfo = utsname()
        uname(&sysinfo)
        let deviceModel = String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)?.trimmingCharacters(in: .controlCharacters)

        return deviceModel ?? "apple-unknown"
    }
}
