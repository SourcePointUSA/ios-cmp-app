//
//  AddWebsiteViewModel.swift
//  SourcepointMetaApp
//
//  Created by Vilas on 24/03/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import Foundation
import CoreData
import ConsentViewController

class AddWebsiteViewModel {
    
    //// Reference to storage coordinator. it interacts with the database.
    private var storageCoordinator : WebsiteDetailsStorageCoordinator = WebsiteDetailsStorageCoordinator()
    
    // MARK: - Initializers
    
    /// Default initializer
    init() {
    }
    
    /// It add site item.
    ///
    /// - Parameter completionHandler: Completion handler
    func addSite(siteDetails : SiteDetailsModel,targetingParams:[TargetingParamModel], completionHandler: @escaping (SPError?, Bool, NSManagedObjectID?) -> Void) {

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

            // Adding new site item in the storage.
            self?.storageCoordinator.add(siteDetails: siteDetails, targetingParams: targetingParams, completionHandler: storageCoordinatorCallback)
        }
    }
    
    /// It fetch site of specific ManagedObjectID.
    ///
    /// - Parameters:
    ///   - siteManagedObjectID: site Managed Object ID.
    ///   - handler: Callback for the completion event.
    func fetch(site siteManagedObjectID : NSManagedObjectID, completionHandler handler: @escaping (SiteDetails) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.storageCoordinator.fetch(site: siteManagedObjectID, completionHandler: { (optionalSiteManagedObject) in
                if let siteManagedObject = optionalSiteManagedObject {
                    DispatchQueue.main.async {
                        handler(siteManagedObject)
                    }
                }
            })
        }
    }
    
    /// It updates existing site details.
    ///
    /// - Parameters:
    ///   - siteDataModel: Site Data Model.
    ///   - managedObjectID: managedObjectID of existing site entity.
    ///   - handler: Callback for the completion event.
    func update(siteDetails siteDataModel : SiteDetailsModel, targetingParams: [TargetingParamModel], whereManagedObjectID managedObjectID : NSManagedObjectID, completionHandler handler : @escaping (NSManagedObjectID?, Bool) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.storageCoordinator.update(siteDetails: siteDataModel,targetingParams: targetingParams, whereManagedObjectID: managedObjectID, completionHandler:{ (optionalSiteManagedObjectID, executionStatus) in
                if let siteManagedObjectID = optionalSiteManagedObjectID {
                    DispatchQueue.main.async {
                        handler(siteManagedObjectID, true)
                    }
                } else {
                    handler(nil, false)
                }
            })
        }
    }
    
    /// It check whether site details are stored in database or not.
    ///
    /// - Parameters:
    ///   - siteDataModel: site Data Model.
    ///   - handler: Callback for the completion event.
    func  checkExitanceOfData(siteDetails siteDataModel : SiteDetailsModel,targetingParams: [TargetingParamModel], completionHandler handler : @escaping (Bool) -> Void) {
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.storageCoordinator.checkExitanceOfData(siteDetails: siteDataModel, targetingParams: targetingParams, completionHandler: { (optionalSiteManagedObject) in
                DispatchQueue.main.async {
                    handler(optionalSiteManagedObject)
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
    
    /// MARK: Validate site details
    ///
    /// - Parameter
    func validateSiteDetails (accountID : String?, siteId:String?, siteName: String?, privacyManagerId: String?) -> Bool {
        
        if accountID!.count > 0 && siteId!.count > 0 && siteName!.count > 0 && privacyManagerId!.count > 0 {
            return true
        }else {
            return false
        }
    }
}
