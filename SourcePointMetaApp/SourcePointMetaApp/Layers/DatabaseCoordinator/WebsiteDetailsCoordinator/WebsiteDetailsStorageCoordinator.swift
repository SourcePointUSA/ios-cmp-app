//
//  WebsiteDetailsCoordinator.swift
//  SourcepointMetaApp
//
//  Created by Vilas on 3/22/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import Foundation
import CoreData

class WebsiteDetailsStorageCoordinator : BaseStorageCoordinator {
    
    //// MARK: - Instance Methods
    // It Fetches all site details from the database
    // -Parameters:
    //  - executionCompletionHandler: Completion handler; it takes array of all sites to caller.
    func fetchAllSites(executionCompletionHandler: @escaping([SiteDetails]?) -> Void) {
        let managedObjectContext = self.managedObjectContext
        
        managedObjectContext.perform {
            let dbManager = DBManager.sharedManager
            
            let timestampDescriptor = NSSortDescriptor(key: "creationTimestamp", ascending: false)
            dbManager.fetchEntities(SiteDetails.entityName, sortDescriptors: [timestampDescriptor], predicate: nil, managedObjectContext: managedObjectContext, completion: { (siteDetails) in
                if let allSites = siteDetails as? [SiteDetails] {
                    executionCompletionHandler(allSites)
                } else {
                    executionCompletionHandler(nil)
                }
            })
        }
    }
    
   /// It fetch site entity from the database for provided managed object id.
    ///
    /// - Parameters:
    ///   - siteManagedObjectID: Valid managed object id.
    ///   - handler: Callback for completion event.
    func fetch(site siteManagedObjectID: NSManagedObjectID, completionHandler handler: @escaping (SiteDetails?) -> Void) {
        
        let managedObjectContext = self.managedObjectContext
        managedObjectContext.perform {
            let dbManager = DBManager.sharedManager
            dbManager.fetchEntity(withManagedObjectID: siteManagedObjectID, managedObjectContext: managedObjectContext) { (optionalManagedObject) in
                if let siteManagedObject = optionalManagedObject as? SiteDetails {
                    handler(siteManagedObject)
                } else {
                    handler(nil)
                }
            }
        }
    }
    
    func managedObjectID(completionHandler handler: @escaping (NSManagedObjectID) -> Void) {
        let managedObjectContext = self.managedObjectContext
        managedObjectContext.perform {
            let dbManager = DBManager.sharedManager
            dbManager.fetchEntity(SiteDetails.entityName, sortDescriptors: nil, predicate: nil, managedObjectContext: managedObjectContext, completion: { (optionalManagedObject) in
                handler((optionalManagedObject?.objectID)!)
            })
        }
    }
    
    /// It add new site in the storage.
    ///
    /// - Parameters:
    ///   - siteDataModel: SiteData Model.
    ///   - handler: Callback for the completion event.
    func add(siteDetails siteDataModel : SiteDetailsModel,targetingParams:[TargetingParamModel], completionHandler handler: @escaping (NSManagedObjectID?, Bool) -> Void) {
        
        let managedObjectContext = self.managedObjectContext
        let creationTimestamp = Date()
        
        if let siteEntity = NSEntityDescription.insertNewObject(forEntityName: SiteDetails.entityName, into: managedObjectContext) as? SiteDetails {
            siteEntity.accountId = siteDataModel.accountId
            siteEntity.siteId = siteDataModel.siteId
            siteEntity.siteName = siteDataModel.siteName
            siteEntity.campaign = siteDataModel.campaign
            siteEntity.privacyManagerId = siteDataModel.privacyManagerId
            siteEntity.showPM = siteDataModel.showPM
            siteEntity.creationTimestamp = creationTimestamp
            if let authId = siteDataModel.authId {
                siteEntity.authId = authId
            }
            
            for targetingParam in targetingParams {
                if let targteingParamEntity = NSEntityDescription.insertNewObject(forEntityName: TargetingParams.entityName, into: managedObjectContext) as? TargetingParams {
                    targteingParamEntity.key = targetingParam.targetingKey
                    targteingParamEntity.value = targetingParam.targetingValue
                    siteEntity.addToManyTargetingParams(targteingParamEntity)
                }
            }
            
            let dbManager = DBManager.sharedManager
            // Pushing managed object context changes in database.
            dbManager.save(managedObjectContext: managedObjectContext, completion: { (executionStatus, wasMOCChanged) in
                if executionStatus == wasMOCChanged {
                    handler(siteEntity.objectID,true)
                } else {
                    handler(nil,false)
                }
            })
        } else {
            handler(nil,false)
        }
    }
    
    /// It updates existing site details.
    ///
    /// - Parameters:
    ///   - siteDataModel: site Data Model.
    ///   - managedObjectID: managedObjectID of existing site entity.
    ///   - handler: Callback for the completion event.
    func update(siteDetails siteDataModel : SiteDetailsModel, targetingParams: [TargetingParamModel], whereManagedObjectID managedObjectID : NSManagedObjectID, completionHandler handler : @escaping (NSManagedObjectID?, Bool) -> Void) {
        
        fetch(site: managedObjectID) { (optionalSiteEntity) in
            if let siteEntity = optionalSiteEntity {
                
                let managedObjectContext = self.managedObjectContext
                let creationTimestamp = Date()
                
                //Updating site entity
                siteEntity.accountId = siteDataModel.accountId
                siteEntity.siteId = siteDataModel.siteId
                siteEntity.siteName = siteDataModel.siteName
                siteEntity.campaign = siteDataModel.campaign
                siteEntity.privacyManagerId = siteDataModel.privacyManagerId
                siteEntity.showPM = siteDataModel.showPM
                siteEntity.creationTimestamp = creationTimestamp
                if let authId = siteDataModel.authId {
                    siteEntity.authId = authId
                }
                if let targetingparamsSet = siteEntity.manyTargetingParams {
                    siteEntity.removeFromManyTargetingParams(targetingparamsSet)
                }
                
                for targetingParam in targetingParams {
                    if let targteingParamEntity = NSEntityDescription.insertNewObject(forEntityName: TargetingParams.entityName, into: managedObjectContext) as? TargetingParams {
                        targteingParamEntity.key = targetingParam.targetingKey
                        targteingParamEntity.value = targetingParam.targetingValue
                        siteEntity.addToManyTargetingParams(targteingParamEntity)
                    }
                }
                
                let dbManager = DBManager.sharedManager
                // Pushing managed object context changes in database.
                dbManager.save(managedObjectContext: managedObjectContext, completion: { (executionStatus, wasMOCChanged) in
                    if executionStatus == wasMOCChanged {
                        handler(siteEntity.objectID, true)
                    } else {
                        
                        handler(nil, false)
                    }
                })
            } else {
                handler(nil,false)
            }
        }
    }
    
    /// It deletes site from the database permanently.
    ///
    /// - Parameters:
    ///   - siteManagedObject: site ManagedObject.
    ///   - handler: Callback for the completion event. Callback has execution status(success/failure) as argument.
    func delete(site siteManagedObject: NSManagedObject, completionHandler handler : @escaping (Bool) -> Void) {
        
        let managedObjectContext = self.managedObjectContext
        let dbManager = DBManager.sharedManager
        managedObjectContext.perform {
            dbManager.deleteEntity(siteManagedObject, usingMOC: managedObjectContext)
            dbManager.save(managedObjectContext: managedObjectContext, completion: { (executionStatus, wasMOCChanged) in
                if executionStatus == wasMOCChanged {
                    handler(true)
                } else {
                    handler(false)
                }
            })
        }
    }
    
    /// It check whether site details are stored in database or not.
    ///
    /// - Parameters:
    ///   - siteDataModel: site Data Model.
    ///   - handler: Callback for the completion event.
    func  checkExitanceOfData(siteDetails siteDataModel : SiteDetailsModel, targetingParams: [TargetingParamModel], completionHandler handler : @escaping (Bool) -> Void) {
        
        var subPredicates : [NSPredicate] = []
        var subPredicate : NSPredicate
        if let authId = siteDataModel.authId {
            subPredicate = NSPredicate(format: "accountId == \(siteDataModel.accountId) AND siteId == \(siteDataModel.siteId) AND campaign == %@ AND privacyManagerId == %@ AND authId == %@ AND showPM == \(NSNumber(value: siteDataModel.showPM))", siteDataModel.campaign, siteDataModel.privacyManagerId!,authId)
        } else {
            subPredicate = NSPredicate(format: "accountId == \(siteDataModel.accountId) AND siteId == \(siteDataModel.siteId) AND campaign == %@ AND privacyManagerId == %@ AND showPM == \(NSNumber(value: siteDataModel.showPM))", siteDataModel.campaign, siteDataModel.privacyManagerId!)
        }
        
        subPredicates.append(subPredicate)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: SiteDetails.entityName)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: subPredicates)
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            if results.count > 0 {
                var storedTargetingParamArray = [TargetingParamModel]()
                var isSiteDataStored = false
                for result in results as! [SiteDetails] {
                    if let targetingParamItem = result.manyTargetingParams?.allObjects as! [TargetingParams]?, targetingParamItem.count > 0 {
                        for targetingParam in targetingParamItem {
                            let targetingParamModel = TargetingParamModel(targetingParamKey: targetingParam.key, targetingParamValue: targetingParam.value)
                            storedTargetingParamArray.append(targetingParamModel)
                        }
                        if storedTargetingParamArray.count == targetingParams.count {
                            isSiteDataStored = storedTargetingParamArray.sorted {$0.targetingKey! < $1.targetingKey!} == targetingParams.sorted{$0.targetingKey! < $1.targetingKey!}
                            storedTargetingParamArray.removeAll()
                            if isSiteDataStored {
                                break
                            }
                        } else {
                            isSiteDataStored = false
                            storedTargetingParamArray.removeAll()
                        }
                    } else if let storedTargetingParamItem = result.manyTargetingParams?.allObjects as! [TargetingParams]?, storedTargetingParamItem.count == 0, targetingParams.count == 0 {
                        isSiteDataStored = true
                        storedTargetingParamArray.removeAll()
                        break
                    }
                }
                handler(isSiteDataStored)
            }else {
                handler(false)
            }
        } catch {
            print(error)
        }
    }
}

extension TargetingParamModel: Comparable {
    
    static func < (lhs: TargetingParamModel, rhs: TargetingParamModel) -> Bool {
        if let lhsTargetingKey = lhs.targetingKey, let rhsTargetingKey = rhs.targetingKey {
        return lhsTargetingKey < rhsTargetingKey ||
            (lhs.targetingKey == rhs.targetingKey && lhsTargetingKey < rhsTargetingKey)
        }
        return false
    }
    
    static func == (lhs: TargetingParamModel, rhs: TargetingParamModel) -> Bool {
        return lhs.targetingKey == rhs.targetingKey &&
            lhs.targetingValue == rhs.targetingValue
    }
}
