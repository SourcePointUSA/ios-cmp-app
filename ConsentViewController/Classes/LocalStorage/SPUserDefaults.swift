//
//  SPUserDefaults.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 07.05.20.
//

import Foundation

/// TODO: handle data transition from v5 -> v6
class SPUserDefaults: SPLocalStorage {
    static public let SP_KEY_PREFIX = "sp_"
    static public let IAB_KEY_PREFIX = "IABTCF_"
    static public let US_PRIVACY_STRING_KEY = "IABUSPrivacy_String"

    static let LOCAL_STATE_KEY = "\(SP_KEY_PREFIX)localState"
    static let CONSENTS_PROFILE_KEY = "\(SP_KEY_PREFIX)consents_profile"
    static let IAB_CMP_SDK_ID_KEY = "\(IAB_KEY_PREFIX)CmpSdkID" /// TODO: check if we should be setting this key
    static let IAB_CMP_SDK_ID = 6

    var storage: Storage

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

    var consentsProfile: ConsentsProfile {
        get {
            storage.object(
                ofType: ConsentsProfile.self,
                forKey: SPUserDefaults.CONSENTS_PROFILE_KEY
            ) ?? ConsentsProfile()
        }
        set {
            storage.setObject(newValue, forKey: SPUserDefaults.CONSENTS_PROFILE_KEY)
        }
    }

    var localState: String {
        get { storage.string(forKey: SPUserDefaults.LOCAL_STATE_KEY) ?? "" }
        set { storage.set(newValue, forKey: SPUserDefaults.LOCAL_STATE_KEY) }
    }

    required init(storage: Storage = UserDefaults.standard) {
        self.storage = storage
    }

    func dictionaryRepresentation() -> [String: Any?] {[
        SPUserDefaults.CONSENTS_PROFILE_KEY: consentsProfile,
        SPUserDefaults.US_PRIVACY_STRING_KEY: usPrivacyString,
        SPUserDefaults.LOCAL_STATE_KEY: localState,
    ].merging(tcfData ?? [:]) { item, _ in item }}

    func clear() {
        localState = ""
        tcfData = [:]
        usPrivacyString = ""
        consentsProfile = ConsentsProfile()
    }
}
