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

    // MARK: - Instance properties
    //// Reference to storage coordinator. it interacts with the database.
    private var storageCoordinator: PropertyDetailsStorageCoordinator = PropertyDetailsStorageCoordinator()

    var countries = ["BrowserDefault", "English", "Bulgarian", "Catalan", "Chinese", "Croatian", "Czech", "Danish", "Dutch", "Estonian", "Finnish", "French", "Gaelic", "German", "Greek", "Hungarian", "Icelandic", "Italian", "Japanese", "Latvian", "Lithuanian", "Norwegian", "Polish", "Portuguese", "Romanian", "Russian", "Serbian_Cyrillic", "Serbian_Latin", "Slovakian", "Slovenian", "Spanish", "Swedish", "Turkish"]
    var pmTabs = ["Default", "Purposes", "Vendors", "Features"]
    var sections = [
        Section(campaignTitle: "Add GDPR Campaign", expanded: false),
        Section(campaignTitle: "Add CCPA Campaign", expanded: false),
        Section(campaignTitle: "Add iOS 14 Campaign", expanded: false)]

    // Will add all the targeting params to this array
    var ccpaTargetingParams = [TargetingParamModel]()
    var gdprTargetingParams = [TargetingParamModel]()
    var iOS14TargetingParams = [TargetingParamModel]()
    var allCampaigns = [CampaignModel]()

    var gdprPMID: String?
    var ccpaPMID: String?
    var gdprPMTab: String?
    var ccpaPMTab: String?

    // MARK: - Initializers
    /// Default initializer
    init() {
        gdprPMTab = pmTabs[0]
        ccpaPMTab = pmTabs[0]
    }

    /// It add property item.
    /// - Parameter completionHandler: Completion handler
    func addproperty(propertyDetails: PropertyDetailsModel, completionHandler: @escaping (SPMetaError?, Bool, NSManagedObjectID?) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            //Callback for storage coordinator
            let storageCoordinatorCallback: ((NSManagedObjectID?, Bool) -> Void) = { (managedObjectID, executionStatus) in
                if executionStatus == true {
                    DispatchQueue.main.async {
                        completionHandler(nil, true, managedObjectID)
                    }
                } else {
                    let error = SPMetaError(code: 0, description: SPLiteral.emptyString, message: Alert.messageForUnknownError)
                    DispatchQueue.main.async {
                        completionHandler(error, false, managedObjectID)
                    }
                }
            }
            // Adding new property item in the storage.
            self?.storageCoordinator.add(propertyDetails: propertyDetails, completionHandler: storageCoordinatorCallback)
        }
    }

    /// It fetch property of specific ManagedObjectID.
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

    func fetchProperty(propertyManagedObjectID: NSManagedObjectID, completionHandler: @escaping (PropertyDetailsModel) -> Void) {
        fetch(property: propertyManagedObjectID, completionHandler: {[weak self] ( propertyDataModel) in
            var campaignModels = [CampaignModel]()
            if let campaigns = propertyDataModel.manyCampaigns?.allObjects as? [CampaignDetails] {
                for campaign in campaigns {
                    var targetingParamModel = [TargetingParamModel]()
                    if let targetingParams = campaign.manyTargetingParams?.allObjects as? [TargetingParams] {
                        for targetingParam in targetingParams {
                            let targetingParam = TargetingParamModel(targetingParamKey: targetingParam.key ?? "", targetingParamValue: targetingParam.value ?? "")
                            targetingParamModel.append(targetingParam)
                        }
                    }
                    campaignModels.append(CampaignModel(campaignName: campaign.campaignName ?? "", pmID: campaign.pmID, pmTab: campaign.pmTab, targetingParams: targetingParamModel))
                    targetingParamModel.removeAll()
                }
                let propertyDetail = PropertyDetailsModel(accountId: propertyDataModel.accountId, propertyName: propertyDataModel.propertyName, campaignEnv: propertyDataModel.campaignEnv, creationTimestamp: propertyDataModel.creationTimestamp!, authId:propertyDataModel.authId , messageLanguage: propertyDataModel.messageLanguage, campaignDetails: campaignModels)
                self?.allCampaigns = campaignModels
                self?.updatePMIDAndTab(campaignModels: campaignModels)
                self?.updateCampaigns(campaignModels: campaignModels)
                completionHandler(propertyDetail)
            }
        })
    }

    func updateCampaigns(campaignModels: [CampaignModel]) {
        for campaign in campaignModels {
            if campaign.campaignName == SPLiteral.gdprCampaign {
                gdprTargetingParams = campaign.targetingParams ?? []
            } else if campaign.campaignName == SPLiteral.ccpaCampaign {
                ccpaTargetingParams = campaign.targetingParams ?? []
            }else {
                iOS14TargetingParams = campaign.targetingParams ?? []
            }
        }

    }

    func updatePMIDAndTab(campaignModels: [CampaignModel]) {
        for campaign in campaignModels {
            if campaign.campaignName == SPLiteral.gdprCampaign {
                gdprPMID = campaign.pmID
                gdprPMTab = campaign.pmTab
            } else if campaign.campaignName == SPLiteral.ccpaCampaign {
                ccpaPMID = campaign.pmID
                ccpaPMTab = campaign.pmTab
            }
        }
    }

    /// It updates existing property details.
    /// - Parameters:
    ///   - propertyDataModel: property Data Model.
    ///   - managedObjectID: managedObjectID of existing property entity.
    ///   - handler: Callback for the completion event.
    func update(propertyDetails propertyDataModel: PropertyDetailsModel, whereManagedObjectID managedObjectID: NSManagedObjectID, completionHandler handler : @escaping (NSManagedObjectID?, Bool) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.storageCoordinator.update(propertyDetails: propertyDataModel, whereManagedObjectID: managedObjectID, completionHandler: { (optionalPropertyManagedObjectID, _) in
                if let propertyManagedObjectID = optionalPropertyManagedObjectID {
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
    /// - Parameters:
    ///   - propertyDataModel: property Data Model.
    ///   - handler: Callback for the completion event.
    func  isPropertyStored(propertyDetails propertyDataModel: PropertyDetailsModel, completionHandler handler : @escaping (Bool) -> Void) {

        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.storageCoordinator.checkExitanceOfData(propertyDetails: propertyDataModel, completionHandler: { (optionalPropertyManagedObject) in
                DispatchQueue.main.async {
                    handler(optionalPropertyManagedObject)
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
    func validatepropertyDetails (accountID: String?, propertyName: String?) -> Bool {

        if accountID!.count > 0  && propertyName!.count > 0 {
            return true
        } else {
            return false
        }
    }

    func getPMTab(pmTab: String) -> SPPrivacyManagerTab {
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

    func getMessageLanguage(countryName: String) -> SPMessageLanguage {
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

    func resetFields(cell: CampaignTableViewCell, section: Int) {
        if section == 0 {
            cell.privacyManagerTextField.text = gdprPMID
            cell.pmTabTextField.text = gdprPMTab
        }else if section == 1 {
            cell.privacyManagerTextField.text = ccpaPMID
            cell.pmTabTextField.text = ccpaPMTab
        } else {
            cell.privacyManagerTextField.text = ""
            cell.pmTabTextField.text = pmTabs[0]
        }
        cell.targetingParamKeyTextfield.text = ""
        cell.targetingParamValueTextField.text = ""
    }

    func showPrivacyManagerDetails(cell: CampaignTableViewCell) {
        cell.pmIDLabel.isHidden = false
        cell.pmTabLabel.isHidden = false
        cell.privacyManagerTextField.isHidden = false
        cell.pmTabTextField.isHidden = false
        cell.pmTabButton.isHidden = false
        cell.targetingParamTopConstraint.constant = 110
    }

    func hidePrivacyManagerDetails(cell: CampaignTableViewCell) {
        cell.pmIDLabel.isHidden = true
        cell.pmTabLabel.isHidden = true
        cell.privacyManagerTextField.isHidden = true
        cell.pmTabTextField.isHidden = true
        cell.pmTabButton.isHidden = true
        cell.targetingParamTopConstraint.constant = 10
    }

    func hidePMDetailsForIOS14Campaign(campaignName: String, cell: CampaignListCell) {
        if campaignName == SPLiteral.iOS14Campaign {
            cell.pmIDLabel.isHidden = true
            cell.pmTabLabel.isHidden = true
            cell.targetingParamTopConstraint.constant = 10
        }else {
            cell.pmIDLabel.isHidden = false
            cell.pmTabLabel.isHidden = false
            cell.targetingParamTopConstraint.constant = 70
        }
    }

    func getIndexPath(sender: SourcePointUItablewViewCell, tableview: UITableView) -> IndexPath? {
        let cellPosition: CGPoint = sender.convert(sender.bounds.origin, to: tableview)
        let indexPath = tableview.indexPathForRow(at: cellPosition)
        return indexPath
    }

    func gdprCampaign() -> SPCampaign {
        var targetingParams = SPTargetingParams()
        for targetingParam in gdprTargetingParams {
            targetingParams[targetingParam.targetingKey] = targetingParam.targetingValue
        }
        return SPCampaign(targetingParams: targetingParams)
    }

    func ccpaCampaign() -> SPCampaign {
        var targetingParams = SPTargetingParams()
        for targetingParam in ccpaTargetingParams {
            targetingParams[targetingParam.targetingKey] = targetingParam.targetingValue
        }
        return SPCampaign(targetingParams: targetingParams)
    }

    func iOS14Campaign() -> SPCampaign {
        var targetingParams = SPTargetingParams()
        for targetingParam in iOS14TargetingParams {
            targetingParams[targetingParam.targetingKey] = targetingParam.targetingValue
        }
        return SPCampaign(targetingParams: targetingParams)
    }
}
