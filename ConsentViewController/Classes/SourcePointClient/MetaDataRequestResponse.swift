//
//  MetaDataResponse.swift
//  ConsentViewController-iOS
//
//  Created by Fedko Dmytro on 06/09/2022.
//

import Foundation

struct MetaDataResponse: Decodable, Equatable {
    struct CCPA: Decodable, Equatable {
        let applies: Bool
        let sampleRate: Float
    }
    struct GDPR: Decodable, Equatable {
        let additionsChangeDate: SPDate
        let legalBasisChangeDate: SPDate
        let vendorListId: String
        let childPmId: String?
        let applies: Bool
        let sampleRate: Float

        enum CodingKeys: String, CodingKey {
            case additionsChangeDate, legalBasisChangeDate, applies, sampleRate, childPmId
            case vendorListId = "_id"
        }
    }
    struct USNat: Decodable, Equatable {
        let vendorListId: String
        let additionsChangeDate: SPDate
        let applies: Bool
        let sampleRate: Float

        enum CodingKeys: String, CodingKey {
            case additionsChangeDate, applies, sampleRate
            case vendorListId = "_id"
        }
    }

    let ccpa: CCPA?
    let gdpr: GDPR?
    let usnat: USNat?
}

struct MetaDataQueryParam: QueryParamEncodable {
    struct Campaign: Encodable {
        let groupPmId: String?
    }

    let gdpr, ccpa, usnat: Campaign?
}
