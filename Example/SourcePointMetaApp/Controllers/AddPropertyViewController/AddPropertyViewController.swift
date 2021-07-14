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

class AddPropertyViewController: BaseViewController, CampaignListDelegate, CampaignTableViewDelegate, SPDelegate, UITextFieldDelegate, WKNavigationDelegate {

    // MARK: - IBOutlet
    @IBOutlet weak var accountIDTextFieldOutlet: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var propertyNameTextField: UITextField!
    @IBOutlet weak var authIdTextField: UITextField!
    @IBOutlet weak var campaignListTableview: UITableView!
    @IBOutlet weak var noTargetingParamDataLabel: UILabel!
    @IBOutlet weak var SelectLanguageOutlet: UITextField!
    @IBOutlet weak var campaignsTableView: UITableView!
    @IBOutlet weak var campaignsTableViewHight: NSLayoutConstraint!
    @IBOutlet weak var isStagingSwitchOutlet: UISwitch!

    var messageLanguagePickerView = UIPickerView()

    // Reference to the selected property managed object ID
    var propertyManagedObjectID: NSManagedObjectID?

    // this variable holds the property details entered by user
    var propertyDetailsModel: PropertyDetailsModel?
    var targetingKey: String?
    var targetingValue: String?
    var onConsentReadyCalled = false
    var isMultipleMessagesAvailable = false

    // Default campaign value is public
    var campaignEnv = SPCampaignEnv.Public

    // MARK: - Initializer
    let addpropertyViewModel: AddPropertyViewModel = AddPropertyViewModel()
    var consentManager: SPConsentManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldDelegate()
        addTapGestureRecognizer()
        campaignListTableview.tableFooterView = UIView(frame: .zero)
        setTableViewHidden()

        if let _propertyManagedObjectID = propertyManagedObjectID {
            title = "Edit Property"
            addpropertyViewModel.fetchProperty(propertyManagedObjectID: _propertyManagedObjectID, completionHandler: { [weak self] ( propertyDetailsModel) in

                self?.accountIDTextFieldOutlet.text = String(propertyDetailsModel.accountId)
                self?.propertyNameTextField.text = propertyDetailsModel.propertyName
                if let authId = propertyDetailsModel.authId {
                    self?.authIdTextField.text = authId
                }
                self?.SelectLanguageOutlet.text = propertyDetailsModel.messageLanguage
                self?.isStagingSwitchOutlet.isOn = propertyDetailsModel.campaignEnv == 0 ? true : false
                self?.campaignListTableview.reloadData()
                self?.campaignsTableView.reloadData()
            })
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }

    func setTableViewHidden() {
        campaignListTableview.isHidden = !(addpropertyViewModel.allCampaigns.count > 0)
        noTargetingParamDataLabel.isHidden = addpropertyViewModel.allCampaigns.count > 0
    }

    func addTapGestureRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(touch))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(recognizer)
    }

    func setTextFieldDelegate() {
        messageLanguagePickerView.delegate = self
        messageLanguagePickerView.dataSource = self
        SelectLanguageOutlet.inputView = messageLanguagePickerView
        SelectLanguageOutlet.text = addpropertyViewModel.countries[0]
        accountIDTextFieldOutlet.delegate = self
        propertyNameTextField.delegate = self
        authIdTextField.delegate = self
        SelectLanguageOutlet.delegate = self
        let toolBar = UIToolbar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: view.frame.width, height: SPLiteral.headerViewHeight)))
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        SelectLanguageOutlet.inputAccessoryView = toolBar
    }

    // Set value of staging switch
    @IBAction func campaignEnvAction(_ sender: UISwitch) {
        campaignEnv = sender.isOn ? SPCampaignEnv.Stage : SPCampaignEnv.Public
    }

    @objc func done() {
        SelectLanguageOutlet.resignFirstResponder()
    }

    func deleteCampaign(sender: CampaignListCell) {
        let indexPath = addpropertyViewModel.getIndexPath(sender: sender, tableview: campaignListTableview)
        if let row = indexPath?.row {
            if addpropertyViewModel.allCampaigns[row].campaignName == SPLiteral.gdprCampaign {
                addpropertyViewModel.gdprPMID = nil
                addpropertyViewModel.gdprPMTab = addpropertyViewModel.pmTabs[0]
                addpropertyViewModel.gdprTargetingParams = []
            } else if addpropertyViewModel.allCampaigns[row].campaignName == SPLiteral.ccpaCampaign {
                addpropertyViewModel.ccpaPMID = nil
                addpropertyViewModel.ccpaPMTab = addpropertyViewModel.pmTabs[0]
                addpropertyViewModel.ccpaTargetingParams = []
            } else {
                addpropertyViewModel.iOS14TargetingParams = []
            }
            addpropertyViewModel.allCampaigns.remove(at: row)
            campaignListTableview.reloadData()
            campaignsTableView.reloadData()
        }
    }

    func hideCampaign(section: Int?) {
        if let section = section {
            addpropertyViewModel.sections[section].expanded = !(addpropertyViewModel.sections[section].expanded)
            campaignsTableViewHight.constant = SPLiteral.campaignsTableViewHeight
            campaignsTableView.beginUpdates()
            campaignsTableView.reloadRows(at: [IndexPath(row: 0, section: section)], with: .automatic)
            campaignsTableView.endUpdates()
        }
    }

    func saveCampaign(sender: CampaignTableViewCell) {
        let alertController = UIAlertController(title: Alert.alert, message: Alert.messageForSaveCampaign, preferredStyle: UIAlertController.Style.alert)
        alertController.view.accessibilityIdentifier = SPLiteral.alertView
        let noAction = UIAlertAction(title: Alert.cancel, style: UIAlertAction.Style.destructive, handler: {(_: UIAlertAction!) in })
        let yesAction = UIAlertAction(title: Alert.ok, style: UIAlertAction.Style.default, handler: { [weak self] (_: UIAlertAction!) in
            if let tableView = self?.campaignsTableView {
            let indexPath = self?.addpropertyViewModel.getIndexPath(sender: sender, tableview: tableView)
            self?.saveCampaignData(sender: sender)
            self?.hideCampaign(section: indexPath?.section)
            }
        })
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        present(alertController, animated: true, completion: nil)
    }

    func saveCampaignData(sender: CampaignTableViewCell) {
        var campaignModel: CampaignModel?
        let indexPath = addpropertyViewModel.getIndexPath(sender: sender, tableview: campaignsTableView)
        if indexPath?.section == 0 {
            let targetingParams = addTargetingParam(targetingParams: &addpropertyViewModel.gdprTargetingParams)
            campaignModel = CampaignModel(campaignName: SPLiteral.gdprCampaign, pmID: addpropertyViewModel.gdprPMID, pmTab: addpropertyViewModel.gdprPMTab, targetingParams: targetingParams)
        } else if indexPath?.section == 1 {
            let targetingParams = addTargetingParam(targetingParams: &addpropertyViewModel.ccpaTargetingParams)
            campaignModel = CampaignModel(campaignName: SPLiteral.ccpaCampaign, pmID: addpropertyViewModel.ccpaPMID, pmTab: addpropertyViewModel.ccpaPMTab, targetingParams: targetingParams)
        } else if indexPath?.section == 2 {
            let targetingParams = addTargetingParam(targetingParams: &addpropertyViewModel.iOS14TargetingParams)
            campaignModel = CampaignModel(campaignName: SPLiteral.iOS14Campaign, pmID: nil, pmTab: nil, targetingParams: targetingParams)
        }
        if let campaignModel = campaignModel {
            updateCampaignTableview(campaignModel: campaignModel, section: indexPath?.section)
        }
    }

    func addTargetingParams(sender: CampaignTableViewCell) {
        if let targetingKey = targetingKey, let targetingValue = targetingValue, targetingKey.count > 0 && targetingValue.count > 0 {
            saveCampaignData(sender: sender)
        } else {
            let okHandler = {}
            AlertView.sharedInstance.showAlertView(title: Alert.alert, message: Alert.messageForEmptyTargetingParamError, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
        }
    }

    func addTargetingParam(targetingParams: inout [TargetingParamModel]) -> [TargetingParamModel]? {
        if let targetingParamKey = targetingKey, let targetingParamValue = targetingValue {
            let targetingParamModel = TargetingParamModel(targetingParamKey: targetingParamKey, targetingParamValue: targetingParamValue)
            if targetingParams.count == 0 {
                targetingParams.append(targetingParamModel)
            } else if targetingParams.count > 0 {
                if let targetingIndex = targetingParams.firstIndex(where: { $0.targetingKey == targetingParamKey}) {
                    var targetingParamModelLocal = targetingParams[targetingIndex]
                    targetingParamModelLocal.targetingValue = targetingParamValue
                    targetingParams.remove(at: targetingIndex)
                    targetingParams.insert(targetingParamModelLocal, at: targetingIndex)
                } else {
                    targetingParams.append(targetingParamModel)
                }
            }
            targetingKey = nil
            targetingValue = nil
            return targetingParams
        }
        return nil
    }

    func updateCampaignTableview(campaignModel: CampaignModel, section: Int?) {
        if addpropertyViewModel.allCampaigns.count == 0 {
            addpropertyViewModel.allCampaigns.append(campaignModel)
        } else if addpropertyViewModel.allCampaigns.count > 0 {
            if let campaignModelIndex = addpropertyViewModel.allCampaigns.firstIndex(where: { $0.campaignName == campaignModel.campaignName}) {
                addpropertyViewModel.allCampaigns[campaignModelIndex] = campaignModel
            } else {
                addpropertyViewModel.allCampaigns.append(campaignModel)
            }
        }
        targetingKey = nil
        targetingValue = nil
        campaignsTableView.beginUpdates()
        campaignsTableView.reloadRows(at: [IndexPath(row: 0, section: section ?? 0)], with: .automatic)
        campaignsTableView.endUpdates()
        campaignListTableview.reloadData()
    }

    // save property details to database and show SP messages/PM
    @IBAction func savepropertyDetailsAction(_ sender: Any) {
        showIndicator()
        let accountIDString = accountIDTextFieldOutlet.text?.trimmingCharacters(in: .whitespaces)
        let propertyName = propertyNameTextField.text?.trimmingCharacters(in: .whitespaces)
        let messageLanguage = SelectLanguageOutlet.text?.trimmingCharacters(in: .whitespaces)
        var authId = authIdTextField.text?.trimmingCharacters(in: .whitespaces)
        if authId?.isEmpty ?? true {
            authId = nil
        }
        if addpropertyViewModel.validatepropertyDetails(accountID: accountIDString, propertyName: propertyName) {
            guard let accountIDText = accountIDString, let accountID = Int64(accountIDText) else {
                let okHandler = {}
                hideIndicator()
                AlertView.sharedInstance.showAlertView(title: Alert.alert, message: Alert.messageForWrongAccountId, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
                return
            }
            propertyDetailsModel = PropertyDetailsModel(accountId: accountID, propertyName: propertyName, campaignEnv: Int64(campaignEnv.rawValue), creationTimestamp: Date(), authId: authId, messageLanguage: messageLanguage, campaignDetails: addpropertyViewModel.allCampaigns)

            if let propertyDetails = propertyDetailsModel {
                isPropertyStored(propertyDetails: propertyDetails)
            }
        } else {
            let okHandler = {}
            hideIndicator()
            AlertView.sharedInstance.showAlertView(title: Alert.alert, message: Alert.messageForPropertyUnavailability, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
        }
    }

    func isPropertyStored(propertyDetails: PropertyDetailsModel) {
        addpropertyViewModel.isPropertyStored(propertyDetails: propertyDetails, completionHandler: { [weak self] (isStored) in
            if isStored {
                let okHandler = {}
                self?.hideIndicator()
                AlertView.sharedInstance.showAlertView(title: Alert.message, message: Alert.messageForPropertyStored, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
            } else {
                self?.loadConsentManager(propertyDetails: propertyDetails)
            }
        })
    }

    func loadConsentManager(propertyDetails: PropertyDetailsModel) {
        validateProperty(propertyDetails: propertyDetails)
        if let messageLanguage = propertyDetails.messageLanguage {
            consentManager?.messageLanguage = addpropertyViewModel.getMessageLanguage(countryName: messageLanguage)
        }
        consentManager?.loadMessage(forAuthId: propertyDetails.authId)
    }

    func validateProperty(propertyDetails: PropertyDetailsModel) {
        if let propertyName = propertyDetails.propertyName {
            do {
                consentManager = SPConsentManager(accountId: Int(propertyDetails.accountId), propertyName: try SPPropertyName(propertyName), campaignsEnv: campaignEnv, campaigns: SPCampaigns(
                    gdpr: addpropertyViewModel.gdprCampaign(),
                    ccpa: addpropertyViewModel.ccpaCampaign(),
                    ios14: addpropertyViewModel.iOS14Campaign()
                ), delegate: self)
            } catch {
                showError(error: error as? SPError)
            }
        }
    }

    // save property details to database
    func savePropertyToDatabase(propertyDetails: PropertyDetailsModel) {
        if !onConsentReadyCalled && !isMultipleMessagesAvailable {
            onConsentReadyCalled = true
            if let _propertyManagedObjectID = propertyManagedObjectID {
                addpropertyViewModel.update(propertyDetails: propertyDetails, whereManagedObjectID: _propertyManagedObjectID, completionHandler: {(_, executionStatus) in
                    if executionStatus {
                        Log.sharedLog.DLog(message: "property details are updated")
                    } else {
                        Log.sharedLog.DLog(message: "Failed to update property details")
                    }
                })
            } else {
                addpropertyViewModel.addproperty(propertyDetails: propertyDetails, completionHandler: { (error, _, _) in
                    if let _error = error {
                        let okHandler = {}
                        AlertView.sharedInstance.showAlertView(title: Alert.message, message: _error.message, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
                    } else {
                        Log.sharedLog.DLog(message: "property details are saved")
                    }
                })
            }
        }
    }

    func loadConsentInfoController(userData: SPUserData) {
        hideIndicator()
        consentManager = nil
        if let consentDetailsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConsentDetailsViewController") as? ConsentDetailsViewController {
            consentDetailsController.userData =  userData
            consentDetailsController.propertyDetails = propertyDetailsModel
            navigationController?.pushViewController(consentDetailsController, animated: false)
        }
    }

    // MARK: UITextField delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == accountIDTextFieldOutlet { // Switch focus to property text field
            propertyNameTextField.becomeFirstResponder()
        } else if textField == propertyNameTextField {
            authIdTextField.becomeFirstResponder()
        } else if textField.tag == SPLiteral.targetingKeyTextField {
            textField.superview?.viewWithTag(SPLiteral.targetingValueTextField)?.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == SelectLanguageOutlet {
            return false
        } else if textField.tag == SPLiteral.targetingValueTextField {
            if let text = textField.text as NSString? {
                targetingValue = text.replacingCharacters(in: range, with: string)
            }
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == SPLiteral.pmIdTextField {
            if textFieldIndexPath(textField)?.section == 0 {
                addpropertyViewModel.gdprPMID = textField.text?.trimmingCharacters(in: .whitespaces)
            } else if textFieldIndexPath(textField)?.section == 1 {
                addpropertyViewModel.ccpaPMID = textField.text?.trimmingCharacters(in: .whitespaces)
            }
        } else if textField.tag == SPLiteral.pmTabTextField {
            if textFieldIndexPath(textField)?.section == 0 {
                addpropertyViewModel.gdprPMTab = textField.text?.trimmingCharacters(in: .whitespaces)
            } else if textFieldIndexPath(textField)?.section == 1 {
                addpropertyViewModel.ccpaPMTab = textField.text?.trimmingCharacters(in: .whitespaces)
            }
        } else if textField.tag == SPLiteral.targetingKeyTextField {
            targetingKey = textField.text?.trimmingCharacters(in: .whitespaces)
        } else if textField.tag == SPLiteral.targetingValueTextField {
            targetingValue = textField.text?.trimmingCharacters(in: .whitespaces)
        }
    }

    func textFieldIndexPath(_ textField: UITextField) -> IndexPath? {
        if let cell = textField.superview?.superview as? CampaignTableViewCell {
            let tableview = cell.superview as? UITableView
            let textFieldIndexPath = tableview?.indexPath(for: cell)
            return textFieldIndexPath
        }
        return nil
    }

    @objc func touch() {
        view.endEditing(true)
    }
}

// MARK: - SPDelegate implementation
extension AddPropertyViewController {
    
    func onSPUIReady(_ controller: SPMessageViewController) {
        hideIndicator()
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true)
    }

    func onSPUIFinished(_ controller: SPMessageViewController) {
        dismiss(animated: true)
    }

    func onAction(_ action: SPAction, from controller: SPMessageViewController) {
        if action.type == .RequestATTAccess {
          showIndicator()
        }
    }

    func onConsentReady(userData: SPUserData) {
        showIndicator()
        if let propertyDetails = propertyDetailsModel {
            savePropertyToDatabase(propertyDetails: propertyDetails)
            handleMultipleMessages(userData: userData)
        }
    }

    func onError(error: SPError) {
        hideIndicator()
        let okHandler = { [weak self]() -> Void in self?.dismiss(animated: false)}
        AlertView.sharedInstance.showAlertView(title: Alert.message, message: error.description, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
    }

    func showError(error: SPError?) {
        let okHandler = {}
        hideIndicator()
        AlertView.sharedInstance.showAlertView(title: Alert.alert, message: error?.description ?? "", actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
    }

    func handleMultipleMessages(userData: SPUserData) {
        if onConsentReadyCalled {
            if let ccpaApplies = consentManager?.ccpaApplies(), let gdprApplies = consentManager?.gdprApplies() {
                if !ccpaApplies && gdprApplies || ccpaApplies && !gdprApplies {
                    onConsentReadyCalled = false
                    loadConsentInfoController(userData: userData)
                } else if ccpaApplies && gdprApplies {
                    onConsentReadyCalled = false
                    isMultipleMessagesAvailable = true
                }
            }
        } else if isMultipleMessagesAvailable {
            isMultipleMessagesAvailable = false
            loadConsentInfoController(userData: userData)
        }
    }
}

// MARK: UITableViewDataSource
extension AddPropertyViewController: UITableViewDataSource, ExpandableHeaderViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == SPLiteral.campaignsTableView {
            return addpropertyViewModel.sections.count
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == SPLiteral.campaignsTableView {
            return 1
        } else {
            setTableViewHidden()
            return addpropertyViewModel.allCampaigns.count
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.tag == SPLiteral.campaignsTableView {
            return SPLiteral.headerViewHeight
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == SPLiteral.campaignsTableView {
            if (addpropertyViewModel.sections[indexPath.section].expanded) {
                campaignsTableViewHight.constant = SPLiteral.campaignsTableViewExpandedHeight
                if indexPath.section == 2 {
                    campaignsTableViewHight.constant = SPLiteral.iOS14CampaignviewHeight
                    return SPLiteral.iOS14CampaignRowHeight
                }
                return SPLiteral.campaignsTableViewRowHeight
            }
            return 0
        } else {
            if let targetingParams = addpropertyViewModel.allCampaigns[indexPath.row].targetingParams, targetingParams.count > 0 {
                if addpropertyViewModel.allCampaigns[indexPath.row].campaignName == SPLiteral.iOS14Campaign {
                    return SPLiteral.campaignsTableViewHeight
                }
                return SPLiteral.iOS14CampaignRowHeight
            } else {
                return SPLiteral.campaignsTableViewHeight
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView.tag == SPLiteral.campaignsTableView {
            let header = ExpandableHeaderView()
            header.customInit(title: addpropertyViewModel.sections[section].campaignTitle, section: section, delegate: self)
            return header
        }
        return nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == SPLiteral.campaignsTableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: SPLiteral.CampaignTableViewCell) as? CampaignTableViewCell {
                cell.delegate = self
                setTextFieldDelegate(cell: cell)
                addpropertyViewModel.showPrivacyManagerDetails(cell: cell)
                if indexPath.section == 0 {
                    cell.pmIDLabel.text = SPLiteral.gdprPMId
                    addpropertyViewModel.resetFields(cell: cell, section: indexPath.section)
                }else if indexPath.section == 1 {
                    cell.pmIDLabel.text = SPLiteral.ccpaPMId
                    addpropertyViewModel.resetFields(cell: cell, section: indexPath.section)
                }else if indexPath.section == 2 {
                    addpropertyViewModel.hidePrivacyManagerDetails(cell: cell)
                    addpropertyViewModel.resetFields(cell: cell, section: indexPath.section)
                }
                return cell
            }
        } else if tableView.tag == SPLiteral.campaignListTableview {
            if let cell = tableView.dequeueReusableCell(withIdentifier: SPLiteral.CampaignListCell) as? CampaignListCell {
                cell.delegate = self
                cell.targetingParamTextView.isHidden = false
                cell.campaignNameLabel.text = addpropertyViewModel.allCampaigns[indexPath.row].campaignName
                addpropertyViewModel.hidePMDetailsForIOS14Campaign(campaignName: addpropertyViewModel.allCampaigns[indexPath.row].campaignName, cell: cell)
                if let pmID = addpropertyViewModel.allCampaigns[indexPath.row].pmID, let pmTab = addpropertyViewModel.allCampaigns[indexPath.row].pmTab {
                    cell.pmIDLabel.text = "\(SPLiteral.pmID) \(pmID)"
                    cell.pmTabLabel.text = "\(SPLiteral.pmTab) \(pmTab)"
                } else {
                    cell.pmIDLabel.text = "\(SPLiteral.pmID) \(SPLiteral.pmIDNotAvailable)"
                    cell.pmTabLabel.text = "\(SPLiteral.pmTab) \(addpropertyViewModel.pmTabs[0])"
                }
                if let targetingParams = addpropertyViewModel.allCampaigns[indexPath.row].targetingParams {
                    var targetingParamString = ""
                    for targetingParam in targetingParams {
                        let targetingParamModel = TargetingParamModel(targetingParamKey: targetingParam.targetingKey, targetingParamValue: targetingParam.targetingValue)
                        if targetingParamModel.targetingKey.count > 0 && targetingParamModel.targetingKey.count > 0 {
                            targetingParamString += "\(targetingParamModel.targetingKey) : \(targetingParamModel.targetingKey)\n"
                        }
                    }
                    cell.targetingParamTextView.text = targetingParamString
                }else {
                    cell.targetingParamTextView.isHidden = true
                }
                return cell
            }
        }
        return UITableViewCell()
    }

    func setTextFieldDelegate(cell: CampaignTableViewCell) {
        cell.privacyManagerTextField.delegate = self
        cell.targetingParamKeyTextfield.delegate = self
        cell.targetingParamValueTextField.delegate = self
    }

    func toggleSection(header: ExpandableHeaderView, section: Int) {
        addpropertyViewModel.sections[section].expanded = !addpropertyViewModel.sections[section].expanded
        campaignsTableViewHight.constant = SPLiteral.campaignsTableViewHeight
        campaignsTableView.beginUpdates()
        campaignsTableView.reloadRows(at: [IndexPath(row: 0, section: section)], with: .automatic)
        campaignsTableView.endUpdates()
    }
}

// MARK: - UITableViewDelegate
extension AddPropertyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        campaignListTableview.deselectRow(at: indexPath, animated: false)
    }
}

extension AddPropertyViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return addpropertyViewModel.countries.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return addpropertyViewModel.countries[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        SelectLanguageOutlet.text = addpropertyViewModel.countries[row]
    }
}
