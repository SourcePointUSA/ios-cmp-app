//
//  SPIDFAStatus.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 09.02.21.
//

import Foundation
import AppTrackingTransparency
import AdSupport

/// TODO: Don't forget to set the NSUserTrackingUsageDescription on the apps Info.plist otherwise we can't request access to IDFA
@objc public enum SPIDFAStatus: Int, Codable, CaseIterable, CustomStringConvertible {
    /// the user hasn't been prompted about the IDFA yet
    case unknown = 0
    /// the user accepted being tracked
    case accepted = 1
    /// the user denied access to IDFA
    case denied = 2
    /// the IDFA is not available in this version of the OS
    case unavailable = 3

    public var description: String {
        switch self {
        case .unknown: return "unknown"
        case .accepted: return "accepted"
        case .denied: return "denied"
        case .unavailable: return "unavailable"
        }
    }

    @available(iOS 14, *)
    public init(fromApple status: ATTrackingManager.AuthorizationStatus) {
        switch status {
        case .authorized:
            self = .accepted
        case .denied, .restricted:
            self = .denied
        case .notDetermined:
            self = .unknown
        @unknown default:
            self = .unknown
        }
    }
}
