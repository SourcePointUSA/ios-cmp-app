//
//  AddPropertyViewModel.swift
//  SourcepointMetaApp
//
//  Created by Vilas on 24/03/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import Foundation
import CoreData
import ConsentViewController

class AddPropertyViewModel {
    
    //// Reference to storage coordinator. it interacts with the database.
    private var storageCoordinator : PropertyDetailsStorageCoordinator = PropertyDetailsStorageCoordinator()
    
    // MARK: - Initializers
    
    /// Default initializer
    init() {
    }
    
    /// It add property item.
    ///
    /// - Parameter completionHandler: Completion handler
    func addproperty(propertyDetails : PropertyDetailsModel,targetingParams:[TargetingParamModel], completionHandler: @escaping (SPError?, Bool, NSManagedObjectID?) -> Void) {

        DispatchQueue.global(qos: .userInteractive).async { [weak self] in

            //Callback for storage coordinator
            let storageCoordinatorCallback : ((NSManagedObjectID?, Bool) -> Void) = { (managedObjectID, executionStatus) in

                if executionStatus == true {
                    DispatchQueue.main.async {
                        completionHandler(nil, true, managedObjectID)
                    }
                } else {
                    let error = SPError(code: 0, description: SPLiteral.emptyString, message: Alert.messageForUnknownError)
                    DispatchQueue.main.async {
                        completionHandler(error, false, managedObjectID)
                    }
                }
            }

            // Adding new property item in the storage.
            self?.storageCoordinator.add(propertyDetails: propertyDetails, targetingParams: targetingParams, completionHandler: storageCoordinatorCallback)
        }
    }
    
    /// It fetch property of specific ManagedObjectID.
    ///
    /// - Parameters:
    ///   - propertyManagedObjectID: property Managed Object ID.
    ///   - handler: Callback for the completion event.
    func fetch(property propertyManagedObjectID : NSManagedObjectID, completionHandler handler: @escaping (PropertyDetails) -> Void) {
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
    
    /// It updates existing property details.
    ///
    /// - Parameters:
    ///   - propertyDataModel: property Data Model.
    ///   - managedObjectID: managedObjectID of existing property entity.
    ///   - handler: Callback for the completion event.
    func update(propertyDetails propertyDataModel : PropertyDetailsModel, targetingParams: [TargetingParamModel], whereManagedObjectID managedObjectID : NSManagedObjectID, completionHandler handler : @escaping (NSManagedObjectID?, Bool) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.storageCoordinator.update(propertyDetails: propertyDataModel,targetingParams: targetingParams, whereManagedObjectID: managedObjectID, completionHandler:{ (optionalpropertyManagedObjectID, executionStatus) in
                if let propertyManagedObjectID = optionalpropertyManagedObjectID {
                    DispatchQueue.main.async {
                        handler(propertyManagedObjectID, true)
                    }
                } else {
                    handler(nil, false)
                }
            })
        }
    }
    
    /// It check whether property details are stored in database or not.
    ///
    /// - Parameters:
    ///   - propertyDataModel: property Data Model.
    ///   - handler: Callback for the completion event.
    func  checkExitanceOfData(propertyDetails propertyDataModel : PropertyDetailsModel,targetingParams: [TargetingParamModel], completionHandler handler : @escaping (Bool) -> Void) {
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.storageCoordinator.checkExitanceOfData(propertyDetails: propertyDataModel, targetingParams: targetingParams, completionHandler: { (optionalpropertyManagedObject) in
                DispatchQueue.main.async {
                    handler(optionalpropertyManagedObject)
                }
            })
        }
    }
    
    /// It will clear all the userDefaultData
    func clearUserDefaultsData() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
    
    /// MARK: Validate property details
    ///
    /// - Parameter
    func validatepropertyDetails (accountID : String?, propertyId:String?, property: String?, privacyManagerId: String?) -> Bool {
        
        if accountID!.count > 0 && propertyId!.count > 0 && property!.count > 0 && privacyManagerId!.count > 0 {
            return true
        }else {
            return false
        }
    }
}
