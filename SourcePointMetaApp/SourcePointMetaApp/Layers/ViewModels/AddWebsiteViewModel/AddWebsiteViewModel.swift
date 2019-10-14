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
    
    // Website Managed object ID, it is default set to nil
    private var websiteManagedObjectID : NSManagedObjectID?
    
    /// It is reference to Website entity.
    var websiteEntity : WebsiteDetails?
    
    // MARK: - Initializers
    
    /// Default initializer
    init() {
    }
    
    /// It add website item.
    ///
    /// - Parameter completionHandler: Completion handler
    func addWebsite(websiteDetails : WebsiteDetailsModel,targetingParams:[TargetingParamModel], completionHandler: @escaping (SPError?, Bool, NSManagedObjectID?) -> Void) {
        
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
            
            // Adding new website item in the storage.
            self?.storageCoordinator.add(websiteDetails: websiteDetails, targetingParams: targetingParams, completionHandler: storageCoordinatorCallback)
        }
    }
    
    /// It fetch website of specific ManagedObjectID.
    ///
    /// - Parameters:
    ///   - websiteManagedObjectID: website Managed Object ID.
    ///   - handler: Callback for the completion event.
    func fetch(website websiteManagedObjectID : NSManagedObjectID, completionHandler handler: @escaping (WebsiteDetails) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.storageCoordinator.fetch(website: websiteManagedObjectID, completionHandler: { (optionalWebsiteManagedObject) in
                if let websiteManagedObject = optionalWebsiteManagedObject {
                    DispatchQueue.main.async {
                        handler(websiteManagedObject)
                    }
                }
            })
        }
    }
    
    /// It updates existing website details.
    ///
    /// - Parameters:
    ///   - websiteDataModel: Website Data Model.
    ///   - managedObjectID: managedObjectID of existing website entity.
    ///   - handler: Callback for the completion event.
    func update(websiteDetails websiteDataModel : WebsiteDetailsModel, targetingParams: [TargetingParamModel], whereManagedObjectID managedObjectID : NSManagedObjectID, completionHandler handler : @escaping (NSManagedObjectID?, Bool) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.storageCoordinator.update(websiteDetails: websiteDataModel,targetingParams: targetingParams, whereManagedObjectID: managedObjectID, completionHandler:{ (optionalWebsiteManagedObjectID, executionStatus) in
                if let websiteManagedObjectID = optionalWebsiteManagedObjectID {
                    DispatchQueue.main.async {
                        handler(websiteManagedObjectID, true)
                    }
                } else {
                    handler(nil, false)
                }
            })
        }
    }
    
    /// It check whether website details are stored in database or not.
    ///
    /// - Parameters:
    ///   - websiteDataModel: Website Data Model.
    ///   - handler: Callback for the completion event.
    func  checkExitanceOfData(websiteDetails websiteDataModel : WebsiteDetailsModel,targetingParams: [TargetingParamModel], completionHandler handler : @escaping (Bool) -> Void) {
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.storageCoordinator.checkExitanceOfData(websiteDetails: websiteDataModel, targetingParams: targetingParams, completionHandler: { (optionalWebsiteManagedObject) in
                DispatchQueue.main.async {
                    handler(optionalWebsiteManagedObject)
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
    
    /// It will call the sourcepoint SDK.
    ///
//    func buildConsentViewController(websiteDetails : WebsiteDetailsModel,targetingParams: [TargetingParamModel], completionHandler: @escaping (ConsentViewControllerError?, ConsentViewController?, Bool?, [VendorConsent]?, [PurposeConsent]?) -> Void) {
//        do {
//            
//            let consentViewController = try ConsentViewController (
//                accountId: Int(websiteDetails.accountID),
//                siteName: websiteDetails.websiteName ?? "",
//                stagingCampaign: websiteDetails.isStaging
//            )
//            // optional, set custom targeting parameters supports Strings and Integers
//            for targetingParam in targetingParams {
//                if let targetingKey = targetingParam.targetingKey, let targetingValue = targetingParam.targetingValue {
//                    consentViewController.setTargetingParam(key: targetingKey, value: targetingValue)
//                }
//            }
//            
//            consentViewController.messageTimeoutInSeconds = TimeInterval(30)
//            consentViewController.onMessageReady = { controller in
//                completionHandler(nil, controller,nil, nil, nil)
//            }
//            
//            consentViewController.onErrorOccurred = { error in
//                consentViewController.view.removeFromSuperview()
//                print(error)
//                completionHandler(error, nil, nil, nil, nil)
//            }
//            
//            consentViewController.onInteractionComplete = { cvc in
//                do {
//                    var vendorConsents = [VendorConsent]()
//                    var purposeConsents = [PurposeConsent]()
//                    for consent in try cvc.getCustomVendorConsents() {
//                        print("Custom Vendor Consent id: \(consent.id), name: \(consent.name)")
//                        vendorConsents.append(consent)
//                    }
//                    for consent in try cvc.getCustomPurposeConsents() {
//                        print("Custom Purpose Consent id: \(consent.id), name: \(consent.name)")
//                        purposeConsents.append(consent)
//                    }
//                    completionHandler(nil, nil, true, vendorConsents, purposeConsents)
//                }
//                catch {
//                    print(error)
//                    completionHandler(error as? ConsentViewControllerError, nil, nil, nil, nil)
//                }
//                cvc.view.removeFromSuperview()
//            }
//            consentViewController.loadMessage()
//            
//        } catch {
//            print(error)
//            completionHandler(error as? ConsentViewControllerError, nil, nil, nil, nil)
//        }
//    }
    
    
    /// MARK: Validate website details
    ///
    /// - Parameter
    func validateWebsiteDetails (accountID : String?, websiteName: String?) -> Bool {
        
        if (accountID?.count)! > 0 && (websiteName?.count)! > 0 {
            return true
        }else {
            return false
        }
    }
}
