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
    // It Fetches all Website details from the database
    // -Parameters:
    //  - executionCompletionHandler: Completion handler; it takes array of all websites to caller.
    func fetchAllWebsites(executionCompletionHandler: @escaping([SiteDetails]?) -> Void) {
        let managedObjectContext = self.managedObjectContext
        
        managedObjectContext.perform {
            let dbManager = DBManager.sharedManager
            
            let timestampDescriptor = NSSortDescriptor(key: "creationTimestamp", ascending: false)
            dbManager.fetchEntities(SiteDetails.entityName, sortDescriptors: [timestampDescriptor], predicate: nil, managedObjectContext: managedObjectContext, completion: { (WebsiteDetails) in
                if let allWebsites = WebsiteDetails as? [SiteDetails] {
                    executionCompletionHandler(allWebsites)
                } else {
                    executionCompletionHandler(nil)
                }
            })
        }
    }
    
    /// It fetch website entity from the database for provided managed object id.
    ///
    /// - Parameters:
    ///   - websiteManagedObjectID: Valid managed object id.
    ///   - handler: Callback for completion event.
    func fetch(website websiteManagedObjectID: NSManagedObjectID, completionHandler handler: @escaping (SiteDetails?) -> Void) {
        
        let managedObjectContext = self.managedObjectContext
        managedObjectContext.perform {
            let dbManager = DBManager.sharedManager
            dbManager.fetchEntity(withManagedObjectID: websiteManagedObjectID, managedObjectContext: managedObjectContext) { (optionalManagedObject) in
                if let websiteManagedObject = optionalManagedObject as? SiteDetails {
                    handler(websiteManagedObject)
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
    
    /// It add new website in the storage.
    ///
    /// - Parameters:
    ///   - websiteDataModel: website Data Model.
    ///   - handler: Callback for the completion event.
    func add(websiteDetails websiteDataModel : SiteDetailsModel,targetingParams:[TargetingParamModel], completionHandler handler: @escaping (NSManagedObjectID?, Bool) -> Void) {
        
        
        let managedObjectContext = self.managedObjectContext
        let creationTimestamp = NSDate()
        
        if let websiteEntity = NSEntityDescription.insertNewObject(forEntityName: SiteDetails.entityName, into: managedObjectContext) as? SiteDetails {
            websiteEntity.siteName = websiteDataModel.siteName
//            websiteEntity.accountId = websiteDataModel.accountId
            websiteEntity.creationTimestamp = creationTimestamp as Date
            
            for targetingParam in targetingParams {
                if let targteingParamEntity = NSEntityDescription.insertNewObject(forEntityName: TargetingParams.entityName, into: managedObjectContext) as? TargetingParams {
                    targteingParamEntity.key = targetingParam.targetingKey
                    targteingParamEntity.value = targetingParam.targetingValue
                    websiteEntity.addToManyTargetingParams(targteingParamEntity)
                }
            }
            
            let dbManager = DBManager.sharedManager
            // Pushing managed object context changes in database.
            dbManager.save(managedObjectContext: managedObjectContext, completion: { (executionStatus, wasMOCChanged) in
                if executionStatus == wasMOCChanged {
                    handler(websiteEntity.objectID,true)
                } else {
                    handler(nil,false)
                }
            })
        } else {
            handler(nil,false)
        }
    }
    
    /// It updates existing website details.
    ///
    /// - Parameters:
    ///   - websiteDataModel: Website Data Model.
    ///   - managedObjectID: managedObjectID of existing website entity.
    ///   - handler: Callback for the completion event.
    func update(websiteDetails websiteDataModel : SiteDetailsModel, targetingParams: [TargetingParamModel], whereManagedObjectID managedObjectID : NSManagedObjectID, completionHandler handler : @escaping (NSManagedObjectID?, Bool) -> Void) {
        
        fetch(website: managedObjectID) { (optionalWebsiteEntity) in
            if let websiteEntity = optionalWebsiteEntity {
                
                let managedObjectContext = self.managedObjectContext
                let creationTimestamp = NSDate()
                
                //Updating website entity
                websiteEntity.siteName = websiteDataModel.siteName
//                websiteEntity.accountID = websiteDataModel.accountID
                websiteEntity.creationTimestamp = creationTimestamp as Date
                if let targetingparamsSet = websiteEntity.manyTargetingParams {
                    websiteEntity.removeFromManyTargetingParams(targetingparamsSet)
                }
                
                for targetingParam in targetingParams {
                    if let targteingParamEntity = NSEntityDescription.insertNewObject(forEntityName: TargetingParams.entityName, into: managedObjectContext) as? TargetingParams {
                        targteingParamEntity.key = targetingParam.targetingKey
                        targteingParamEntity.value = targetingParam.targetingValue
                        websiteEntity.addToManyTargetingParams(targteingParamEntity)
                    }
                }
                
                let dbManager = DBManager.sharedManager
                // Pushing managed object context changes in database.
                dbManager.save(managedObjectContext: managedObjectContext, completion: { (executionStatus, wasMOCChanged) in
                    if executionStatus == wasMOCChanged {
                        handler(websiteEntity.objectID, true)
                    } else {
                        
                        handler(nil, false)
                    }
                })
            } else {
                handler(nil,false)
            }
        }
    }
    
    /// It deletes website from the database permanently.
    ///
    /// - Parameters:
    ///   - websiteManagedObject: website ManagedObject.
    ///   - handler: Callback for the completion event. Callback has execution status(success/failure) as argument.
    func delete(website websiteManagedObject: NSManagedObject, completionHandler handler : @escaping (Bool) -> Void) {
        
        let managedObjectContext = self.managedObjectContext
        let dbManager = DBManager.sharedManager
        managedObjectContext.perform {
            dbManager.deleteEntity(websiteManagedObject, usingMOC: managedObjectContext)
            dbManager.save(managedObjectContext: managedObjectContext, completion: { (executionStatus, wasMOCChanged) in
                if executionStatus == wasMOCChanged {
                    handler(true)
                } else {
                    handler(false)
                }
            })
        }
    }
    
    /// It check whether website details are stored in database or not.
    ///
    /// - Parameters:
    ///   - websiteDataModel: Website Data Model.
    ///   - handler: Callback for the completion event.
    func  checkExitanceOfData(websiteDetails websiteDataModel : SiteDetailsModel, targetingParams: [TargetingParamModel], completionHandler handler : @escaping (Bool) -> Void) {
        
        var subPredicates : [NSPredicate] = []
//        let subPredicate = NSPredicate(format: "accountID == \(websiteDataModel.accountId) AND websiteName == %@ AND isStaging == \(NSNumber(value: websiteDataModel.isStaging))", websiteDataModel.siteName!)
         let subPredicate = NSPredicate(format: "accountID == \(websiteDataModel.accountId)")
        
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
