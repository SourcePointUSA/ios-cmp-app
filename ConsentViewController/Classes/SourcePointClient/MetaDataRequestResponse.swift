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
        let version: Int
        let _id: String
        let childPmId: String?
        let applies: Bool
        let sampleRate: Float
    }
    struct USNat: Decodable, Equatable {
        let _id: String
        let additionsChangeDate: SPDate
        let applies: Bool
        let sampleRate: Float
        let version: Int // TODO: ask Dan T if we should care about version
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
