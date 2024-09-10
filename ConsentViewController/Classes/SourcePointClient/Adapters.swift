//
//  Adapters.swift
//  Pods
//
//  Created by Andre Herculano on 10/9/24.
//

import Foundation
import SPMobileCore

// swiftlint:disable force_unwrapping

extension SPDate {
    init(string: String) {
        originalDateString = string
        date = Self.format.date(from: originalDateString) ?? Date()
    }
}

extension MetaDataQueryParam {
    func toCore() -> MetaDataRequest.Campaigns {
        .init(
            gdpr: gdpr != nil ? .init(groupPmId: gdpr?.groupPmId) : nil,
            usnat: usnat != nil ? .init(groupPmId: usnat?.groupPmId) : nil,
            ccpa: ccpa != nil ? .init(groupPmId: ccpa?.groupPmId) : nil
        )
    }
}

extension SPMobileCore.MetaDataResponse {
    func toNative() -> MetaDataResponse {
        .init(
            ccpa: ccpa != nil ? .init(
                applies: ccpa!.applies,
                sampleRate: ccpa!.sampleRate
            ) : nil,
            gdpr: gdpr != nil ? .init(
                additionsChangeDate: SPDate(string: gdpr!.additionsChangeDate),
                legalBasisChangeDate: SPDate(string: gdpr!.legalBasisChangeDate),
                vendorListId: gdpr!.vendorListId,
                childPmId: gdpr!.childPmId,
                applies: gdpr!.applies,
                sampleRate: gdpr!.sampleRate
            ) : nil,
            usnat: usnat != nil ? .init(
                vendorListId: usnat!.vendorListId,
                additionsChangeDate: SPDate(string: usnat!.additionsChangeDate),
                applies: usnat!.applies,
                sampleRate: usnat!.sampleRate,
                applicableSections: usnat!.applicableSections.map { Int(truncating: $0) }
            ) : nil
        )
    }
}

// swiftlint:enable force_unwrapping
