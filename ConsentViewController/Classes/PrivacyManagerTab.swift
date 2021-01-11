//
//  PrivacyManagerTab.swift
//  ConsentViewController
//
//  Created by Vilas on 28/12/20.
//

import Foundation

/// Supported privacy manager tabs in PM
public enum PrivacyManagerTab: String {
    /// having it empty string instructs the rendering app to use the defult tab of PM or the pm tab specified in the "Show Options" action
    case Default = ""
    case Purposes = "purposes"
    case Vendors = "vendors"
    case Features = "features"
}
