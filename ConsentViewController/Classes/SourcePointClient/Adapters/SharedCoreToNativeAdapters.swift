//
//  SharedCoreToNativeAdapters.swift
//  Pods
//
//  Created by Dmytro Fedko on 13.06.2025.
//

import Foundation
import SPMobileCore

typealias CoreInvalidPropertyNameError = SPMobileCore.InvalidPropertyNameError
typealias CoreSPError = SPMobileCore.SPError

extension SPError {
    static func convertCoreError(error: NSError) -> SPError {
        switch error.kotlinException {
        case let coreInvalidPropertyNameError as CoreInvalidPropertyNameError:
            return InvalidPropertyNameError(message: coreInvalidPropertyNameError.message ?? "")

        case let coreLoadMessagesException as SPMobileCore.LoadMessagesException:
            let translated = InvalidResponseGetMessagesEndpointError()
            translated.optionalDecription = coreLoadMessagesException.causedBy?.description_ ?? InvalidResponseGetMessagesEndpointError.description()
            return translated

        case let coreReportActionException as SPMobileCore.ReportActionException:
            let translated = ReportActionError()
            translated.optionalDecription = coreReportActionException.causedBy?.description_ ?? ReportActionError.description()
            return translated

        case _ as SPMobileCore.InvalidCustomConsentUUIDError:
            return PostingCustomConsentWithoutConsentUUID()

        case let corePostCustomConsentGDPRException as SPMobileCore.PostCustomConsentGDPRException:
            let translated = InvalidResponseCustomError()
            translated.optionalDecription = corePostCustomConsentGDPRException.causedBy?.description_ ?? InvalidResponseCustomError.description()
            return translated

        case let coreDeleteCustomConsentGDPRException as SPMobileCore.DeleteCustomConsentGDPRException:
            let translated = InvalidResponseDeleteCustomError()
            translated.optionalDecription = coreDeleteCustomConsentGDPRException.causedBy?.description_ ?? InvalidResponseDeleteCustomError.description()
            return translated

        default:
            return SPError()
        }
    }
}

extension SPMobileCore.CCPAConsent.CCPAConsentStatus {
    func toNative() -> CCPAConsentStatus {
        switch name {
            case "ConsentedAll": return .ConsentedAll
            case "RejectedAll": return .RejectedAll
            case "RejectedSome": return .RejectedSome
            case "RejectedNone": return .RejectedNone
            case "LinkedNoAction": return .LinkedNoAction
            default: return .Unknown
        }
    }
}

extension SPMobileCore.USNatConsent.USNatConsentSection {
    func toNative() -> SPUSNatConsent.ConsentString {
        .init(
            sectionId: Int(sectionId),
            sectionName: sectionName,
            consentString: consentString
        )
    }
}

extension SPMobileCore.USNatConsent.USNatConsentable {
    func toNative() -> SPConsentable {
        .init(id: id, consented: consented)
    }
}

extension SPMobileCore.USNatConsent.USNatUserConsents {
    func toNative() -> SPUSNatConsent.UserConsents {
        .init(
            vendors: vendors.map { $0.toNative() },
            categories: categories.map { $0.toNative() }
        )
    }
}

extension SPMobileCore.GDPRConsent.VendorGrantsValue {
    func toNative() -> SPGDPRVendorGrant {
        .init(
            granted: vendorGrant,
            purposeGrants: purposeGrants.mapValues { $0.boolValue }
        )
    }
}

extension SPMobileCore.GDPRConsent.GCMStatus {
    func toNative() -> SPGCMData {
        .init(
            adStorage: .init(rawValue: adStorage ?? ""),
            analyticsStorage: .init(rawValue: analyticsStorage ?? ""),
            adUserData: .init(rawValue: adUserData ?? ""),
            adPersonalization: .init(rawValue: adPersonalization ?? "")
        )
    }
}

extension SPMobileCore.ConsentStatus {
    func toNative() -> ConsentStatus {
        .init(
            granularStatus: granularStatus?.toNative(),
            rejectedAny: rejectedAny?.boolValue,
            rejectedLI: rejectedLI?.boolValue,
            consentedAll: consentedAll?.boolValue,
            consentedToAll: consentedToAll?.boolValue,
            consentedToAny: consentedToAny?.boolValue,
            rejectedAll: rejectedAll?.boolValue,
            vendorListAdditions: vendorListAdditions?.boolValue,
            legalBasisChanges: legalBasisChanges?.boolValue,
            hasConsentData: hasConsentData?.boolValue
        )
    }
}

extension [String: Kotlinx_serialization_jsonJsonPrimitive] {
    func toNative() -> SPJson? {
        try? SPJson(compactMapValues { ($0.isString ? $0.content : Int($0.content) as Any) })
    }
}

extension SPMobileCore.ConsentStatus.ConsentStatusGranularStatus {
    func toNative() -> ConsentStatus.GranularStatus {
        .init(
            vendorConsent: vendorConsent,
            vendorLegInt: vendorLegInt,
            purposeConsent: purposeConsent,
            purposeLegInt: purposeLegInt,
            previousOptInAll: previousOptInAll?.boolValue,
            defaultConsent: defaultConsent?.boolValue
        )
    }
}

extension SPMobileCore.SPCampaignType {
    func toNative() -> SPCampaignType {
        switch name {
        case "Gdpr":
            return .gdpr
        case "Ccpa":
            return .ccpa
        case "UsNat":
            return .usnat
        case "IOS14":
            return .ios14
        case "Preferences":
            return .preferences
        case "GlobalCmp":
            return .globalcmp

        default:
            return .unknown
        }
    }
}

extension SPMobileCore.MessagesResponse.Message {
    func toNative(metaData: SPMobileCore.MessagesResponse.MessageMetaData) -> Message? {
        return try? Message(decoderDataString: self.encodeToJson(categoryId: metaData.categoryId, subCategoryId: metaData.subCategoryId))
    }
}

extension SPMobileCore.MessagesResponse.MessageMetaData {
    func toNative() -> MessageMetaData {
        return MessageMetaData(
            categoryId: MessageCategory(rawValue: Int(categoryId.rawValue_)) ?? .unknown,
            subCategoryId: MessageSubCategory(rawValue: Int(subCategoryId.rawValue_)) ?? .unknown,
            messageId: String(messageId),
            messagePartitionUUID: messagePartitionUUID
        )
    }
}

extension [SPMobileCore.MessageToDisplay]? {
    func toNative() -> [MessageToDisplay]? {
        return self?.map {
            // swiftlint:disable:next force_unwrapping
            MessageToDisplay(message: $0.message.toNative(metaData: $0.metaData)!,
                             metadata: $0.metaData.toNative(),
                             // swiftlint:disable:next force_unwrapping
                             url: URL(string: $0.url)!,
                             type: $0.type.toNative())
        }
    }
}
