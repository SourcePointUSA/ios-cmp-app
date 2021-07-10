//
//  SPIDFAStatus.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 09.02.21.
//

import Foundation
import AppTrackingTransparency
import AdSupport

/// Maps `ATTrackingManager.requestTrackingAuthorization` into our own enum.
/// It covers also the case when `ATTrackingManager.AuthorizationStatus` is not available.
@objc public enum SPIDFAStatus: Int, CaseIterable, CustomStringConvertible {
    /// the user hasn't been prompted about the IDFA yet
    case unknown = 0
    /// the user accepted being tracked
    case accepted = 1
    /// the user denied access to IDFA
    case denied = 2
    /// the IDFA is not available in this version of the OS
    case unavailable = 3

    /// Prompts the user to allow access to the IDFA and calls the callback with the result.
    /// If the user has already been prompted, it calls the callback with the current status.
    /// If the OS doesn't support `ATTrackingManager.requestTrackingAuthorization` it calls
    /// the callback with `.unavailable`.
    /// - Important: Don't forget to set the NSUserTrackingUsageDescription on your app's Info.plist otherwise
    ///              iOS will throw an exception when requesting access to it.
    /// - Parameters:
    ///   - handler: receives the IDFA status mapped into SPIDFAStatus
    public static func requestAuthorisation(handler: @escaping (SPIDFAStatus) -> Void) {
        if #available(iOS 14, tvOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                handler(SPIDFAStatus(fromApple: status))
            }
        } else {
            handler(.unavailable)
        }
    }

    public static func current() -> SPIDFAStatus {
        if #available(iOS 14, tvOS 14, *) {
            return SPIDFAStatus(fromApple: ATTrackingManager.trackingAuthorizationStatus)
        } else {
            return .unavailable
        }
    }

    public var description: String {
        switch self {
        case .unknown: return "unknown"
        case .accepted: return "accepted"
        case .denied: return "denied"
        case .unavailable: return "unavailable"
        }
    }

    @available(iOS 14, tvOS 14, *)
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

extension SPIDFAStatus: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .accepted: try container.encode("accepted")
        case .denied: try container.encode("denied")
        case .unknown: try container.encode("unknown")
        default:
            try container.encode("unavailable")
        }
    }
}
