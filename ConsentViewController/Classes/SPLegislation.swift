//
//  SPLegislation.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 22.12.20.
//

import Foundation

/// Legislations supported by Sourcepoint
enum SPLegislation: String, Codable, CaseIterable {
    /// General Data Protection Regulation
    case GDPR
    
    /// California Consumer Protection Act
    case CCPA
}
