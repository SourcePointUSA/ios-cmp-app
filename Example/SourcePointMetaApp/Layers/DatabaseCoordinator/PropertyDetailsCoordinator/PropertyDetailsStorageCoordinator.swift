//
//  PropertyDetailsCoordinator.swift
//  SourcepointMetaApp
//
//  Created by Vilas on 3/22/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import Foundation
import CoreData

class PropertyDetailsStorageCoordinator : BaseStorageCoordinator {
    
    //// MARK: - Instance Methods
    // It Fetches all property details from the database
    // -Parameters:
    //  - executionCompletionHandler: Completion handler; it takes array of all properties to caller.
    func fetchAllproperties(executionCompletionHandler: @escaping([PropertyDetails]?) -> Void) {
        let managedObjectContext = self.managedObjectContext
        
        managedObjectContext.perform {
            let dbManager = DBManager.sharedManager
            
            let timestampDescriptor = NSSortDescriptor(key: "creationTimestamp", ascending: false)
            dbManager.fetchEntities(PropertyDetails.entityName, sortDescriptors: [timestampDescriptor], predicate: nil, managedObjectContext: managedObjectContext, completion: { (propertyDetails) in
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
        
        let managedObjectContext = self.managedObjectContext
        managedObjectContext.perform {
            let dbManager = DBManager.sharedManager
            dbManager.fetchEntity(withManagedObjectID: propertyManagedObjectID, managedObjectContext: managedObjectContext) { (optionalManagedObject) in
                if let propertyManagedObject = optionalManagedObject as? PropertyDetails {
                    handler(propertyManagedObject)
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
            dbManager.fetchEntity(PropertyDetails.entityName, sortDescriptors: nil, predicate: nil, managedObjectContext: managedObjectContext, completion: { (optionalManagedObject) in
                handler((optionalManagedObject?.objectID)!)
            })
        }
    }
    
    /// It add new property in the storage.
    ///
    /// - Parameters:
    ///   - propertyDataModel: propertyData Model.
    ///   - handler: Callback for the completion event.
    func add(propertyDetails propertyDataModel : PropertyDetailsModel,targetingParams:[TargetingParamModel], completionHandler handler: @escaping (NSManagedObjectID?, Bool) -> Void) {
        
        let managedObjectContext = self.managedObjectContext
        let creationTimestamp = Date()
        
        if let propertyEntity = NSEntityDescription.insertNewObject(forEntityName: PropertyDetails.entityName, into: managedObjectContext) as? PropertyDetails {
            propertyEntity.accountId = propertyDataModel.accountId
            propertyEntity.propertyId = propertyDataModel.propertyId
            propertyEntity.propertyName = propertyDataModel.propertyName
            propertyEntity.campaign = propertyDataModel.campaign
            propertyEntity.privacyManagerId = propertyDataModel.privacyManagerId
            propertyEntity.creationTimestamp = creationTimestamp
            if let authId = propertyDataModel.authId {
                propertyEntity.authId = authId
            }
            
            for targetingParam in targetingParams {
                if let targteingParamEntity = NSEntityDescription.insertNewObject(forEntityName: TargetingParams.entityName, into: managedObjectContext) as? TargetingParams {
                    targteingParamEntity.key = targetingParam.targetingKey
                    targteingParamEntity.value = targetingParam.targetingValue
                    propertyEntity.addToManyTargetingParams(targteingParamEntity)
                }
            }
            
            let dbManager = DBManager.sharedManager
            // Pushing managed object context changes in database.
            dbManager.save(managedObjectContext: managedObjectContext, completion: { (executionStatus, wasMOCChanged) in
                if executionStatus == wasMOCChanged {
                    handler(propertyEntity.objectID,true)
                } else {
                    handler(nil,false)
                }
            })
        } else {
            handler(nil,false)
        }
    }
    
    /// It updates existing property details.
    ///
    /// - Parameters:
    ///   - propertyDataModel: property Data Model.
    ///   - managedObjectID: managedObjectID of existing property entity.
    ///   - handler: Callback for the completion event.
    func update(propertyDetails propertyDataModel : PropertyDetailsModel, targetingParams: [TargetingParamModel], whereManagedObjectID managedObjectID : NSManagedObjectID, completionHandler handler : @escaping (NSManagedObjectID?, Bool) -> Void) {
        
        fetch(property: managedObjectID) { (optionalpropertyEntity) in
            if let propertyEntity = optionalpropertyEntity {
                
                let managedObjectContext = self.managedObjectContext
                let creationTimestamp = Date()
                
                //Updating property entity
                propertyEntity.accountId = propertyDataModel.accountId
                propertyEntity.propertyId = propertyDataModel.propertyId
                propertyEntity.propertyName = propertyDataModel.propertyName
                propertyEntity.campaign = propertyDataModel.campaign
                propertyEntity.privacyManagerId = propertyDataModel.privacyManagerId
                propertyEntity.creationTimestamp = creationTimestamp
                if let authId = propertyDataModel.authId {
                    propertyEntity.authId = authId
                }
                if let targetingparamsSet = propertyEntity.manyTargetingParams {
                    propertyEntity.removeFromManyTargetingParams(targetingparamsSet)
                }
                
                for targetingParam in targetingParams {
                    if let targteingParamEntity = NSEntityDescription.insertNewObject(forEntityName: TargetingParams.entityName, into: managedObjectContext) as? TargetingParams {
                        targteingParamEntity.key = targetingParam.targetingKey
                        targteingParamEntity.value = targetingParam.targetingValue
                        propertyEntity.addToManyTargetingParams(targteingParamEntity)
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
                handler(nil,false)
            }
        }
    }
    
    /// It deletes property from the database permanently.
    ///
    /// - Parameters:
    ///   - propertyManagedObject: property ManagedObject.
    ///   - handler: Callback for the completion event. Callback has execution status(success/failure) as argument.
    func delete(property propertyManagedObject: NSManagedObject, completionHandler handler : @escaping (Bool) -> Void) {
        
        let managedObjectContext = self.managedObjectContext
        let dbManager = DBManager.sharedManager
        managedObjectContext.perform {
            dbManager.deleteEntity(propertyManagedObject, usingMOC: managedObjectContext)
            dbManager.save(managedObjectContext: managedObjectContext, completion: { (executionStatus, wasMOCChanged) in
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
    func  checkExitanceOfData(propertyDetails propertyDataModel : PropertyDetailsModel, targetingParams: [TargetingParamModel], completionHandler handler : @escaping (Bool) -> Void) {
        
        var subPredicates : [NSPredicate] = []
        var subPredicate : NSPredicate
        if let authId = propertyDataModel.authId {
            subPredicate = NSPredicate(format: "accountId == \(propertyDataModel.accountId) AND propertyId == \(propertyDataModel.propertyId) AND campaign == \(propertyDataModel.campaign) AND privacyManagerId == %@ AND authId == %@", propertyDataModel.privacyManagerId!,authId)
        } else {
            subPredicate = NSPredicate(format: "accountId == \(propertyDataModel.accountId) AND propertyId == \(propertyDataModel.propertyId) AND campaign == \(propertyDataModel.campaign) AND privacyManagerId == %@", propertyDataModel.privacyManagerId!)
        }
        
        subPredicates.append(subPredicate)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: PropertyDetails.entityName)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: subPredicates)
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            if results.count > 0 {
                var storedTargetingParamArray = [TargetingParamModel]()
                var ispropertyDataStored = false
                for result in results as! [PropertyDetails] {
                    if let targetingParamItem = result.manyTargetingParams?.allObjects as! [TargetingParams]?, targetingParamItem.count > 0 {
                        for targetingParam in targetingParamItem {
                            let targetingParamModel = TargetingParamModel(targetingParamKey: targetingParam.key, targetingParamValue: targetingParam.value)
                            storedTargetingParamArray.append(targetingParamModel)
                        }
                        if storedTargetingParamArray.count == targetingParams.count {
                            ispropertyDataStored = storedTargetingParamArray.sorted {$0.targetingKey! < $1.targetingKey!} == targetingParams.sorted{$0.targetingKey! < $1.targetingKey!}
                            storedTargetingParamArray.removeAll()
                            if ispropertyDataStored {
                                break
                            }
                        } else {
                            ispropertyDataStored = false
                            storedTargetingParamArray.removeAll()
                        }
                    } else if let storedTargetingParamItem = result.manyTargetingParams?.allObjects as! [TargetingParams]?, storedTargetingParamItem.count == 0, targetingParams.count == 0 {
                        ispropertyDataStored = true
                        storedTargetingParamArray.removeAll()
                        break
                    }
                }
                handler(ispropertyDataStored)
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
