//
//  WebsiteDetailsViewModel.swift
//  SourcepointMetaApp
//
//  Created by Vilas on 24/03/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import Foundation
import CoreData

class WebsiteListViewModel {
    
    // MARK: - Properties and iVars
    
    private var sites : [SiteDetails]?
    
    var storageCoordinator : WebsiteDetailsStorageCoordinator = WebsiteDetailsStorageCoordinator()
    
    //// MARK: - Initializers
  
    /// It initialize and create WebsiteListViewModel with list of site item.
    ///
    /// - Parameter executionCompletionHandler: Callback for completion event. paramter indicates about execution status(success/failure).
    func importAllSites(executionCompletionHandler: @escaping([SiteDetails]?) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.sites?.removeAll()
            self?.storageCoordinator.fetchAllSites(executionCompletionHandler: { (_allSites) in
                self?.sites = _allSites
                DispatchQueue.main.async {
                    executionCompletionHandler(_allSites)
                }
            })
        }
    }
    
    /// It deletes site from the database permanently.
    ///
    /// - Parameters:
    ///   - siteManagedObject: site ManagedObject.
    ///   - handler: Callback for the completion event. Callback has execution status(success/failure) as argument.
    func delete(atIndex index: Int, completionHandler handler : @escaping (Bool, SPError?) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            if let _sites = self?.sites {
                let siteManagedObject = _sites[index]
                self?.storageCoordinator.delete(site: siteManagedObject, completionHandler: { (executionStatus) in
                    if executionStatus == true {
                        DispatchQueue.main.async {
                            self?.sites?.remove(at: index)
                            handler(true, nil)
                        }
                    } else {
                        let error = SPError(code: 0, description: SPLiteral.emptyString, message: Alert.messageForUnknownError)
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
    
    /// It tells about the count of site stored in the database.
    ///
    /// - Returns: site count.
    func numberOfSites() -> Int {
        if let _sites = sites {
            return _sites.count
        }
        return 0
    }
    
    /// It tells about the site details at particular index.
    ///
    /// - Parameter index: Index.
    /// - Returns: site details.
    func siteDetails(atIndex index: Int) -> (SiteDetailsModel?, String?) {
        if let _sites = sites, _sites.count > index {
            var targetingParamString = ""
            let siteDataModel = SiteDetailsModel(accountId: _sites[index].accountId, siteId: _sites[index].siteId, siteName: _sites[index].siteName, campaign: _sites[index].campaign!, privacyManagerId: _sites[index].privacyManagerId, showPM: _sites[index].showPM, creationTimestamp: _sites[index].creationTimestamp!, authId: _sites[index].authId)
            if let targetingParams = _sites[index].manyTargetingParams?.allObjects as! [TargetingParams]? {
                for targetingParam in targetingParams {
                    let targetingParamModel = TargetingParamModel(targetingParamKey: targetingParam.key, targetingParamValue: targetingParam.value)
                    targetingParamString += "\(targetingParamModel.targetingKey!) : \(targetingParamModel.targetingValue!)\n"
                }
            }
            return (siteDataModel,targetingParamString)
        }
        return (nil, nil)
    }
    
    /// It fetch and return ManagedObjectID of the site managed object. It could be useful for other managed object context.
    ///
    /// - Parameter index: site Item Index.
    /// - Returns: Managed Object ID.
    func siteManagedObjectID(atIndex index: Int) -> NSManagedObjectID? {
        if let _sites = sites, _sites.count > index {
            return _sites[index].objectID
        }
        return nil
    }
}
