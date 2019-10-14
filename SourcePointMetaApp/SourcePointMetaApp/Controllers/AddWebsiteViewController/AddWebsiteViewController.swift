//
//  AddWebsiteViewController.swift
//  SourcePointMetaApp
//
//  Created by Vilas on 3/25/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import UIKit
import ConsentViewController
import CoreData
import WebKit

class AddWebsiteViewController: BaseViewController,TargetingParamCellDelegate, UITextFieldDelegate, WKNavigationDelegate {
    
    //// MARK: - IBOutlet
    /** UITextField outlet for account ID textField.
     */
    @IBOutlet weak var accountIDTextFieldOutlet: UITextField!
    
    /** UITextField outlet for website textField.
     */
    @IBOutlet weak var websiteTextFieldOutlet: UITextField!
    
    /** UITextField outlet for targeting param key textField.
     */
    @IBOutlet weak var keyTextFieldOutlet: UITextField!
    
    /** UITextField outlet for targeting param value textField.
     */
    @IBOutlet weak var valueTextFieldOutlet: UITextField!
    
    /** UITableView outlet for targeting param values.
     */
    @IBOutlet weak var targetingParamTableview: UITableView!
    
    @IBOutlet weak var isStagingSwitchOutlet: UISwitch!
    
    @IBOutlet weak var noTargetingParamDataLabel: UILabel!
    /** staging/public compaign
     */
    var isStagingSwitchOn = false
    
    /** consentViewController is loaded or not
     */
    var consentViewControllerStatus : Bool?
    
    /** consentViewControllerError is loaded or not
     */
    var consentViewControllerErrorStatus : Bool?
    
    // Reference to the selected website managed object ID
    var websiteManagedObjectID : NSManagedObjectID?
    
    //// MARK: - Instance properties
    private let cellIdentifier = "targetingParamCell"
    
    // Will add all the targeting params to this array
    var targetingParamsArray = [TargetingParamModel]()
    
    // MARK: - Initializer
    let addWebsiteViewModel: AddWebsiteViewModel = AddWebsiteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        accountIDTextFieldOutlet.delegate = self
        websiteTextFieldOutlet.delegate = self
        targetingParamTableview.tableFooterView = UIView(frame: .zero)
        setTableViewHidden()
        
        if let _websiteManagedObjectID = websiteManagedObjectID {
            self.title = "Edit Site"
            self.addWebsiteViewModel.fetch(website: _websiteManagedObjectID, completionHandler: { [weak self] ( siteDataDetailsModel) in
                
                self?.accountIDTextFieldOutlet.text = String(siteDataDetailsModel.accountID)
                self?.websiteTextFieldOutlet.text = siteDataDetailsModel.websiteName
                self?.isStagingSwitchOutlet.isOn = siteDataDetailsModel.isStaging
                self?.isStagingSwitchOn = siteDataDetailsModel.isStaging
                if let targetingParams = siteDataDetailsModel.manyTargetingParams?.allObjects as! [TargetingParams]? {
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
    @IBAction func switchButtonAction(_ sender: UISwitch) {
        
        isStagingSwitchOn = sender.isOn
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
        view.endEditing(true)
        if view.frame.origin.y < 0 {
            self.setViewMovedUp(false)
        }
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
    
    // save website details to database and show SP messages
    @IBAction func saveWebsiteDetailsAction(_ sender: Any) {
//
//        view.endEditing(true)
//        self.showIndicator()
//
//        let accountIDString = accountIDTextFieldOutlet.text?.trimmingCharacters(in: .whitespaces)
//        let siteName = websiteTextFieldOutlet.text?.trimmingCharacters(in: .whitespaces)
//
//        if addWebsiteViewModel.validateWebsiteDetails(accountID: accountIDString, websiteName: siteName) {
//            guard let accountIDText = accountIDString, let accountID = Int64(accountIDText) else {
//
//                let okHandler = {
//                }
//                self.hideIndicator()
//                AlertView.sharedInstance.showAlertView(title: Alert.alert, message: Alert.messageForInvalidError, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
//                return
//            }
//
//            let websiteDataModel = WebsiteDetailsModel(websiteName: siteName, accountID: accountID, creationTimestamp: NSDate(), isStaging: isStagingSwitchOn)
//
//            addWebsiteViewModel.checkExitanceOfData(websiteDetails: websiteDataModel, targetingParams: targetingParamsArray, completionHandler: { [weak self] (isStored) in
//                if isStored {
//                    let okHandler = {
//                    }
//                    self?.hideIndicator()
//                    AlertView.sharedInstance.showAlertView(title: Alert.message, message: Alert.messageForSiteDataStored, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
//                } else {
//                    self?.addWebsiteViewModel.buildConsentViewController(websiteDetails: websiteDataModel, targetingParams: self!.targetingParamsArray, completionHandler: { [weak self] (error, consentViewController, dismissControllerStatus, vendorConsents, purposeConsents) in
//                        if let _error = error {
//                            self?.consentViewControllerErrorStatus = true
//                            let okHandler = {
//                                if self?.consentViewControllerStatus == true && self?.consentViewControllerErrorStatus == true {
//                                    if let viewControllers = (self?.navigationController?.viewControllers) {
//                                        DispatchQueue.main.async { self?.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
//                                        }
//                                    }
//                                }
//                            }
//                            self?.hideIndicator()
//                            AlertView.sharedInstance.showAlertView(title: Alert.message, message: _error.description, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
//                        } else if let _consentViewController = consentViewController {
//
//                            self?.hideIndicator()
//                            self?.saveSitDataToDatabase(websiteDataModel: websiteDataModel)
//                            self?.consentViewControllerStatus = true
//
//                            if let consentSubViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConsentSubViewController") as? ConsentSubViewController {
//                                consentSubViewController.consentSubViewController = _consentViewController
//
//                                self?.navigationController!.pushViewController(consentSubViewController, animated: true)
//                            }
//                        } else if dismissControllerStatus != nil {
//                            self?.hideIndicator()
//                            if self?.consentViewControllerStatus == true {
//                                DispatchQueue.main.async {
//                                    self?.loadConsentInfoController(vendorConsents: vendorConsents, purposeConsents: purposeConsents)
//                                }
//                            } else {
//                                let showSiteInfotHandler = {
//                                    DispatchQueue.main.async {
//                                        self?.saveSitDataToDatabase(websiteDataModel: websiteDataModel)
//                                        self?.loadConsentInfoController(vendorConsents: vendorConsents, purposeConsents: purposeConsents)
//                                    }
//                                }
//                                let clearCookiesHandler = {
//                                    let alertController = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
//
//                                    alertController.setValue(SPLiteral.attributedString(), forKey: "attributedTitle")
//                                    let noAction = UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in
//                                        DispatchQueue.main.async {
//                                            self?.saveSitDataToDatabase(websiteDataModel: websiteDataModel)
//                                            self?.loadConsentInfoController(vendorConsents: vendorConsents, purposeConsents: purposeConsents)
//                                        }
//                                    })
//                                    let yesAction = UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in
//                                        self?.showIndicator()
//                                        self?.addWebsiteViewModel.clearUserDefaultsData()
//                                        self?.clearCookies()
//                                        self?.saveWebsiteDetailsAction(sender)
//                                        self?.hideIndicator()
//                                    })
//                                    alertController.addAction(noAction)
//                                    alertController.addAction(yesAction)
//                                    self?.present(alertController, animated: true, completion: nil)
//                                }
//                                        AlertView.sharedInstance.showAlertView(title: Alert.message, message: Alert.messageAlreadyShown, actions: [showSiteInfotHandler, clearCookiesHandler], titles: [Alert.showSiteInfo, Alert.clearCookies], actionStyle: UIAlertController.Style.alert)
//                                    self?.consentViewControllerErrorStatus = nil
//
//                            }
//                        }
//                    })
//                }
//            })
//        }else {
//            let okHandler = {
//            }
//            self.hideIndicator()
//            AlertView.sharedInstance.showAlertView(title: Alert.alert, message: Alert.messageForWebsiteNameUnavailability, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
//        }
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
    }
    
    // save website details to database
    func saveSitDataToDatabase(websiteDataModel: WebsiteDetailsModel) {
        
        if let _websiteManagedObjectID = websiteManagedObjectID {
            addWebsiteViewModel.update(websiteDetails: websiteDataModel, targetingParams:targetingParamsArray, whereManagedObjectID: _websiteManagedObjectID, completionHandler: {(optionalWebsiteManagedObjectID, executionStatus) in
                if executionStatus {
                    Log.sharedLog.DLog(message:"website Details are updated")
                }else {
                    Log.sharedLog.DLog(message:"Failed to update website Details")
                }
            })
        } else {
            addWebsiteViewModel.addWebsite(websiteDetails: websiteDataModel, targetingParams: targetingParamsArray, completionHandler: { (error, _,websiteManagedObjectID) in
                
                if let _error = error {
                    let okHandler = {
                    }
                    AlertView.sharedInstance.showAlertView(title: Alert.message, message: _error.message, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
                } else {
                    Log.sharedLog.DLog(message:"website Details saved")
                }
            })
        }
    }
    
    //method to move the view up/down whenever the keyboard is shown/dismissed
    func setViewMovedUp(_ movedUp: Bool) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.3)
        // if you want to slide up the view
        var rect: CGRect = view.frame
        if movedUp {
            // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
            // 2. increase the size of the view so that the area behind the keyboard is covered up.
            rect.origin.y -= 80
            rect.size.height += 80
        }
        else {
            // revert back to the normal state.
            rect.origin.y += 80
            rect.size.height -= 80
        }
        view.frame = rect
        UIView.commitAnimations()
    }
    
    //MARK: UITextField delegate methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == valueTextFieldOutlet {
            //move the main view, so that the keyboard does not hide it.
            if view.frame.origin.y >= 0 {
                setViewMovedUp(true)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == accountIDTextFieldOutlet { // Switch focus to website text field
            websiteTextFieldOutlet.becomeFirstResponder()
        } else if textField == websiteTextFieldOutlet {
            keyTextFieldOutlet.becomeFirstResponder()
        } else if textField == keyTextFieldOutlet {
            valueTextFieldOutlet.becomeFirstResponder()
        } else {
            addTargetingParamAction(textField)
            textField.resignFirstResponder()
            if view.frame.origin.y < 0 {
                self.setViewMovedUp(false)
            }
        }
        return true
    }
    
    //MARK: hiding keyboard when touch outside of textfields
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if view.frame.origin.y < 0 {
            self.setViewMovedUp(false)
        }
        view.endEditing(true)
    }
}

//// MARK: UITableViewDataSource
extension AddWebsiteViewController : UITableViewDataSource {
    
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

//// MARK: - UITableViewDelegate
extension AddWebsiteViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        targetingParamTableview.deselectRow(at: indexPath, animated: false)
    }
}

