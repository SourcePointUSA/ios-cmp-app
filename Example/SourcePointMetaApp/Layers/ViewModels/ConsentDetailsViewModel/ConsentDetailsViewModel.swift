//
//  ConsentDetailsViewModel.swift
//  SourcePointMetaApp
//
//  Created by Vilas on 14/07/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import CoreData
import ConsentViewController

class ConsentDetailsViewModel {
    
    // MARK: - Instance properties
    //// Reference to storage coordinator. it interacts with the database.
    private var storageCoordinator: PropertyDetailsStorageCoordinator = PropertyDetailsStorageCoordinator()

    // Will add all the targeting params to this array
    var ccpaTargetingParams = [TargetingParamModel]()
    var gdprTargetingParams = [TargetingParamModel]()
    var iOS14TargetingParams = [TargetingParamModel]()

    /// It fetch property of specific ManagedObjectID.
    /// - Parameters:
    ///   - propertyManagedObjectID: property Managed Object ID.
    ///   - handler: Callback for the completion event.
    func fetch(property propertyManagedObjectID: NSManagedObjectID, completionHandler handler: @escaping (PropertyDetails) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.storageCoordinator.fetch(property: propertyManagedObjectID, completionHandler: { (optionalpropertyManagedObject) in
                if let propertyManagedObject = optionalpropertyManagedObject {
                    DispatchQueue.main.async {
                        handler(propertyManagedObject)
                    }
                }
            })
        }
    }

    func fetchPropertyFromDatabase(propertyManagedObjectID: NSManagedObjectID, completionHandler: @escaping (PropertyDetailsModel) -> Void) {
        fetch(property: propertyManagedObjectID, completionHandler: { [weak self] ( propertyDataModel) in
            var campaignModels = [CampaignModel]()
            if let campaigns = propertyDataModel.manyCampaigns?.allObjects as? [CampaignDetails] {
                for campaign in campaigns {
                    var targetingParamModel = [TargetingParamModel]()
                    if let targetingParams = campaign.manyTargetingParams?.allObjects as? [TargetingParams] {
                        for targetingParam in targetingParams {
                            let targetingParam = TargetingParamModel(targetingParamKey: targetingParam.key ?? "", targetingParamValue: targetingParam.value ?? "")
                            targetingParamModel.append(targetingParam)
                        }
                    }
                    campaignModels.append(CampaignModel(campaignName: campaign.campaignName ?? "", pmID: campaign.pmID, pmTab: campaign.pmTab, targetingParams: targetingParamModel))
                    targetingParamModel.removeAll()
                }
                let propertyDetail = PropertyDetailsModel(accountId: propertyDataModel.accountId, propertyName: propertyDataModel.propertyName, campaignEnv: propertyDataModel.campaignEnv, creationTimestamp: propertyDataModel.creationTimestamp!, authId:propertyDataModel.authId , messageLanguage: propertyDataModel.messageLanguage, campaignDetails: campaignModels)
                self?.getTargetingParams(campaignModels: campaignModels)
                completionHandler(propertyDetail)
            }
        })
    }

    func getTargetingParams(campaignModels: [CampaignModel]) {
        for campaign in campaignModels {
            if campaign.campaignName == SPLiteral.gdprCampaign {
                gdprTargetingParams = campaign.targetingParams ?? []
            } else if campaign.campaignName == SPLiteral.ccpaCampaign {
                ccpaTargetingParams = campaign.targetingParams ?? []
            }else {
                iOS14TargetingParams = campaign.targetingParams ?? []
            }
        }
    }

    func sections(userData: SPUserData?) -> [String]? {
        var sections = [String]()
        if userData?.gdpr?.applies == true {
            sections.append(SPLiteral.gdprConsents)
        }
        if userData?.ccpa?.applies == true {
            sections.append(SPLiteral.ccpaConsents)
        }
        return sections
    }

    func getPMIDAndTab(campaignName: String, campaignDetails: [CampaignModel]?) -> (pmID: String?, pmTab: String?) {
        var pmID: String?
        var pmTab: String?
        if let allCampaigns = campaignDetails {
            for campaign in allCampaigns {
                if campaign.campaignName == campaignName {
                    pmID = campaign.pmID
                    pmTab = campaign.pmTab
                }
            }
        }
        return (pmID, pmTab)
    }

    func gdprCampaign() -> SPCampaign {
        var targetingParams = SPTargetingParams()
        for targetingParam in gdprTargetingParams {
            targetingParams[targetingParam.targetingKey] = targetingParam.targetingValue
        }
        return SPCampaign(targetingParams: targetingParams)
    }

    func ccpaCampaign() -> SPCampaign {
        var targetingParams = SPTargetingParams()
        for targetingParam in ccpaTargetingParams {
            targetingParams[targetingParam.targetingKey] = targetingParam.targetingValue
        }
        return SPCampaign(targetingParams: targetingParams)
    }

    func iOS14Campaign() -> SPCampaign {
        var targetingParams = SPTargetingParams()
        for targetingParam in iOS14TargetingParams {
            targetingParams[targetingParam.targetingKey] = targetingParam.targetingValue
        }
        return SPCampaign(targetingParams: targetingParams)
    }
}
