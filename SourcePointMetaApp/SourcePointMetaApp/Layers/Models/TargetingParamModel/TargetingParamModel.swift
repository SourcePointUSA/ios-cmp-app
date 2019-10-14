//
//  TargetingParamModel.swift
//  SourcePointMetaApp
//
//  Created by Vilas on 5/27/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import Foundation

struct TargetingParamModel {
    
    //// MARK: - Instance properties
    
    /// It holds targeting key
    let targetingKey : String?
    
    /// It holds targeting value
    var targetingValue : String?
    
    //// MARK: - Initializers
    
    /// Data Model creation.
    ///
    /// - Parameters:
    ///   - targetingKey: targeting key name.
    ///   - targetingValue: targeting value.
    
    init(targetingParamKey key : String?, targetingParamValue value : String?) {
        targetingKey = key
        targetingValue = value
    }
}



