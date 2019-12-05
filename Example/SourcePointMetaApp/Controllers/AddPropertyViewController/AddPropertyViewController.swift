//
//  AddPropertyViewController.swift
//  SourcePointMetaApp
//
//  Created by Vilas on 3/25/19.
//  Copyright © 2019 Cybage. All rights reserved.
//
 
import UIKit
import ConsentViewController
import CoreData
import WebKit

class AddPropertyViewController: BaseViewController,TargetingParamCellDelegate, UITextFieldDelegate, WKNavigationDelegate, ConsentDelegate {
    
    //// MARK: - IBOutlet
    /** UITextField outlet for account ID textField.
     */
    @IBOutlet weak var accountIDTextFieldOutlet: UITextField!
    
    /** UIScrollView outlet for scrollView.
    */
    @IBOutlet weak var scrollView: UIScrollView!
    
    /** UITextField outlet for property ID textField.
     */
    @IBOutlet weak var propertyIdTextFieldOutlet: UITextField!
    
    /** UITextField outlet for property Name textField.
    */
    @IBOutlet weak var propertyNameTextField: UITextField!
    
    /** UITextField outlet for auth Id textField.
     */
    @IBOutlet weak var authIdTextField: UITextField!
    
    /** UITextField outlet for Privacy Manager textField.
        */
    @IBOutlet weak var privacyManagerTextField: UITextField!
    
    /** UITextField outlet for targeting param key textField.
        */
    @IBOutlet weak var keyTextFieldOutlet: UITextField!
    
    /** UITextField outlet for targeting param value textField.
     */
    @IBOutlet weak var valueTextFieldOutlet: UITextField!
    
    /** UITableView outlet for targeting param values.
     */
    @IBOutlet weak var targetingParamTableview: UITableView!
    
    /** UISwitch outlet for camapign switch.
        */
    @IBOutlet weak var isStagingSwitchOutlet: UISwitch!
    
    /** UISwitch outlet for show PM switch.
           */
    @IBOutlet weak var showPMSwitchOutlet: UISwitch!
    
    /** UILabel outlet for showing No targeting param data.
    */
    @IBOutlet weak var noTargetingParamDataLabel: UILabel!
    
    /** Default campaign value is public
     */
    var campaign = "public"
    
    /** show PM directly or not
     */
    var showPM = false
    
    /** consentViewController is loaded or not
     */
    var consentViewControllerStatus = false
    
    // Reference to the selected property managed object ID
    var propertyManagedObjectID : NSManagedObjectID?
    
    //// MARK: - Instance properties
    private let cellIdentifier = "targetingParamCell"
    
    // Will add all the targeting params to this array
    var targetingParamsArray = [TargetingParamModel]()
    
    // this variable holds the property details entered by user
    var propertyDetailsModel: PropertyDetailsModel?
    
    // MARK: - Initializer
    let addpropertyViewModel: AddPropertyViewModel = AddPropertyViewModel()
    
    let logger = Logger()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountIDTextFieldOutlet.delegate = self
        propertyIdTextFieldOutlet.delegate = self
        propertyNameTextField.delegate = self
        authIdTextField.delegate = self
        privacyManagerTextField.delegate = self
        keyTextFieldOutlet.delegate = self
        valueTextFieldOutlet.delegate = self
        
        targetingParamTableview.tableFooterView = UIView(frame: .zero)
        setTableViewHidden()
                
        if let _propertyManagedObjectID = propertyManagedObjectID {
            self.title = "Edit Property"
            self.addpropertyViewModel.fetch(property: _propertyManagedObjectID, completionHandler: { [weak self] ( propertyDetailsModel) in
                
                self?.accountIDTextFieldOutlet.text = String(propertyDetailsModel.accountId)
                self?.propertyIdTextFieldOutlet.text = String(propertyDetailsModel.propertyId)
                self?.propertyNameTextField.text = propertyDetailsModel.property
                self?.privacyManagerTextField.text = propertyDetailsModel.privacyManagerId
                if let authId = propertyDetailsModel.authId {
                    self?.authIdTextField.text = authId
                }
                self?.showPMSwitchOutlet.isOn = propertyDetailsModel.showPM
                self?.isStagingSwitchOutlet.isOn = propertyDetailsModel.campaign == "stage" ? true : false
                if let targetingParams = propertyDetailsModel.manyTargetingParams?.allObjects as! [TargetingParams]? {
                    for targetingParam in targetingParams {
                        let targetingParamModel = TargetingParamModel(targetingParamKey: targetingParam.key, targetingParamValue: targetingParam.value)
                        self?.targetingParamsArray.append(targetingParamModel)
                    }
                    self?.targetingParamTableview.reloadData()
                }
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    // Set value of staging switch
    @IBAction func campaignSwitchButtonAction(_ sender: UISwitch) {
        campaign = sender.isOn ? "stage" : "public"
    }
    
    @IBAction func showPMSwitchButtonAction(_ sender: UISwitch) {
        showPM = sender.isOn
    }
    
    func setTableViewHidden() {
        targetingParamTableview.isHidden = !(targetingParamsArray.count > 0)
        noTargetingParamDataLabel.isHidden = targetingParamsArray.count > 0
    }
    
    func clearCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in records.forEach { record in
            WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    // add targeting param value to the tableview
    @IBAction func addTargetingParamAction(_ sender: Any) {

        let targetingKeyString = keyTextFieldOutlet.text?.trimmingCharacters(in: .whitespaces)
        let targetingValueString = valueTextFieldOutlet.text?.trimmingCharacters(in: .whitespaces)
        
        if targetingKeyString!.count > 0 && targetingValueString!.count > 0 {
            let targetingParamModel = TargetingParamModel(targetingParamKey: targetingKeyString, targetingParamValue: targetingValueString)
            if targetingParamsArray.count == 0 {
                targetingParamsArray.append(targetingParamModel)
            } else if targetingParamsArray.count > 0 {
                if let targetingIndex = targetingParamsArray.index(where: { $0.targetingKey == targetingKeyString}) {
                    var targetingParamModelLocal = targetingParamsArray[targetingIndex]
                    targetingParamModelLocal.targetingValue = targetingValueString
                    targetingParamsArray.remove(at: targetingIndex)
                    targetingParamsArray.insert(targetingParamModelLocal, at: targetingIndex)
                }else {
                    targetingParamsArray.append(targetingParamModel)
                }
            }
            
            keyTextFieldOutlet.text = ""
            valueTextFieldOutlet.text = ""
            targetingParamTableview.reloadData()
        }else {
            let okHandler = {
            }
            AlertView.sharedInstance.showAlertView(title: Alert.alert, message: Alert.messageForEmptyTargetingParamError, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
        }
    }
    
    func deleteButton(sender: TargetingParamCell) {
        let buttonPosition : CGPoint = sender.convert(sender.bounds.origin, to: targetingParamTableview)
        let indexPath = targetingParamTableview.indexPathForRow(at: buttonPosition)
        if let row = indexPath?.row {
            targetingParamsArray.remove(at: row)
            targetingParamTableview.reloadData()
        }
    }
    
    // save property details to database and show SP messages/PM
    @IBAction func savepropertyDetailsAction(_ sender: Any) {
        self.showIndicator()
        let accountIDString = accountIDTextFieldOutlet.text?.trimmingCharacters(in: .whitespaces)
        let propertyId = propertyIdTextFieldOutlet.text?.trimmingCharacters(in: .whitespaces)
        let property = propertyNameTextField.text?.trimmingCharacters(in: .whitespaces)
        let privacyManagerId = privacyManagerTextField.text?.trimmingCharacters(in: .whitespaces)
        let authId = authIdTextField.text?.trimmingCharacters(in: .whitespaces)
        
        if addpropertyViewModel.validatepropertyDetails(accountID: accountIDString, propertyId: propertyId, property: property, privacyManagerId: privacyManagerId) {
            guard let accountIDText = accountIDString, let accountID = Int64(accountIDText),
                let propertyIDText = propertyId, let propertyID = Int64(propertyIDText) else {
                    let okHandler = {
                    }
                    self.hideIndicator()
                    AlertView.sharedInstance.showAlertView(title: Alert.alert, message: Alert.messageForWrongAccountIdAndPropertyId, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
                    return
            }
            propertyDetailsModel = PropertyDetailsModel(accountId: accountID, propertyId: propertyID, property: property, campaign: campaign, privacyManagerId: privacyManagerId, showPM: showPM, creationTimestamp: Date(),authId: authId)
            
            if let propertyDetails = propertyDetailsModel {
                checkExitanceOfpropertyData(propertyDetails: propertyDetails)
            }
        } else {
            let okHandler = {
            }
            self.hideIndicator()
            AlertView.sharedInstance.showAlertView(title: Alert.alert, message: Alert.messageForPropertyUnavailability, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
        }
    }
    
    func checkExitanceOfpropertyData(propertyDetails : PropertyDetailsModel) {
        addpropertyViewModel.checkExitanceOfData(propertyDetails: propertyDetails, targetingParams: targetingParamsArray, completionHandler: { [weak self] (isStored) in
            if isStored {
                let okHandler = {
                }
                self?.hideIndicator()
                AlertView.sharedInstance.showAlertView(title: Alert.message, message: Alert.messageForPropertyDataStored, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
            } else {
                self?.loadConsentManager(propertyDetails: propertyDetails)
            }
        })
    }
    
    func loadConsentManager(propertyDetails : PropertyDetailsModel) {
        do {
            let consentViewController = try ConsentViewController(accountId: Int(propertyDetails.accountId), propertyId: Int(propertyDetails.propertyId), property: propertyDetails.property!, PMId: propertyDetails.privacyManagerId!, campaign: campaign, showPM: showPM, consentDelegate: self)
            // optional, set custom targeting parameters supports Strings and Integers
            for targetingParam in self.targetingParamsArray {
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
        hideIndicator()
        saveSitDataToDatabase(propertyDetailsModel: propertyDetailsModel!)
        self.consentViewControllerStatus = true
        if let consentSubViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConsentSubViewController") as? ConsentSubViewController {
            consentSubViewController.consentSubViewController = controller
            self.navigationController!.pushViewController(consentSubViewController, animated: true)
        }
    }

    func onConsentReady(controller: ConsentViewController) {
        showIndicator()
        if consentViewControllerStatus {
            fetchConsentInfo(consentViewController: controller, completionHandler: { [weak self] (vendorConsents, purposeConsents) in
                self?.loadConsentInfoController(vendorConsents: vendorConsents, purposeConsents: purposeConsents)
            })
        }else {
            let showpropertyInfotHandler = {
                self.fetchConsentInfo(consentViewController: controller, completionHandler: { [weak self] (vendorConsents, purposeConsents) in
                    self?.loadConsentInfoController(vendorConsents: vendorConsents, purposeConsents: purposeConsents)
                })
            }
            let clearCookiesHandler = {
                let alertController = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
                
                alertController.setValue(SPLiteral.attributedString(), forKey: "attributedTitle")
                let noAction = UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in
                    self.fetchConsentInfo(consentViewController: controller, completionHandler: { [weak self] (vendorConsents, purposeConsents) in
                        self?.loadConsentInfoController(vendorConsents: vendorConsents, purposeConsents: purposeConsents)
                    })
                })
                let yesAction = UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler: { [weak self] (alert: UIAlertAction!) in
                    self?.addpropertyViewModel.clearUserDefaultsData()
                    self?.clearCookies()
                    self?.savepropertyDetailsAction(AnyObject.self)
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
        let okHandler = {
            self.hideIndicator()
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
        
        if let consentViewDetailsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConsentViewDetailsViewController") as? ConsentViewDetailsViewController {
            if let _vendorConsents = vendorConsents {
                consentViewDetailsController.vendorConsents = _vendorConsents
            }
            if let _purposeConsents = purposeConsents {
                consentViewDetailsController.purposeConsents = _purposeConsents
            }
            self.navigationController?.pushViewController(consentViewDetailsController, animated: true)
        }
        self.hideIndicator()
    }
    
    // save property details to database
    func saveSitDataToDatabase(propertyDetailsModel: PropertyDetailsModel) {

        if let _propertyManagedObjectID = propertyManagedObjectID {
            addpropertyViewModel.update(propertyDetails: propertyDetailsModel, targetingParams:targetingParamsArray, whereManagedObjectID: _propertyManagedObjectID, completionHandler: {(optionalpropertyManagedObjectID, executionStatus) in
                if executionStatus {
                    Log.sharedLog.DLog(message:"property details are updated")
                }else {
                    Log.sharedLog.DLog(message:"Failed to update property details")
                }
            })
        } else {
            addpropertyViewModel.addproperty(propertyDetails: propertyDetailsModel, targetingParams: targetingParamsArray, completionHandler: { (error, _,propertyManagedObjectID) in

                if let _error = error {
                    let okHandler = {
                    }
                    AlertView.sharedInstance.showAlertView(title: Alert.message, message: _error.message, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
                } else {
                    Log.sharedLog.DLog(message:"property details are saved")
                }
            })
        }
    }
    
    //MARK: UITextField delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == accountIDTextFieldOutlet { // Switch focus to property text field
            propertyIdTextFieldOutlet.becomeFirstResponder()
        } else if textField == propertyIdTextFieldOutlet {
            propertyNameTextField.becomeFirstResponder()
        } else if textField == propertyNameTextField {
            authIdTextField.becomeFirstResponder()
        } else if textField == authIdTextField {
            privacyManagerTextField.becomeFirstResponder()
        } else if textField == privacyManagerTextField {
            keyTextFieldOutlet.becomeFirstResponder()
        } else if textField == keyTextFieldOutlet {
            valueTextFieldOutlet.becomeFirstResponder()
        } else {
            addTargetingParamAction(textField)
            textField.resignFirstResponder()
        }
        return true
    }
}

//// MARK: UITableViewDataSource
extension AddPropertyViewController : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        setTableViewHidden()
        return targetingParamsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TargetingParamCell {
            cell.delegate = self
            let targetingParamName = targetingParamsArray[indexPath.row].targetingKey! + " : " + targetingParamsArray[indexPath.row].targetingValue!
            cell.targetingParamLabel.text = targetingParamName
            return cell
        }
        return UITableViewCell()
    }
}

////// MARK: - UITableViewDelegate
extension AddPropertyViewController : UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        targetingParamTableview.deselectRow(at: indexPath, animated: false)
    }
}

