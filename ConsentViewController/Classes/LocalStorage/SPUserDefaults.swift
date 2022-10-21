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

    static let LOCAL_STATE_KEY = "\(SP_KEY_PREFIX)localState"
    static let USER_DATA_KEY = "\(SP_KEY_PREFIX)userData"
    static let IAB_CMP_SDK_ID_KEY = "\(IAB_KEY_PREFIX)CmpSdkID"
    static let IAB_CMP_SDK_ID = 6
    static let GDPR_CHILD_PM_ID_KEY = "\(SPUserDefaults.SP_KEY_PREFIX)GDPRchildPmId"
    static let CCPA_CHILD_PM_ID_KEY = "\(SPUserDefaults.SP_KEY_PREFIX)CCPAchildPmId"

    static let SP_STATE_KEY = "\(SPUserDefaults.SP_KEY_PREFIX)state"

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

    var localState: SPJson? {
        get { storage.object(ofType: SPJson.self, forKey: SPUserDefaults.LOCAL_STATE_KEY) }
        set { storage.setObject(newValue, forKey: SPUserDefaults.LOCAL_STATE_KEY) }
    }

    var gdprChildPmId: String? {
        get { storage.string(forKey: SPUserDefaults.GDPR_CHILD_PM_ID_KEY) }
        set { storage.set(newValue, forKey: SPUserDefaults.GDPR_CHILD_PM_ID_KEY) }
    }

    var ccpaChildPmId: String? {
        get { storage.string(forKey: SPUserDefaults.CCPA_CHILD_PM_ID_KEY) }
        set { storage.set(newValue, forKey: SPUserDefaults.CCPA_CHILD_PM_ID_KEY) }
    }

    var spState: SourcepointClientCoordinator.State {
        get {
            storage.object(
                ofType: SourcepointClientCoordinator.State.self,
                forKey: SPUserDefaults.SP_STATE_KEY
            ) ?? .init()
        }
        set { storage.setObject(newValue, forKey: SPUserDefaults.SP_STATE_KEY) }
    }

    required init(storage: Storage = UserDefaults.standard) {
        self.storage = storage
    }

    func dictionaryRepresentation() -> [String: Any?] {[
        SPUserDefaults.USER_DATA_KEY: userData,
        SPUserDefaults.US_PRIVACY_STRING_KEY: usPrivacyString,
        SPUserDefaults.LOCAL_STATE_KEY: localState
    ].merging(tcfData ?? [:]) { item, _ in item }}

    func clear() {
        localState = nil
        tcfData = [:]
        usPrivacyString = ""
        userData = SPUserData()
        gdprChildPmId = nil
        ccpaChildPmId = nil
    }
}
