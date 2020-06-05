//
//  GDPRUserDefaults.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 07.05.20.
//

import Foundation

class GDPRUserDefaults: GDPRLocalStorage {
    static public let SP_GDPR_KEY_PREFIX = "sp_gdpr_"
    static public let IAB_KEY_PREFIX = "IABTCF_"
    static let META_KEY = "\(SP_GDPR_KEY_PREFIX)meta"
    static let EU_CONSENT_KEY = "\(SP_GDPR_KEY_PREFIX)euconsent"
    static let GDPR_UUID_KEY = "\(SP_GDPR_KEY_PREFIX)consentUUID"
    static let GDPR_AUTH_ID_KEY = "\(SP_GDPR_KEY_PREFIX)authId"
    static let GDPR_USER_CONSENTS_KEY = "\(SP_GDPR_KEY_PREFIX)user_consents"
    static let IAB_CMP_SDK_ID_KEY = "\(IAB_KEY_PREFIX)CmpSdkID"
    static let IAB_CMP_SDK_ID = 6

    let storage: Storage

    var consentString: String {
        get { storage.string(forKey: GDPRUserDefaults.EU_CONSENT_KEY) ?? String() }
        set { storage.set(newValue, forKey: GDPRUserDefaults.EU_CONSENT_KEY) }
    }

    var consentUUID: GDPRUUID {
       get { storage.string(forKey: GDPRUserDefaults.GDPR_UUID_KEY) ?? String() }
       set { storage.set(newValue, forKey: GDPRUserDefaults.GDPR_UUID_KEY) }
    }

    var meta: String {
        get { storage.string(forKey: GDPRUserDefaults.META_KEY) ?? "{}" }
        set { storage.set(newValue, forKey: GDPRUserDefaults.META_KEY) }
    }

    var authId: String {
        get { storage.string(forKey: GDPRUserDefaults.GDPR_AUTH_ID_KEY) ?? String() }
        set { storage.set(newValue, forKey: GDPRUserDefaults.GDPR_AUTH_ID_KEY) }
    }

    var tcfData: [String: Any] {
        get {
            storage.dictionaryRepresentation().filter {
                $0.key.starts(with: GDPRUserDefaults.IAB_KEY_PREFIX)
            }
        }
        set {
            storage.removeObjects(forKeys: Array(tcfData.keys))
            storage.setValuesForKeys(newValue)
        }
    }

    var userConsents: GDPRUserConsent {
        get {
            storage.object(ofType: GDPRUserConsent.self, forKey: GDPRUserDefaults.GDPR_USER_CONSENTS_KEY) ?? GDPRUserConsent.empty()
        }
        set {
            tcfData = newValue.tcfData.dictionaryValue ?? [:]
            storage.setObject(newValue, forKey: GDPRUserDefaults.GDPR_USER_CONSENTS_KEY)
        }
    }

    required init(storage: Storage = UserDefaults.standard) {
        self.storage = storage
    }

    func dictionaryRepresentation() -> [String: Any?] {
        return [
            GDPRUserDefaults.EU_CONSENT_KEY: consentString,
            GDPRUserDefaults.GDPR_UUID_KEY: consentUUID,
            GDPRUserDefaults.META_KEY: meta,
            GDPRUserDefaults.GDPR_AUTH_ID_KEY: authId,
            GDPRUserDefaults.GDPR_USER_CONSENTS_KEY: userConsents
        ].merging(tcfData) { current, _ in current }
    }

    func clear() {
        userConsents = GDPRUserConsent.empty()
        tcfData = [:]
        consentString = ""
        consentUUID = ""
        authId = ""
        meta = "{}"
    }
}
