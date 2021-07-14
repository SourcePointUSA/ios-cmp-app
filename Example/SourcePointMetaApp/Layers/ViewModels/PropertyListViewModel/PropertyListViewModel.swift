//
//  PropertyDetailsViewModel.swift
//  SourcepointMetaApp
//
//  Created by Vilas on 24/03/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import Foundation
import CoreData

class PropertyListViewModel {

    // MARK: - Properties and iVars

    private var properties: [PropertyDetails]?

    var storageCoordinator: PropertyDetailsStorageCoordinator = PropertyDetailsStorageCoordinator()

    // MARK: - Initializers

    /// It initialize and create PropertyListViewModel with list of property item.
    ///
    /// - Parameter executionCompletionHandler: Callback for completion event. paramter indicates about execution status(success/failure).
    func importAllproperties(executionCompletionHandler: @escaping([PropertyDetails]?) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.properties?.removeAll()
            self?.storageCoordinator.fetchAllproperties(executionCompletionHandler: { (_allproperties) in
                self?.properties = _allproperties
                DispatchQueue.main.async {
                    executionCompletionHandler(_allproperties)
                }
            })
        }
    }

    /// It deletes property from the database permanently.
    ///
    /// - Parameters:
    ///   - propertyManagedObject: property ManagedObject.
    ///   - handler: Callback for the completion event. Callback has execution status(success/failure) as argument.
    func delete(atIndex index: Int, completionHandler handler : @escaping (Bool, SPMetaError?) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            if let _properties = self?.properties {
                let propertyManagedObject = _properties[index]
                self?.storageCoordinator.delete(property: propertyManagedObject, completionHandler: { (executionStatus) in
                    if executionStatus == true {
                        DispatchQueue.main.async {
                            self?.properties?.remove(at: index)
                            handler(true, nil)
                        }
                    } else {
                        let error = SPMetaError(code: 0, description: SPLiteral.emptyString, message: Alert.messageForUnknownError)
                        DispatchQueue.main.async {
                            handler(false, error)
                        }
                    }
                })
            }
        }
    }

    /// It will clear all the userDefault Data
    func clearUserDefaultsData() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }

    /// It tells about the count of property stored in the database.
    ///
    /// - Returns: property count.
    func numberOfproperties() -> Int {
        if let _properties = properties {
            return _properties.count
        }
        return 0
    }

    /// It tells about the property details at particular index.
    ///
    /// - Parameter index: Index.
    /// - Returns: property details.
    func propertyDetails(atIndex index: Int) -> (PropertyDetailsModel?) {
        if let _properties = properties, _properties.count > index {
            var campaignModels: [CampaignModel]?
            var targetingParamModels = [TargetingParamModel]()
            if let campaigns = _properties[index].manyCampaigns?.allObjects as? [CampaignDetails] {
                for campaign in campaigns {
                    if let targetingParams = campaigns[index].manyTargetingParams?.allObjects as? [TargetingParams] {
                        for targetingParam in targetingParams {
                            let targetingParamModel = TargetingParamModel(targetingParamKey: targetingParam.key ?? "", targetingParamValue: targetingParam.value ?? "")
                            targetingParamModels.append(targetingParamModel)
                        }
                    }
                    campaignModels?.append(CampaignModel(campaignName: campaign.campaignName ?? "", pmID: campaign.pmID, pmTab: campaign.pmTab, targetingParams: targetingParamModels))
                }
                let propertyDataModel = PropertyDetailsModel(accountId: _properties[index].accountId, propertyName: _properties[index].propertyName, campaignEnv: _properties[index].campaignEnv, creationTimestamp: _properties[index].creationTimestamp!, authId: _properties[index].authId, messageLanguage: _properties[index].messageLanguage, campaignDetails: campaignModels)
                return propertyDataModel
            }
        }
        return nil
    }

    /// It fetch and return ManagedObjectID of the property managed object. It could be useful for other managed object context.
    ///
    /// - Parameter index: property Item Index.
    /// - Returns: Managed Object ID.
    func propertyManagedObjectID(atIndex index: Int) -> NSManagedObjectID? {
        if let _properties = properties, _properties.count > index {
            return _properties[index].objectID
        }
        return nil
    }
}
