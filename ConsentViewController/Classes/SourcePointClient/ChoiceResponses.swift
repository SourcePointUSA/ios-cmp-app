//
//  ChoiceResponses.swift
//  Pods
//
//  Created by Andre Herculano on 17.10.22.
//

import Foundation

struct GDPRChoiceResponse: Decodable, Equatable {
    let uuid: String
    let dateCreated: SPDateCreated
    let TCData: SPJson?
}

struct CCPAChoiceResponse: Decodable, Equatable {
    let uuid: String
    let dateCreated: SPDateCreated
}
