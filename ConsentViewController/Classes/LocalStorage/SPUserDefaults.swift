//
//  SPUserDefaults.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 07.05.20.
//

import Foundation

class SPUserDefaults: SPLocalStorage {
    static public let SP_KEY_PREFIX = "sp_"
    static public let IAB_KEY_PREFIX = "IABTCF_"
    static public let US_PRIVACY_STRING_KEY = "IABUSPrivacy_String"

    static let PROPERTY_ID = "\(SP_KEY_PREFIX)propertyId"
    static let LOCAL_STATE_KEY = "\(SP_KEY_PREFIX)localState"
    static let USER_DATA_KEY = "\(SP_KEY_PREFIX)userData"
    static let IAB_CMP_SDK_ID_KEY = "\(IAB_KEY_PREFIX)CmpSdkID"
    static let IAB_CMP_SDK_ID = 6
    public let GDPR = "GDPR"
    public let CCPA = "CCPA"

    var storage: Storage

    var propertyId: Int? {
        get {
            storage.integer(forKey: SPUserDefaults.PROPERTY_ID)
        }
        set {
            storage.set(newValue, forKey: SPUserDefaults.PROPERTY_ID)
        }
    }

    var tcfData: [String: Any]? {
        get {
            storage.dictionaryRepresentation().filter {
                $0.key.starts(with: SPUserDefaults.IAB_KEY_PREFIX)
            }
        }
        set {
            storage.removeObjects(forKeys: Array((tcfData ?? [:]).keys))
            storage.setValuesForKeys(newValue ?? [:])
        }
    }

    var usPrivacyString: String? {
        get { storage.string(forKey: SPUserDefaults.US_PRIVACY_STRING_KEY) }
        set { storage.set(newValue, forKey: SPUserDefaults.US_PRIVACY_STRING_KEY) }
    }

    var userData: SPUserData {
        get {
            storage.object(
                ofType: SPUserData.self,
                forKey: SPUserDefaults.USER_DATA_KEY
            ) ?? SPUserData()
        }
        set {
            storage.setObject(newValue, forKey: SPUserDefaults.USER_DATA_KEY)
        }
    }

    var localState: SPJson {
        get { storage.object(ofType: SPJson.self, forKey: SPUserDefaults.LOCAL_STATE_KEY) ?? SPJson() }
        set { storage.setObject(newValue, forKey: SPUserDefaults.LOCAL_STATE_KEY) }
    }

    required init(storage: Storage = UserDefaults.standard) {
        self.storage = storage
    }

    private func getChildPmIdKey(type: SPCampaignType) -> String? {
        let prefix: String?
        switch type {
        case .gdpr:
            prefix = GDPR
        case .ccpa:
            prefix = CCPA
        default:
            prefix = nil
        }
        if let prefix = prefix {
            return "\(SPUserDefaults.SP_KEY_PREFIX)\(prefix)childPmId"
        } else {
            return nil
        }
    }

    public func setChildPmId(newValue: String?, type: SPCampaignType) {
        let key = getChildPmIdKey(type: type)
        if let key = key {
            storage.set(newValue, forKey: key)
        }
    }

    public func getChildPmId(type: SPCampaignType) -> String? {
        let key = getChildPmIdKey(type: type)
        var value: String?
        if let key = key {
            value = storage.string(forKey: key)
        }
        if value == "" {
            value = nil
        }
        return value
    }

    func dictionaryRepresentation() -> [String: Any?] {[
        SPUserDefaults.USER_DATA_KEY: userData,
        SPUserDefaults.US_PRIVACY_STRING_KEY: usPrivacyString,
        SPUserDefaults.LOCAL_STATE_KEY: localState
    ].merging(tcfData ?? [:]) { item, _ in item }}

    func clear() {
        localState = SPJson()
        tcfData = [:]
        usPrivacyString = ""
        userData = SPUserData()
        propertyId = nil
        setChildPmId(newValue: nil, type: .gdpr)
        setChildPmId(newValue: nil, type: .ccpa)
    }
}
