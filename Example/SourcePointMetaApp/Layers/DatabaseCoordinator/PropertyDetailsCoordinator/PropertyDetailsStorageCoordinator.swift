//
//  PropertyDetailsCoordinator.swift
//  SourcepointMetaApp
//
//  Created by Vilas on 3/22/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import Foundation
import CoreData

class PropertyDetailsStorageCoordinator: BaseStorageCoordinator {

    // MARK: - Instance Methods
    // It Fetches all property details from the database
    // -Parameters:
    //  - executionCompletionHandler: Completion handler; it takes array of all properties to caller.
    func fetchAllproperties(executionCompletionHandler: @escaping([PropertyDetails]?) -> Void) {

        managedObjectContext.perform {
            let dbManager = DBManager.sharedManager

            let timestampDescriptor = NSSortDescriptor(key: "creationTimestamp", ascending: false)
            dbManager.fetchEntities(PropertyDetails.entityName, sortDescriptors: [timestampDescriptor], predicate: nil, managedObjectContext: self.managedObjectContext, completion: { (propertyDetails) in
                if let allproperties = propertyDetails as? [PropertyDetails] {
                    executionCompletionHandler(allproperties)
                } else {
                    executionCompletionHandler(nil)
                }
            })
        }
    }

   /// It fetch property entity from the database for provided managed object id.
    ///
    /// - Parameters:
    ///   - propertyManagedObjectID: Valid managed object id.
    ///   - handler: Callback for completion event.
    func fetch(property propertyManagedObjectID: NSManagedObjectID, completionHandler handler: @escaping (PropertyDetails?) -> Void) {

        managedObjectContext.perform {
            let dbManager = DBManager.sharedManager
            dbManager.fetchEntity(withManagedObjectID: propertyManagedObjectID, managedObjectContext: self.managedObjectContext) { (optionalManagedObject) in
                if let propertyManagedObject = optionalManagedObject as? PropertyDetails {
                    handler(propertyManagedObject)
                } else {
                    handler(nil)
                }
            }
        }
    }

    func managedObjectID(completionHandler handler: @escaping (NSManagedObjectID) -> Void) {
        managedObjectContext.perform {
            let dbManager = DBManager.sharedManager
            dbManager.fetchEntity(PropertyDetails.entityName, sortDescriptors: nil, predicate: nil, managedObjectContext: self.managedObjectContext, completion: { (optionalManagedObject) in
                handler((optionalManagedObject?.objectID)!)
            })
        }
    }

    /// It add new property in the storage.
    ///
    /// - Parameters:
    ///   - propertyDataModel: propertyData Model.
    ///   - handler: Callback for the completion event.
    func add(propertyDetails propertyDataModel: PropertyDetailsModel, completionHandler handler: @escaping (NSManagedObjectID?, Bool) -> Void) {

        let creationTimestamp = Date()

        if let propertyEntity = NSEntityDescription.insertNewObject(forEntityName: PropertyDetails.entityName, into: managedObjectContext) as? PropertyDetails {
            propertyEntity.accountId = propertyDataModel.accountId
            propertyEntity.propertyName = propertyDataModel.propertyName
            propertyEntity.creationTimestamp = creationTimestamp
            propertyEntity.messageLanguage = propertyDataModel.messageLanguage
            propertyEntity.campaignEnv = propertyDataModel.campaignEnv
            if let authId = propertyDataModel.authId {
                propertyEntity.authId = authId
            }
            if let allCampaigns = propertyDataModel.campaignDetails {
                for campaign in allCampaigns {
                    if let campaignEntity = NSEntityDescription.insertNewObject(forEntityName: CampaignDetails.entityName, into: managedObjectContext) as? CampaignDetails {
                        campaignEntity.campaignName = campaign.campaignName
                        campaignEntity.pmID = campaign.pmID
                        campaignEntity.pmTab = campaign.pmTab
                        if let targetingParams = campaign.targetingParams {
                            for targetingParam in targetingParams {
                                if let targteingParamEntity = NSEntityDescription.insertNewObject(forEntityName: TargetingParams.entityName, into: managedObjectContext) as? TargetingParams {
                                    targteingParamEntity.key = targetingParam.targetingKey
                                    targteingParamEntity.value = targetingParam.targetingValue
                                    campaignEntity.addToManyTargetingParams(targteingParamEntity)
                                }
                            }
                        }
                        propertyEntity.addToManyCampaigns(campaignEntity)
                    }
                }
            }

            let dbManager = DBManager.sharedManager
            // Pushing managed object context changes in database.
            dbManager.save(managedObjectContext: managedObjectContext, completion: { (executionStatus, wasMOCChanged) in
                if executionStatus == wasMOCChanged {
                    handler(propertyEntity.objectID, true)
                } else {
                    handler(nil, false)
                }
            })
        } else {
            handler(nil, false)
        }
    }

    /// It updates existing property details.
    ///
    /// - Parameters:
    ///   - propertyDataModel: property Data Model.
    ///   - managedObjectID: managedObjectID of existing property entity.
    ///   - handler: Callback for the completion event.
    func update(propertyDetails propertyDataModel: PropertyDetailsModel, whereManagedObjectID managedObjectID: NSManagedObjectID, completionHandler handler : @escaping (NSManagedObjectID?, Bool) -> Void) {

        fetch(property: managedObjectID) { (optionalpropertyEntity) in
            if let propertyEntity = optionalpropertyEntity {
                let creationTimestamp = Date()

                //Updating property entity
                propertyEntity.accountId = propertyDataModel.accountId
                propertyEntity.propertyName = propertyDataModel.propertyName
                propertyEntity.creationTimestamp = creationTimestamp
                propertyEntity.messageLanguage = propertyDataModel.messageLanguage
                propertyEntity.campaignEnv = propertyDataModel.campaignEnv
                if let authId = propertyDataModel.authId {
                    propertyEntity.authId = authId
                }
                if let allCampaigns = propertyEntity.manyCampaigns {
                    propertyEntity.removeFromManyCampaigns(allCampaigns)
                }

                if let allCampaigns = propertyDataModel.campaignDetails {
                    for campaign in allCampaigns {
                        if let campaignEntity = NSEntityDescription.insertNewObject(forEntityName: CampaignDetails.entityName, into: self.managedObjectContext) as? CampaignDetails {
                            campaignEntity.campaignName = campaign.campaignName
                            campaignEntity.pmID = campaign.pmID
                            campaignEntity.pmTab = campaign.pmTab
                            if let targetingParams = campaign.targetingParams {
                                for targetingParam in targetingParams {
                                    if let targteingParamEntity = NSEntityDescription.insertNewObject(forEntityName: TargetingParams.entityName, into: self.managedObjectContext) as? TargetingParams {
                                        targteingParamEntity.key = targetingParam.targetingKey
                                        targteingParamEntity.value = targetingParam.targetingValue
                                        campaignEntity.addToManyTargetingParams(targteingParamEntity)
                                    }
                                }
                            }
                            propertyEntity.addToManyCampaigns(campaignEntity)
                        }
                    }
                }

                let dbManager = DBManager.sharedManager
                // Pushing managed object context changes in database.
                dbManager.save(managedObjectContext: self.managedObjectContext, completion: { (executionStatus, wasMOCChanged) in
                    if executionStatus == wasMOCChanged {
                        handler(propertyEntity.objectID, true)
                    } else {
                        handler(nil, false)
                    }
                })
            } else {
                handler(nil, false)
            }
        }
    }

    /// It deletes property from the database permanently.
    ///
    /// - Parameters:
    ///   - propertyManagedObject: property ManagedObject.
    ///   - handler: Callback for the completion event. Callback has execution status(success/failure) as argument.
    func delete(property propertyManagedObject: NSManagedObject, completionHandler handler : @escaping (Bool) -> Void) {

        let dbManager = DBManager.sharedManager
        managedObjectContext.perform {
            dbManager.deleteEntity(propertyManagedObject, usingMOC: self.managedObjectContext)
            dbManager.save(managedObjectContext: self.managedObjectContext, completion: { (executionStatus, wasMOCChanged) in
                if executionStatus == wasMOCChanged {
                    handler(true)
                } else {
                    handler(false)
                }
            })
        }
    }

    /// It check whether property details are stored in database or not.
    ///
    /// - Parameters:
    ///   - propertyDataModel: property Data Model.
    ///   - handler: Callback for the completion event.
    func  checkExitanceOfData(propertyDetails propertyDataModel: PropertyDetailsModel, completionHandler handler : @escaping (Bool) -> Void) {

        var subPredicates: [NSPredicate] = []
        var subPredicate: NSPredicate = NSPredicate()
        if let authId = propertyDataModel.authId, let propertyName = propertyDataModel.propertyName, let messageLanguage = propertyDataModel.messageLanguage {
            subPredicate = NSPredicate(format: "propertyName == %@ AND accountId == \(propertyDataModel.accountId) AND authId == %@ AND campaignEnv == \(propertyDataModel.campaignEnv) AND messageLanguage == %@", propertyName, authId, messageLanguage)
        } else if let propertyName = propertyDataModel.propertyName, let messageLanguage = propertyDataModel.messageLanguage  {
            subPredicate = NSPredicate(format: "propertyName == %@ AND accountId == \(propertyDataModel.accountId) AND campaignEnv == \(propertyDataModel.campaignEnv) AND messageLanguage == %@", propertyName, messageLanguage)
        }
        subPredicates.append(subPredicate)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: PropertyDetails.entityName)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: subPredicates)
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            if results.count > 0 {
                handler(true)
            } else {
                handler(false)
            }
        } catch {
            print(error)
        }
    }
}
