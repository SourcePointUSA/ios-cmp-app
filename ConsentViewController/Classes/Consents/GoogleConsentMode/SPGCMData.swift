//
//  SPGCMData.swift
//  Pods
//
//  Created by Andre Herculano on 02.02.24.
//

import Foundation

@objcMembers public class SPGCMData: NSObject, Codable {
    /// Mimics Firebase's Analytics ConsentStatus enums
    @objc public enum Status: Int, Hashable, Equatable, RawRepresentable, Codable {
        public typealias RawValue = String

        case granted, denied

        public var rawValue: String {
            switch self {
                case .granted: return "granted"
                case .denied: return "denied"
            }
        }

        public init?(rawValue: String) {
            switch rawValue {
                case "granted": self = .granted
                case "denied": self = .denied
                default: return nil
            }
        }
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
