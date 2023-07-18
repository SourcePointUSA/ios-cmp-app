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
        let additionsChangeDate: SPDateCreated
        let legalBasisChangeDate: SPDateCreated
        let version: Int
        let _id: String
        let childPmId: String?
        let applies: Bool
        let sampleRate: Float
    }

    let ccpa: CCPA?
    let gdpr: GDPR?
}

struct MetaDataBodyRequest: QueryParamEncodable {
    struct Campaign: Encodable {
        let groupPmId: String?
        let hasLocalData: Bool
        let dateCreated: SPDateCreated?
        let uuid: String?
    }

    let gdpr, ccpa: Campaign?
}
