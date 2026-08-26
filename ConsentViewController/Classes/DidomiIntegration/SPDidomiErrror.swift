//
//  SPDidomiErrror.swift
//  Pods
//
//  Created by Andre Herculano on 26/08/2026.
//

import Didomi
import Foundation

struct SPDidomiError: Error {
    var debugDescription: String?

    init(_ didomiErrorEvent: DidomiErrorEvent) {
        debugDescription = """
            DidomiErrorEvent(
                -type: \(didomiErrorEvent.type),
                -descriptionText: \(didomiErrorEvent.descriptionText)
            )
        """
    }
}
