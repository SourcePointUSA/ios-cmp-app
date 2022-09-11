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
    }
    struct GDPR: Decodable, Equatable {
        let additionsChangeDate: SPDateCreated
        let getMessageAlways: Bool
        let legalBasisChangeDate: SPDateCreated
        let version: Int
        let _id: String
        let applies: Bool
    }

    let ccpa: CCPA?
    let gdpr: GDPR?
}
