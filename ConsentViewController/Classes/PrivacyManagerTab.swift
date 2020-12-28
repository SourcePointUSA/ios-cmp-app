//
//  PrivacyManagerTab.swift
//  ConsentViewController
//
//  Created by Vilas on 28/12/20.
//

import Foundation

/// Supported privacy manager tabs in PM
public enum PrivacyManagerTab: String, CaseIterable {
    /// having it empty string instructs the rendering app to use the defult tab of PM
    case DefaultTab = ""
    case PurposesTab = "purposes"
    case VendorsTab = "vendors"
    case FeaturesTab = "features"
}
