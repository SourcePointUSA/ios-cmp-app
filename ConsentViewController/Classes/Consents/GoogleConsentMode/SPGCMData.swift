//
//  SPGCMData.swift
//  Pods
//
//  Created by Andre Herculano on 02.02.24.
//

import Foundation

public class SPGCMData: NSObject, Codable {
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

    init(adStorage: Status? = nil, analyticsStorage: Status? = nil, adUserData: Status? = nil, adPersonalization: Status? = nil) {
        self.adStorage = adStorage
        self.analyticsStorage = analyticsStorage
        self.adUserData = adUserData
        self.adPersonalization = adPersonalization
    }
}

@available(swift, obsoleted: 1.0)
extension SPGCMData {
    @objc public enum ObjcStatus: Int, CustomStringConvertible {
        case granted, denied, unset

        public var description: String {
            switch self {
                case .granted: return "SPGCMData.ObjcStatus.granted"
                case .denied: return "SPGCMData.ObjcStatus.denied"
                case .unset: return "SPGCMData.ObjcStatus.unset"
            }
        }

        init(fromStatus status: Status?) {
            switch status {
                case .granted: self = .granted
                case .denied: self = .denied
                case .none: self = .unset
            }
        }
    }

    @objc public var objcAdStorage: ObjcStatus { .init(fromStatus: adStorage) }
    @objc public var objcAnalyticsStorage: ObjcStatus { .init(fromStatus: analyticsStorage) }
    @objc public var objcAdUserData: ObjcStatus { .init(fromStatus: adUserData) }
    @objc public var objcAdPersonalization: ObjcStatus { .init(fromStatus: adPersonalization) }
}
