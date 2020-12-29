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
    private var storageCoordinator: PropertyDetailsStorageCoordinator = PropertyDetailsStorageCoordinator()

    var countries = ["BrowserDefault", "English", "Bulgarian", "Catalan", "Chinese", "Croatian", "Czech", "Danish", "Dutch", "Estonian", "Finnish", "French", "Gaelic", "German", "Greek", "Hungarian", "Icelandic", "Italian", "Japanese", "Latvian", "Lithuanian", "Norwegian", "Polish", "Portuguese", "Romanian", "Russian", "Serbian_Cyrillic", "Serbian_Latin", "Slovakian", "Slovenian", "Spanish", "Swedish", "Turkish"]
    var pmTabs = ["Default", "Purposes", "Vendors", "Features"]

    // MARK: - Initializers

    /// Default initializer
    init() {
    }

    /// It add property item.
    ///
    /// - Parameter completionHandler: Completion handler
    func addproperty(propertyDetails: PropertyDetailsModel, targetingParams: [TargetingParamModel], completionHandler: @escaping (SPError?, Bool, NSManagedObjectID?) -> Void) {

        DispatchQueue.global(qos: .userInteractive).async { [weak self] in

            //Callback for storage coordinator
            let storageCoordinatorCallback: ((NSManagedObjectID?, Bool) -> Void) = { (managedObjectID, executionStatus) in

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
    func fetch(property propertyManagedObjectID: NSManagedObjectID, completionHandler handler: @escaping (PropertyDetails) -> Void) {
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
    func update(propertyDetails propertyDataModel: PropertyDetailsModel, targetingParams: [TargetingParamModel], whereManagedObjectID managedObjectID: NSManagedObjectID, completionHandler handler : @escaping (NSManagedObjectID?, Bool) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.storageCoordinator.update(propertyDetails: propertyDataModel, targetingParams: targetingParams, whereManagedObjectID: managedObjectID, completionHandler: { (optionalpropertyManagedObjectID, _) in
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
    func  checkExitanceOfData(propertyDetails propertyDataModel: PropertyDetailsModel, targetingParams: [TargetingParamModel], completionHandler handler : @escaping (Bool) -> Void) {

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

    // MARK: Validate property details
    ///
    /// - Parameter
    func validatepropertyDetails (accountID: String?, propertyId: String?, propertyName: String?, privacyManagerId: String?) -> Bool {

        if accountID!.count > 0 && propertyId!.count > 0 && propertyName!.count > 0 && privacyManagerId!.count > 0 {
            return true
        } else {
            return false
        }
    }

    func getPMTab(pmTab: String) -> PrivacyManagerTab {
        switch pmTab {
        case "Default":
            return .Default
        case "Purposes":
            return .Purposes
        case "Features":
            return .Features
        case "Vendors":
            return .Vendors
        default:
            return .Default
        }
    }

    func getMessageLanguage(countryName: String) -> MessageLanguage {
        switch countryName {
        case "BrowserDefault":
            return .BrowserDefault
        case "English":
            return .English
        case "Bulgarian":
            return .Bulgarian
        case "Catalan":
            return .Catalan
        case "Chinese":
            return .Chinese
        case "Croatian":
            return .Croatian
        case "Czech":
            return .Czech
        case "Danish":
            return .Danish
        case "Dutch":
            return .Dutch
        case "Estonian":
            return .Estonian
        case "Finnish":
            return .Finnish
        case "French":
            return .French
        case "Gaelic":
            return .Gaelic
        case "German":
            return .German
        case "Greek":
            return .Greek
        case "Hungarian":
            return .Hungarian
        case "Icelandic":
            return .Icelandic
        case "Italian":
            return .Italian
        case "Japanese":
            return .Japanese
        case "Latvian":
            return .Latvian
        case "Lithuanian":
            return .Lithuanian
        case "Norwegian":
            return .Norwegian
        case "Polish":
            return .Polish
        case "Portuguese":
            return .Portuguese
        case "Romanian":
            return .Romanian
        case "Russian":
            return .Russian
        case "Serbian_Cyrillic":
            return .Serbian_Cyrillic
        case "Serbian_Latin":
            return .Serbian_Latin
        case "Slovakian":
            return .Slovakian
        case "Slovenian":
            return .Slovenian
        case "Spanish":
            return .Spanish
        case "Swedish":
            return .Swedish
        case "Turkish":
            return .Turkish
        default:
            return .BrowserDefault
        }
    }
}
