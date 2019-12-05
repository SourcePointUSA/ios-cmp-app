//
//  ConsentViewDetailsViewController.swift
//  SourcePointMetaApp
//
//  Created by Vilas on 6/11/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import UIKit
import ConsentViewController
import CoreData
import WebKit

class ConsentViewDetailsViewController: BaseViewController, WKNavigationDelegate, ConsentDelegate {
    
    @IBOutlet weak var euConsentLabel: UILabel!
    @IBOutlet weak var consentUUIDLabel: UILabel!
    @IBOutlet weak var consentTableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    //// MARK: - Instance properties
    private let cellIdentifier = "ConsentCell"
    
    /** consentViewController is loaded or not
     */
    var consentViewControllerStatus = false
    
    // Reference to the selected property managed object ID
    var propertyManagedObjectID : NSManagedObjectID?
    
    var vendorConsents = [VendorConsent]()
    var purposeConsents = [PurposeConsent]()
    let sections = ["Vendor Consents", "Purpose Consents"]
    
    // MARK: - Initializer
    let addpropertyViewModel: AddPropertyViewModel = AddPropertyViewModel()
    
    let logger = Logger()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        consentTableView.tableFooterView = UIView(frame: .zero)
        self.navigationItem.hidesBackButton = true
        navigationSetup()
        setTableViewHidden()
        setconsentIdFromUserDefaults()
        
        if let _propertyManagedObjectID = propertyManagedObjectID {
            self.showIndicator()
            fetchDataFromDatabase(propertyManagedObjectID: _propertyManagedObjectID, completionHandler: {(propertyDetails, targetingParamsArray) in
                self.loadConsentManager(propertyDetails: propertyDetails, targetingParamsArray: targetingParamsArray)
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setconsentIdFromUserDefaults()
    }
    
    func navigationSetup() {
        
        let backIcon = UIButton(frame: CGRect.zero)
        backIcon.setImage(UIImage(named: "Back"), for: UIControl.State())
        backIcon.addTarget(self, action: #selector(back), for: UIControl.Event.touchUpInside)
        let backIconBarButton : UIBarButtonItem = UIBarButtonItem(customView: backIcon)
        backIcon.sizeToFit()
        self.navigationItem.leftBarButtonItem = backIconBarButton
    }
    
    @objc func back() {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func setTableViewHidden() {
        consentTableView.isHidden = !(vendorConsents.count > 0 || purposeConsents.count > 0)
        noDataLabel.isHidden = vendorConsents.count > 0 || purposeConsents.count > 0
    }
    
    func setconsentIdFromUserDefaults() {
        if let consentID = UserDefaults.standard.string(forKey: ConsentViewController.CONSENT_UUID_KEY),consentID.count > 0 {
            consentUUIDLabel.text = UserDefaults.standard.string(forKey: ConsentViewController.CONSENT_UUID_KEY)
            euConsentLabel.text = UserDefaults.standard.string(forKey: ConsentViewController.EU_CONSENT_KEY)
        }else {
            consentUUIDLabel.text = SPLiteral.consentUUID
            euConsentLabel.text = SPLiteral.euConsentID
        }
    }
    
    func fetchDataFromDatabase(propertyManagedObjectID : NSManagedObjectID, completionHandler: @escaping (PropertyDetailsModel, [TargetingParamModel]) -> Void)  {
        self.addpropertyViewModel.fetch(property: propertyManagedObjectID, completionHandler: {( propertyDataModel) in
            let propertyDetail = PropertyDetailsModel(accountId: propertyDataModel.accountId, propertyId: propertyDataModel.propertyId, property: propertyDataModel.property, campaign: propertyDataModel.campaign!, privacyManagerId: propertyDataModel.privacyManagerId, showPM: propertyDataModel.showPM, creationTimestamp: propertyDataModel.creationTimestamp! ,authId: propertyDataModel.authId)
            var targetingParamsArray = [TargetingParamModel]()
            if let targetingParams = propertyDataModel.manyTargetingParams?.allObjects as! [TargetingParams]? {
                for targetingParam in targetingParams {
                    let targetingParamModel = TargetingParamModel(targetingParamKey: targetingParam.key, targetingParamValue: targetingParam.value)
                    targetingParamsArray.append(targetingParamModel)
                }
            }
            completionHandler(propertyDetail, targetingParamsArray)
        })
    }
    
    func loadConsentManager(propertyDetails : PropertyDetailsModel, targetingParamsArray:[TargetingParamModel]) {
        do {
            let consentViewController = try ConsentViewController (accountId: Int(propertyDetails.accountId), propertyId: Int(propertyDetails.propertyId), property: propertyDetails.property!, PMId: propertyDetails.privacyManagerId!, campaign: propertyDetails.campaign, showPM: propertyDetails.showPM, consentDelegate: self)
            // optional, set custom targeting parameters supports Strings and Integers
            for targetingParam in targetingParamsArray {
                if let targetingKey = targetingParam.targetingKey, let targetingValue = targetingParam.targetingValue {
                    consentViewController.setTargetingParam(key: targetingKey, value: targetingValue)
                }
            }
            consentViewController.messageTimeoutInSeconds = TimeInterval(60)
            if let authId = propertyDetails.authId {
                consentViewController.loadMessage(forAuthId: authId)
            }else {
                consentViewController.loadMessage()
            }
        }catch {
            let okHandler = {
            }
            self.hideIndicator()
            AlertView.sharedInstance.showAlertView(title: Alert.message, message: error as! String, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
        }
    }
    
    func onMessageReady(controller: ConsentViewController) {
        self.hideIndicator()
        self.consentViewControllerStatus = true
        if let consentSubViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConsentSubViewController") as? ConsentSubViewController {
            consentSubViewController.consentSubViewController = controller
            self.navigationController!.pushViewController(consentSubViewController, animated: true)
        }
    }
    
    func onConsentReady(controller: ConsentViewController) {
        if consentViewControllerStatus {
            fetchConsentInfo(consentViewController: controller, completionHandler: { [weak self] (vendorConsents, purposeConsents) in
                self?.loadConsentInfoController(vendorConsents: vendorConsents, purposeConsents: purposeConsents)
            })
        }else {
            let showpropertyInfotHandler = {
                self.fetchConsentInfo(consentViewController: controller, completionHandler: { [weak self] (vendorConsents, purposeConsents) in
                    self?.refreshTableViewWithConsentInfo(vendorConsents: vendorConsents, purposeConsents: purposeConsents)
                })
            }
            let clearCookiesHandler = {
                let alertController = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
                
                alertController.setValue(SPLiteral.attributedString(), forKey: "attributedTitle")
                let noAction = UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in
                    self.fetchConsentInfo(consentViewController: controller, completionHandler: { [weak self] (vendorConsents, purposeConsents) in
                         self?.refreshTableViewWithConsentInfo(vendorConsents: vendorConsents, purposeConsents: purposeConsents)
                    })
                })
                let yesAction = UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler: { [weak self] (alert: UIAlertAction!) in
                    self?.addpropertyViewModel.clearUserDefaultsData()
                    self?.clearCookies()
                    if let _propertyManagedObjectID = self?.propertyManagedObjectID {
                        self?.showIndicator()
                        self?.fetchDataFromDatabase(propertyManagedObjectID: _propertyManagedObjectID, completionHandler: {(propertyDetails, targetingParamsArray) in
                            self?.loadConsentManager(propertyDetails: propertyDetails, targetingParamsArray: targetingParamsArray)
                        })
                    }
                    self?.hideIndicator()
                })
                alertController.addAction(noAction)
                alertController.addAction(yesAction)
                self.present(alertController, animated: true, completion: nil)
            }
            AlertView.sharedInstance.showAlertView(title: Alert.message, message: Alert.messageAlreadyShown, actions: [showpropertyInfotHandler, clearCookiesHandler], titles: [Alert.showPropertyInfo, Alert.clearCookies], actionStyle: UIAlertController.Style.alert)
            
        }
    }
    
    func onErrorOccurred(error: ConsentViewControllerError) {
        logger.log("Error: %{public}@", [error])
        self.hideIndicator()
        let okHandler = {
            self.dismiss(animated: false, completion: nil)
        }
        AlertView.sharedInstance.showAlertView(title: Alert.message, message: error.description, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
    }
    
    func fetchConsentInfo(consentViewController: ConsentViewController, completionHandler: @escaping ([VendorConsent]?, [PurposeConsent]?) -> Void) {
           var vendorConsents = [VendorConsent]()
           var purposeConsents = [PurposeConsent]()
           consentViewController.getCustomVendorConsents { [weak self] (vendors, error) in
               if let _error = error {
                   self?.onErrorOccurred(error: _error)
               }else {
                   if let vendors = vendors {
                       for consent in vendors {
                           print("Custom Vendor Consent id: \(consent.id), name: \(consent.name)")
                           vendorConsents.append(consent)
                       }
                   }
                   consentViewController.getCustomPurposeConsents { (purposes, error) in
                       if let _error = error {
                           self?.onErrorOccurred(error: _error)
                       }else {
                           if let purposes = purposes {
                               for consent in purposes {
                                   print("Custom Purpose Consent id: \(consent.id), name: \(consent.name)")
                                   purposeConsents.append(consent)
                               }
                           }
                           completionHandler(vendorConsents,purposeConsents)
                           self?.hideIndicator()
                       }
                   }
               }
           }
       }
    
    func loadConsentInfoController(vendorConsents : [VendorConsent]?, purposeConsents : [PurposeConsent]? ) {
        self.hideIndicator()
        
        if let consentViewDetailsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConsentViewDetailsViewController") as? ConsentViewDetailsViewController {
            if let _vendorConsents = vendorConsents {
                consentViewDetailsController.vendorConsents = _vendorConsents
            }
            if let _purposeConsents = purposeConsents {
                consentViewDetailsController.purposeConsents = _purposeConsents
            }
            self.navigationController?.pushViewController(consentViewDetailsController, animated: true)
        }
    }
    
    func refreshTableViewWithConsentInfo(vendorConsents : [VendorConsent]?, purposeConsents : [PurposeConsent]?) {
        if let _vendorConsents = vendorConsents {
            self.vendorConsents = _vendorConsents
        }
        if let _purposeConsents = purposeConsents {
            self.purposeConsents = _purposeConsents
        }
        self.consentTableView.reloadData()
    }
    
    func clearCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in records.forEach { record in
            WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}

//// MARK: UITableViewDataSource
extension ConsentViewDetailsViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = #colorLiteral(red: 0.2841853499, green: 0.822665453, blue: 0.653732717, alpha: 1)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        setTableViewHidden()
        if section == 0 {
            return vendorConsents.count
        }else {
            return purposeConsents.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConsentTableViewCell {
            if indexPath.section == 0 {
                cell.consentIDString.text = vendorConsents[indexPath.row].id
                cell.consentNameString.text = vendorConsents[indexPath.row].name
            } else {
                cell.consentIDString.text = purposeConsents[indexPath.row].id
                cell.consentNameString.text = purposeConsents[indexPath.row].name
            }
            return cell
        }
        return UITableViewCell()
    }
}

//// MARK: - UITableViewDelegate
extension ConsentViewDetailsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        consentTableView.deselectRow(at: indexPath, animated: false)
    }
}
