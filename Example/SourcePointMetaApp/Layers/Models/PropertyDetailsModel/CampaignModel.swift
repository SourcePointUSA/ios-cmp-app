//
//  CampaignModel.swift
//  SourcePointMetaApp
//
//  Created by Vilas on 24/05/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import ConsentViewController

struct CampaignModel {

    // MARK: - Instance properties

    /// It holds privacy manager Id
    let campaignName: String?

    /// It holds campaign value
    let campaignEnv: Int64

    /// It holds privacy manager Id
    let privacyManagerId: String?

    /// It holds pm tab value
    let pmTab: String?

    /// It holds targetingParams value
    let targetingParams: [TargetingParamModel]?

    // MARK: - Initializers

    /// Data Model creation.
    ///
    /// - Parameters:
    ///   - campaignName: campaignName
    ///   - campaignEnv: stage/public.
    ///   - privacyManagerId: privacyManagerId which is associated with the property
    ///   - pmTab: privacyManager  tab
    ///   - targetingParams: targeting parameters
    init(campaignName: String?, campaignEnv: Int64, privacyManagerId: String?, pmTab: String?, targetingParams: [TargetingParamModel]?) {
        self.campaignName = campaignName
        self.campaignEnv = campaignEnv
        self.privacyManagerId = privacyManagerId
        self.pmTab = pmTab
        self.targetingParams = targetingParams
    }
}

