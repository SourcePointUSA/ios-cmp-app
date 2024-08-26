//
//  MetaDataResponse.swift
//  ConsentViewController-iOS
//
//  Created by Fedko Dmytro on 06/09/2022.
//

import Foundation

struct MetaDataResponse: Equatable {
    struct CCPA: Equatable {
        let applies: Bool
        let sampleRate: Float
    }
    struct GDPR: Equatable {
        let additionsChangeDate: SPDate
        let legalBasisChangeDate: SPDate?
        let vendorListId: String
        let childPmId: String?
        let applies: Bool
        let sampleRate: Float

        enum CodingKeys: String, CodingKey {
            case additionsChangeDate, legalBasisChangeDate, applies, sampleRate, childPmId
            case vendorListId = "_id"
        }
    }
    struct USNat: Equatable {
        let vendorListId: String
        let additionsChangeDate: SPDate
        let applies: Bool
        let sampleRate: Float
        let applicableSections: [Int]

        enum CodingKeys: String, CodingKey {
            case additionsChangeDate, applies, sampleRate, applicableSections
            case vendorListId = "_id"
        }
    }

    let ccpa: CCPA?
    let gdpr: GDPR?
    let usnat: USNat?
}

extension MetaDataResponse: Decodable {}
extension MetaDataResponse.GDPR: Decodable {}
extension MetaDataResponse.CCPA: Decodable {}
extension MetaDataResponse.USNat: Decodable {}

struct MetaDataQueryParam: QueryParamEncodable {
    struct Campaign: Encodable {
        let groupPmId: String?
    }

    let gdpr, ccpa, usnat: Campaign?
}
