//
//  DidomiEventTypeExt.swift
//  Pods
//
//  Created by Andre Herculano on 26/08/2026.
//

import Didomi
import Foundation

typealias DidomiEventType = EventType

extension DidomiEventType: @retroactive CustomStringConvertible {
    public var description: String {
        switch self {
        case .ready: return ".ready"
        case .showNotice: return ".showNotice"
        case .hideNotice: return ".hideNotice"
        case .showPreferences: return ".showPreferences"
        case .hidePreferences: return ".hidePreferences"
        case .noticeClickAgree: return ".noticeClickAgree"
        case .preferencesClickAgreeToAll: return ".preferencesClickAgreeToAll"
        case .preferencesClickAgreeToAllVendors: return ".preferencesClickAgreeToAllVendors"
        case .preferencesClickAgreeToAllPurposes: return ".preferencesClickAgreeToAllPurposes"
        case .noticeClickDisagree: return ".noticeClickDisagree"
        case .preferencesClickDisagreeToAll: return ".preferencesClickDisagreeToAll"
        case .preferencesClickDisagreeToAllVendors: return ".preferencesClickDisagreeToAllVendors"
        case .preferencesClickDisagreeToAllPurposes: return ".preferencesClickDisagreeToAllPurposes"
        case .preferencesClickSaveChoices: return ".preferencesClickSaveChoices"
        case .preferencesClickVendorSaveChoices: return ".preferencesClickVendorSaveChoices"
        case .noticeClickMoreInfo: return ".noticeClickMoreInfo"
        case .noticeClickViewVendors: return ".noticeClickViewVendors"
        case .consentChanged: return ".consentChanged"
        case .integrationError: return ".error"
        case .noticeClickPrivacyPolicy: return ".noticeClickPrivacyPolicy"
        case .preferencesClickResetAllPurposes: return ".preferencesClickResetAllPurposes"
        case .preferencesClickPurposeAgree: return ".preferencesClickPurposeAgree"
        case .preferencesClickPurposeDisagree: return ".preferencesClickPurposeDisagree"
        case .preferencesClickCategoryAgree: return ".preferencesClickCategoryAgree"
        case .preferencesClickCategoryDisagree: return ".preferencesClickCategoryDisagree"
        case .preferencesClickViewVendors: return ".preferencesClickViewVendors"
        case .preferencesClickViewPurposes: return ".preferencesClickViewPurposes"
        case .preferencesClickVendorAgree: return ".preferencesClickVendorAgree"
        case .preferencesClickVendorDisagree: return ".preferencesClickVendorDisagree"
        case .syncUserChanged: return ".syncUserChanged"
        case .syncDone: return ".syncDone"
        case .syncReady: return ".syncReady"
        case .syncError: return ".syncError"
        case .languageUpdated: return ".languageUpdated"
        case .languageUpdateFailed: return ".languageUpdateFailed"
        case .noticeClickViewSPIPurposes: return ".noticeClickViewSPIPurposes"
        case .preferencesClickViewSPIPurposes: return ".preferencesClickViewSPIPurposes"
        case .preferencesClickSPIPurposeAgree: return ".preferencesClickSPIPurposeAgree"
        case .preferencesClickSPIPurposeDisagree: return ".preferencesClickSPIPurposeDisagree"
        case .preferencesClickSPICategoryAgree: return ".preferencesClickSPICategoryAgree"
        case .preferencesClickSPICategoryDisagree: return ".preferencesClickSPICategoryDisagree"
        case .preferencesClickSPIPurposeSaveChoices: return ".preferencesClickSPIPurposeSaveChoices"
        case .dcsSignatureReady: return ".dcsSignatureReady"
        case .dcsSignatureError: return ".dcsSignatureError"
        case .consentChangedWithObject: return ".consentChangedWithObject"
        case .onConsentUIReady: return ".onConsentUIReady"
        case .onConsentUIFinished: return ".onConsentUIFinished"
        @unknown default: return "unknownDidomiEvent"
        }
    }
}
