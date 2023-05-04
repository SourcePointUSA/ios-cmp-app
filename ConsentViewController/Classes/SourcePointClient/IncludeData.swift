//
//  IncludeData.swift
//  Pods
//
//  Created by Andre Herculano on 18.04.23.
//

// swiftlint:disable line_length

import Foundation

struct IncludeData: Encodable, Equatable {
    static let string = "{\"TCData\":{\"type\":\"RecordString\"},\"webConsentPayload\":{\"type\":\"string\"},\"localState\":{\"type\":\"RecordString\"},\"categories\":true,\"translateMessage\":true}"

    let localState = ["type": "RecordString"]
    let TCData = ["type": "RecordString"]
    let webConsentPayload = ["type": "string"]
    let categories = true
    let translateMessage = true
}
