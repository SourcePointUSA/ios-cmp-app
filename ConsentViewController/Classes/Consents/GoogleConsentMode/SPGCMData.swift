//
//  SPGCMData.swift
//  Pods
//
//  Created by Andre Herculano on 02.02.24.
//

import Foundation

public struct SPGCMData: Codable, Equatable {
    /// Mimics Firebase's Analytics ConsentStatus enums
    public enum Status: String, Hashable, Equatable, Codable {
        case granted, denied
    }

    enum CodingKeys: String, CodingKey {
        case adStorage = "ad_storage"
        case analyticsStorage = "analytics_storage"
        case adUserData = "ad_user_data"
        case adPersonalization = "ad_personalization"
    }

    public let adStorage, analyticsStorage, adUserData, adPersonalization: Status?
}

@available(swift, obsoleted: 1.0)
@objcMembers public class SPGCMDataObjc: NSObject {
    @objc(SPGCMDataObjc_ObjcStatus)
    public enum ObjcStatus: Int, CustomStringConvertible {
        case granted, denied, unset

        public var description: String {
            switch self {
                case .granted: return "SPGCMData_ObjcStatus.granted"
                case .denied: return "SPGCMData_ObjcStatus.denied"
                case .unset: return "SPGCMData_ObjcStatus.unset"
            }
        }

        init(from status: SPGCMData.Status?) {
            switch status {
                case .none: self = .unset
                case .granted: self = .granted
                case .denied: self = .denied
            }
        }
    }

    public let adStorage, analyticsStorage, adUserData, adPersonalization: ObjcStatus

    public init(from gcmData: SPGCMData?) {
        adStorage = .init(from: gcmData?.adStorage)
        analyticsStorage = .init(from: gcmData?.analyticsStorage)
        adUserData = .init(from: gcmData?.adUserData)
        adPersonalization = .init(from: gcmData?.adPersonalization)
    }
}
