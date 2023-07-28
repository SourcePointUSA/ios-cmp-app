//
//  SPUserDefaults.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 07.05.20.
//

import Foundation

class SPUserDefaults: SPLocalStorage {
    public static let SP_KEY_PREFIX = "sp_"
    public static let IAB_KEY_PREFIX = "IABTCF_"
    public static let GPP_KEY_PREFIX = "IABGPP_"
    public static let US_PRIVACY_STRING_KEY = "IABUSPrivacy_String"

    static let LOCAL_STATE_KEY = "\(SP_KEY_PREFIX)localState"
    static let USER_DATA_KEY = "\(SP_KEY_PREFIX)userData"
    static let GDPR_CHILD_PM_ID_KEY = "\(SP_KEY_PREFIX)GDPRchildPmId"
    static let CCPA_CHILD_PM_ID_KEY = "\(SP_KEY_PREFIX)CCPAchildPmId"

    static let SP_STATE_KEY = "\(SP_KEY_PREFIX)state"

    var storage: Storage

    var tcfData: [String: Any]? {
        get {
            storage.dictionaryRepresentation().filter {
                $0.key.starts(with: Self.IAB_KEY_PREFIX)
            }
        }
        set {
            storage.removeObjects(forKeys: Array((tcfData ?? [:]).keys))
            storage.setValuesForKeys(newValue ?? [:])
        }
    }

    var gppData: [String: Any]? {
        get {
            storage.dictionaryRepresentation().filter {
                $0.key.starts(with: Self.GPP_KEY_PREFIX)
            }
        }
        set {
            storage.removeObjects(forKeys: Array((gppData ?? [:]).keys))
            storage.setValuesForKeys(newValue ?? [:])
        }
    }

    var usPrivacyString: String? {
        get { storage.string(forKey: Self.US_PRIVACY_STRING_KEY) }
        set { storage.set(newValue, forKey: Self.US_PRIVACY_STRING_KEY) }
    }

    var userData: SPUserData {
        get {
            storage.object(
                ofType: SPUserData.self,
                forKey: Self.USER_DATA_KEY
            ) ?? SPUserData()
        }
        set {
            storage.setObject(newValue, forKey: Self.USER_DATA_KEY)
        }
    }

    var localState: SPJson? {
        get { storage.object(ofType: SPJson.self, forKey: Self.LOCAL_STATE_KEY) }
        set { storage.setObject(newValue, forKey: Self.LOCAL_STATE_KEY) }
    }

    var gdprChildPmId: String? {
        get { storage.string(forKey: Self.GDPR_CHILD_PM_ID_KEY) }
        set { storage.set(newValue, forKey: Self.GDPR_CHILD_PM_ID_KEY) }
    }

    var ccpaChildPmId: String? {
        get { storage.string(forKey: Self.CCPA_CHILD_PM_ID_KEY) }
        set { storage.set(newValue, forKey: Self.CCPA_CHILD_PM_ID_KEY) }
    }

    var spState: SourcepointClientCoordinator.State? {
        get {
            storage.object(
                ofType: SourcepointClientCoordinator.State.self,
                forKey: Self.SP_STATE_KEY
            )
        }
        set { storage.setObject(newValue, forKey: Self.SP_STATE_KEY) }
    }

    required init(storage: Storage = UserDefaults.standard) {
        self.storage = storage
    }

    func dictionaryRepresentation() -> [String: Any?] {[
        Self.USER_DATA_KEY: userData,
        Self.US_PRIVACY_STRING_KEY: usPrivacyString,
        Self.LOCAL_STATE_KEY: localState
    ].merging(tcfData ?? [:]) { item, _ in item }}

    func clear() {
        localState = nil
        tcfData = [:]
        gppData = [:]
        usPrivacyString = ""
        userData = SPUserData()
        gdprChildPmId = nil
        ccpaChildPmId = nil
        spState = nil
    }
}
