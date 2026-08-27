//
//  PurposeProvider.swift
//  ConsentViewController
//
//  Created by Claude on 27/08/2026.
//

import Didomi
import Foundation

protocol PurposeProvider {
    func getPurposes() -> [Purpose]
}

struct DidomiPurposeProvider: PurposeProvider {
    func getPurposes() -> [Purpose] {
        Didomi.shared.getRequiredPurposes()
    }
}
