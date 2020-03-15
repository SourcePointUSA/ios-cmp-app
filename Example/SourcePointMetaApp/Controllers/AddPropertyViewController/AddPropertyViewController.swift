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

class AddPropertyViewController: BaseViewController,TargetingParamCellDelegate, UITextFieldDelegate, WKNavigationDelegate, GDPRConsentDelegate {
    
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
    
    /** UILabel outlet for showing No targeting param data.
    */
    @IBOutlet weak var noTargetingParamDataLabel: UILabel!
    
    /** Default campaign value is public
     */
    var campaign = GDPRCampaignEnv.Public
    
    // Reference to the selected property managed object ID
    var propertyManagedObjectID : NSManagedObjectID?
    
    //// MARK: - Instance properties
    private let cellIdentifier = "targetingParamCell"
    
    // Will add all the targeting params to this array
    var targetingParams = [TargetingParamModel]()
    
    // this variable holds the property details entered by user
    var propertyDetailsModel: PropertyDetailsModel?
    
    // MARK: - Initializer
    let addpropertyViewModel: AddPropertyViewModel = AddPropertyViewModel()
    var consentViewController: GDPRConsentViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldDelegate()
        targetingParamTableview.tableFooterView = UIView(frame: .zero)
        setTableViewHidden()
                
        if let _propertyManagedObjectID = propertyManagedObjectID {
            self.title = "Edit Property"
            self.addpropertyViewModel.fetch(property: _propertyManagedObjectID, completionHandler: { [weak self] ( propertyDetailsModel) in
                
                self?.accountIDTextFieldOutlet.text = String(propertyDetailsModel.accountId)
                self?.propertyIdTextFieldOutlet.text = String(propertyDetailsModel.propertyId)
                self?.propertyNameTextField.text = propertyDetailsModel.propertyName
                self?.privacyManagerTextField.text = propertyDetailsModel.privacyManagerId
                if let authId = propertyDetailsModel.authId {
                    self?.authIdTextField.text = authId
                }
                self?.isStagingSwitchOutlet.isOn = propertyDetailsModel.campaign == 0 ? true : false
                if let targetingParams = propertyDetailsModel.manyTargetingParams?.allObjects as! [TargetingParams]? {
                    for targetingParam in targetingParams {
                        let targetingParamModel = TargetingParamModel(targetingParamKey: targetingParam.key, targetingParamValue: targetingParam.value)
                        self?.targetingParams.append(targetingParamModel)
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
        campaign = sender.isOn ? GDPRCampaignEnv.Stage : GDPRCampaignEnv.Public
    }
    
    func setTableViewHidden() {
        targetingParamTableview.isHidden = !(targetingParams.count > 0)
        noTargetingParamDataLabel.isHidden = targetingParams.count > 0
    }
    
    func setTextFieldDelegate(){
        accountIDTextFieldOutlet.delegate = self
        propertyIdTextFieldOutlet.delegate = self
        propertyNameTextField.delegate = self
        authIdTextField.delegate = self
        privacyManagerTextField.delegate = self
        keyTextFieldOutlet.delegate = self
        valueTextFieldOutlet.delegate = self
    }
    
    // add targeting param value to the tableview
    @IBAction func addTargetingParamAction(_ sender: Any) {
        
        let targetingKeyString = keyTextFieldOutlet.text?.trimmingCharacters(in: .whitespaces)
        let targetingValueString = valueTextFieldOutlet.text?.trimmingCharacters(in: .whitespaces)
        
        if targetingKeyString!.count > 0 && targetingValueString!.count > 0 {
            let targetingParamModel = TargetingParamModel(targetingParamKey: targetingKeyString, targetingParamValue: targetingValueString)
            if targetingParams.count == 0 {
                targetingParams.append(targetingParamModel)
            } else if targetingParams.count > 0 {
                if let targetingIndex = targetingParams.index(where: { $0.targetingKey == targetingKeyString}) {
                    var targetingParamModelLocal = targetingParams[targetingIndex]
                    targetingParamModelLocal.targetingValue = targetingValueString
                    targetingParams.remove(at: targetingIndex)
                    targetingParams.insert(targetingParamModelLocal, at: targetingIndex)
                }else {
                    targetingParams.append(targetingParamModel)
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
            targetingParams.remove(at: row)
            targetingParamTableview.reloadData()
        }
    }
    
    // save property details to database and show SP messages/PM
    @IBAction func savepropertyDetailsAction(_ sender: Any) {
        self.showIndicator()
        let accountIDString = accountIDTextFieldOutlet.text?.trimmingCharacters(in: .whitespaces)
        let propertyId = propertyIdTextFieldOutlet.text?.trimmingCharacters(in: .whitespaces)
        let propertyName = propertyNameTextField.text?.trimmingCharacters(in: .whitespaces)
        let privacyManagerId = privacyManagerTextField.text?.trimmingCharacters(in: .whitespaces)
        let authId = authIdTextField.text?.trimmingCharacters(in: .whitespaces)
        campaign = self.isStagingSwitchOutlet.isOn ? GDPRCampaignEnv.Stage : GDPRCampaignEnv.Public
        
        if addpropertyViewModel.validatepropertyDetails(accountID: accountIDString, propertyId: propertyId, propertyName: propertyName, privacyManagerId: privacyManagerId) {
            guard let accountIDText = accountIDString, let accountID = Int64(accountIDText),
                let propertyIDText = propertyId, let propertyID = Int64(propertyIDText) else {
                    let okHandler = {
                    }
                    self.hideIndicator()
                    AlertView.sharedInstance.showAlertView(title: Alert.alert, message: Alert.messageForWrongAccountIdAndPropertyId, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
                    return
            }
            propertyDetailsModel = PropertyDetailsModel(accountId: accountID, propertyId: propertyID, propertyName: propertyName, campaign: Int64(campaign.rawValue), privacyManagerId: privacyManagerId, creationTimestamp: Date(),authId: authId)
            
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
        addpropertyViewModel.checkExitanceOfData(propertyDetails: propertyDetails, targetingParams: targetingParams, completionHandler: { [weak self] (isStored) in
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
        // optional, set custom targeting parameters supports Strings and Integers
        var targetingParameters = [String:String]()
        for targetingParam in targetingParams {
            targetingParameters[targetingParam.targetingKey!] = targetingParam.targetingValue
        }
        consentViewController = GDPRConsentViewController(accountId: Int(propertyDetails.accountId), propertyId: Int(propertyDetails.propertyId), propertyName: try! GDPRPropertyName(propertyDetails.propertyName!), PMId: propertyDetails.privacyManagerId!, campaignEnv: campaign,targetingParams: targetingParameters, consentDelegate: self)
        if let authId = propertyDetails.authId {
            consentViewController?.loadMessage(forAuthId: authId)
        }else {
            consentViewController?.loadMessage()
        }
    }
    
    func consentUIWillShow() {
        hideIndicator()
        present(self.consentViewController!, animated: true, completion: nil)
    }

    func consentUIDidDisappear() {
        dismiss(animated: true, completion: nil)
    }

    func onConsentReady(gdprUUID: GDPRUUID, userConsent: GDPRUserConsent) {
        showIndicator()
        saveSitDataToDatabase(propertyDetailsModel: propertyDetailsModel!)
        self.loadConsentInfoController(gdprUUID: gdprUUID, userConsents: userConsent)
        hideIndicator()
    }
        
    func onError(error: GDPRConsentViewControllerError?) {
        let okHandler = {
            self.hideIndicator()
            self.dismiss(animated: false, completion: nil)
        }
        AlertView.sharedInstance.showAlertView(title: Alert.message, message: error?.description ?? "Something Went Wrong", actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
    }
    
    func loadConsentInfoController(gdprUUID: GDPRUUID, userConsents: GDPRUserConsent) {
        if let consentDetailsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConsentDetailsViewController") as? ConsentDetailsViewController {
            consentDetailsController.gdprUUID = gdprUUID
            consentDetailsController.userConsents =  userConsents
            consentDetailsController.propertyDetails = propertyDetailsModel
            consentDetailsController.targetingParams = targetingParams
            self.navigationController?.pushViewController(consentDetailsController, animated: true)
        }
    }
    
    // save property details to database
    func saveSitDataToDatabase(propertyDetailsModel: PropertyDetailsModel) {

        if let _propertyManagedObjectID = propertyManagedObjectID {
            addpropertyViewModel.update(propertyDetails: propertyDetailsModel, targetingParams:targetingParams, whereManagedObjectID: _propertyManagedObjectID, completionHandler: {(optionalpropertyManagedObjectID, executionStatus) in
                if executionStatus {
                    Log.sharedLog.DLog(message:"property details are updated")
                }else {
                    Log.sharedLog.DLog(message:"Failed to update property details")
                }
            })
        } else {
            addpropertyViewModel.addproperty(propertyDetails: propertyDetailsModel, targetingParams: targetingParams, completionHandler: { (error, _,propertyManagedObjectID) in

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
        return targetingParams.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TargetingParamCell {
            cell.delegate = self
            let targetingParamName = targetingParams[indexPath.row].targetingKey! + " : " + targetingParams[indexPath.row].targetingValue!
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

