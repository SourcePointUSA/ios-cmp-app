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
    
    private var websites : [WebsiteDetails]?
    
    var storageCoordinator : WebsiteDetailsStorageCoordinator = WebsiteDetailsStorageCoordinator()
    
    //// MARK: - Initializers
  
    /// It initialize and create WebsiteListViewModel with list of website item.
    ///
    /// - Parameter executionCompletionHandler: Callback for completion event. paramter indicates about execution status(success/failure).
    func importAllWebsites(executionCompletionHandler: @escaping([WebsiteDetails]?) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.websites?.removeAll()
            self?.storageCoordinator.fetchAllWebsites(executionCompletionHandler: { (_allWebsites) in
                self?.websites = _allWebsites
                DispatchQueue.main.async {
                    executionCompletionHandler(_allWebsites)
                }
            })
        }
    }
    
    /// It deletes website from the database permanently.
    ///
    /// - Parameters:
    ///   - websiteManagedObject: website ManagedObject.
    ///   - handler: Callback for the completion event. Callback has execution status(success/failure) as argument.
    func delete(atIndex index: Int, completionHandler handler : @escaping (Bool, SPError?) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            if let _websites = self?.websites {
                let websiteManagedObject = _websites[index]
                self?.storageCoordinator.delete(website: websiteManagedObject, completionHandler: { (executionStatus) in
                    if executionStatus == true {
                        DispatchQueue.main.async {
                            self?.websites?.remove(at: index)
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
    
    /// It tells about the count of website stored in the database.
    ///
    /// - Returns: website count.
    func numberOfWebsites() -> Int {
        if let _websites = websites {
            return _websites.count
        }
        return 0
    }
    
    /// It tells about the website name at particular index.
    ///
    /// - Parameter index: Index.
    /// - Returns: Website name.
//    func websiteDetails(atIndex index: Int) -> (SiteDetailsModel?, String?) {
//        if let _websites = websites, _websites.count > index {
//            var targetingParamString = ""
//            let websiteDataModel = SiteDetailsModel(websiteName: _websites[index].websiteName, accountID: _websites[index].accountID, creationTimestamp: _websites[index].creationTimestamp, isStaging: _websites[index].isStaging)
//            if let targetingParams = _websites[index].manyTargetingParams?.allObjects as! [TargetingParams]? {
//                for targetingParam in targetingParams {
//                    let targetingParamModel = TargetingParamModel(targetingParamKey: targetingParam.key, targetingParamValue: targetingParam.value)
//                    targetingParamString += "\(targetingParamModel.targetingKey!) : \(targetingParamModel.targetingValue!)\n"
//                }
//            }
//            return (websiteDataModel,targetingParamString)
//        }
//        return (nil, nil)
//    }
    
    /// It fetch and return ManagedObjectID of the website managed object. It could be useful for other managed object context.
    ///
    /// - Parameter index: Website Item Index.
    /// - Returns: Managed Object ID.
    func websiteManagedObjectID(atIndex index: Int) -> NSManagedObjectID? {
        if let _websites = websites, _websites.count > index {
            return _websites[index].objectID
        }
        return nil
    }
}
