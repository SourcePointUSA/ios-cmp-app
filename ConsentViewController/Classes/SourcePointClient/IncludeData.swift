//
//  IncludeData.swift
//  Pods
//
//  Created by Andre Herculano on 18.04.23.
//

import Foundation

struct IncludeData {
    static let dictionary = [
        "localState": ["type": "RecordString"],
        "TCData": ["type": "RecordString"],
        "webConsentPayload": ["type": "string"]
    ]

    static let string = "{\"TCData\":{\"type\":\"RecordString\"},\"webConsentPayload\":{\"type\":\"string\"},\"localState\":{\"type\":\"RecordString\"}}"
}
