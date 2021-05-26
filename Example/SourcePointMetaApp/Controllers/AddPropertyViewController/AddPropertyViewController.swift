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

    var messageLanguagePickerView = UIPickerView()

    // this variable holds the property details entered by user
    var propertyDetailsModel: PropertyDetailsModel?
    var targetingkey: String?
    var targetingValue: String?

    // MARK: - Initializer
    let addpropertyViewModel: AddPropertyViewModel = AddPropertyViewModel()
    var consentManager: SPConsentManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldDelegate()
        addTapGestureRecognizer()
        campaignListTableview.tableFooterView = UIView(frame: .zero)
        setTableViewHidden()
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
        let toolBar = UIToolbar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: view.frame.width, height: CGFloat(44))))
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        SelectLanguageOutlet.inputAccessoryView = toolBar
    }

    @objc func done() {
        SelectLanguageOutlet.resignFirstResponder()
    }

    func deleteCampaignButton(sender: CampaignListCell) {
        let indexPath = addpropertyViewModel.getIndexPath(sender: sender, tableview: campaignListTableview)
        if let row = indexPath?.row {
            addpropertyViewModel.allCampaigns.remove(at: row)
            campaignListTableview.reloadData()
        }
    }

    func hideCampaign(section: Int?) {
        if let section = section {
            self.addpropertyViewModel.sections[section].expanded = !(self.addpropertyViewModel.sections[section].expanded)
            self.campaignsTableViewHight.constant = 150
            self.campaignsTableView.beginUpdates()
            self.campaignsTableView.reloadRows(at: [IndexPath(row: 0, section: section)], with: .automatic)
            self.campaignsTableView.endUpdates()
        }
    }

    func saveCampaignData(sender: CampaignTableViewCell) {
        let alertController = UIAlertController(title: Alert.alert, message: Alert.messageForSaveCampaign, preferredStyle: UIAlertController.Style.alert)
        alertController.view.accessibilityIdentifier = SPLiteral.alertView
        let noAction = UIAlertAction(title: Alert.cancel, style: UIAlertAction.Style.destructive, handler: {(_: UIAlertAction!) in })
        let yesAction = UIAlertAction(title: Alert.ok, style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
            let indexPath = self.addpropertyViewModel.getIndexPath(sender: sender, tableview: self.campaignsTableView)
            self.hideCampaign(section: indexPath?.section)
        })
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func updateCampaign(sender: CampaignTableViewCell) {
        addpropertyViewModel.updateCampaignEnvironment(sender: sender, tableview: self.campaignsTableView)
    }

    func updateTableviewWithData(campaignModel: CampaignModel?, section: Int?) {
        if addpropertyViewModel.allCampaigns.count == 0 {
            addpropertyViewModel.allCampaigns.append(campaignModel!)
        }else if addpropertyViewModel.allCampaigns.count > 0 {
            if let campaignModelIndex = addpropertyViewModel.allCampaigns.firstIndex(where: { $0.campaignName == campaignModel?.campaignName}) {
                addpropertyViewModel.allCampaigns[campaignModelIndex] = campaignModel!
            } else {
                addpropertyViewModel.allCampaigns.append(campaignModel!)
            }
        }
        self.targetingkey = ""
        self.targetingValue = ""
        campaignsTableView.beginUpdates()
        campaignsTableView.reloadRows(at: [IndexPath(row: 0, section: section ?? 0)], with: .automatic)
        campaignsTableView.endUpdates()
        campaignListTableview.reloadData()
    }

    func addTargetingParams(sender: CampaignTableViewCell) {
        var campaignModel: CampaignModel?
        let indexPath = self.addpropertyViewModel.getIndexPath(sender: sender, tableview: self.campaignsTableView)
        if indexPath?.section == 0 {
            let targetingParams = addTargetingParam(targetingParams: &addpropertyViewModel.gdprTargetingParams)
            campaignModel = CampaignModel(campaignName: SPLiteral.gdprCampaign, campaignEnv: Int64(addpropertyViewModel.gdprCampaign.rawValue), privacyManagerId: addpropertyViewModel.gdprPMID, pmTab: addpropertyViewModel.gdprPMTab, targetingParams: targetingParams)
        } else if indexPath?.section == 1 {
            let targetingParams = addTargetingParam(targetingParams: &addpropertyViewModel.gdprTargetingParams)
            campaignModel = CampaignModel(campaignName: SPLiteral.ccpaCampaign, campaignEnv: Int64(addpropertyViewModel.ccpaCampaign.rawValue), privacyManagerId: addpropertyViewModel.ccpaPMID, pmTab: addpropertyViewModel.ccpaPMTab, targetingParams: targetingParams)
        } else if indexPath?.section == 2 {
            let targetingParams = addTargetingParam(targetingParams: &addpropertyViewModel.gdprTargetingParams)
            campaignModel = CampaignModel(campaignName: SPLiteral.iOS14Campaign, campaignEnv: Int64(addpropertyViewModel.iOS14Campaign.rawValue), privacyManagerId: nil, pmTab: nil, targetingParams: targetingParams)
        }
        updateTableviewWithData(campaignModel: campaignModel, section: indexPath?.section)
    }

    func addTargetingParam(targetingParams: inout [TargetingParamModel]) -> [TargetingParamModel]? {
        if let targetingKeyValue = targetingkey, let targetingValue = targetingValue {
            if targetingKeyValue.count > 0 && targetingValue.count > 0 {
                let targetingParamModel = TargetingParamModel(targetingParamKey: targetingKeyValue, targetingParamValue: targetingValue)
                if targetingParams.count == 0 {
                    targetingParams.append(targetingParamModel)
                } else if targetingParams.count > 0 {
                    if let targetingIndex = targetingParams.firstIndex(where: { $0.targetingKey == targetingkey}) {
                        var targetingParamModelLocal = targetingParams[targetingIndex]
                        targetingParamModelLocal.targetingValue = targetingValue
                        targetingParams.remove(at: targetingIndex)
                        targetingParams.insert(targetingParamModelLocal, at: targetingIndex)
                    } else {
                        targetingParams.append(targetingParamModel)
                    }
                }
                return targetingParams
            }else {
                let okHandler = {}
                AlertView.sharedInstance.showAlertView(title: Alert.alert, message: Alert.messageForEmptyTargetingParamError, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
            }
        }else {
            let okHandler = {}
            AlertView.sharedInstance.showAlertView(title: Alert.alert, message: Alert.messageForEmptyTargetingParamError, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
        }
        return nil
    }

    // save property details to database and show SP messages/PM
    @IBAction func savepropertyDetailsAction(_ sender: Any) {
        self.showIndicator()
        let accountIDString = accountIDTextFieldOutlet.text?.trimmingCharacters(in: .whitespaces)
        let propertyName = propertyNameTextField.text?.trimmingCharacters(in: .whitespaces)
        var authId = authIdTextField.text?.trimmingCharacters(in: .whitespaces)
        if authId?.isEmpty ?? true {
            authId = nil
        }
        if addpropertyViewModel.validatepropertyDetails(accountID: accountIDString, propertyName: propertyName) {
            guard let accountIDText = accountIDString, let accountID = Int64(accountIDText) else {
                let okHandler = {}
                self.hideIndicator()
                AlertView.sharedInstance.showAlertView(title: Alert.alert, message: Alert.messageForWrongAccountIdAndPropertyId, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
                return
            }
            loadConsentManager(accountID: accountID, propertyName: propertyName)
        } else {
            let okHandler = {}
            self.hideIndicator()
            AlertView.sharedInstance.showAlertView(title: Alert.alert, message: Alert.messageForPropertyUnavailability, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
        }
    }

    func loadConsentManager(accountID: Int64, propertyName: String?) {
        if let propertyName = propertyName {
            do {
                consentManager = SPConsentManager(accountId: Int(accountID), propertyName: try SPPropertyName(propertyName), campaigns:  SPCampaigns(
                    gdpr: SPCampaign(),
                    ccpa: SPCampaign(),
                    ios14: SPCampaign()
                ), delegate: self)
                consentManager?.loadMessage()
            } catch {
                print(error)
            }
        }
    }

    func checkExitanceOfpropertyData(propertyDetails: PropertyDetailsModel) {
    }

    func validateProperty(propertyDetails: PropertyDetailsModel) {
    }

    // save property details to database
    func saveSitDataToDatabase(propertyDetailsModel: PropertyDetailsModel) {
    }

    // MARK: UITextField delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == accountIDTextFieldOutlet { // Switch focus to property text field
            propertyNameTextField.becomeFirstResponder()
        } else if textField == propertyNameTextField {
            authIdTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == SelectLanguageOutlet {
            return false
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 11 {
            if textFieldIndexPath(textField)?.section == 0 {
                addpropertyViewModel.gdprPMID = textField.text?.trimmingCharacters(in: .whitespaces)
            }else if textFieldIndexPath(textField)?.section == 1 {
                addpropertyViewModel.ccpaPMID = textField.text?.trimmingCharacters(in: .whitespaces)
            }
        }else if textField.tag == 12 {
            if textFieldIndexPath(textField)?.section == 0 {
                addpropertyViewModel.gdprPMTab = textField.text?.trimmingCharacters(in: .whitespaces)
            }else if textFieldIndexPath(textField)?.section == 1 {
                addpropertyViewModel.ccpaPMTab = textField.text?.trimmingCharacters(in: .whitespaces)
            }
        }else if textField.tag == 13 {
            self.targetingkey = textField.text?.trimmingCharacters(in: .whitespaces)
        }else if textField.tag == 14 {
            self.targetingValue = textField.text?.trimmingCharacters(in: .whitespaces)
        }
    }

    func textFieldIndexPath(_ textField: UITextField) -> IndexPath? {
        let cell: UITableViewCell = textField.superview?.superview as! CampaignTableViewCell
        let table: UITableView = cell.superview as! UITableView
        let textFieldIndexPath = table.indexPath(for: cell)
        return textFieldIndexPath
    }

    @objc func touch() {
        self.view.endEditing(true)
    }
}

// MARK: - SPDelegate implementation
extension AddPropertyViewController {
    func onSPUIReady(_ controller: SPMessageViewController) {
        self.hideIndicator()
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true)
    }

    func onAction(_ action: SPAction, from controller: SPMessageViewController) {
        print(action)
    }

    func onSPUIFinished(_ controller: SPMessageViewController) {
        dismiss(animated: true)
    }

    func onConsentReady(userData: SPUserData) {
        print("onConsentReady:", userData)
    }

    func onError(error: SPError) {
        self.hideIndicator()
        let okHandler = {
            self.dismiss(animated: false, completion: nil)
        }
        AlertView.sharedInstance.showAlertView(title: Alert.message, message: error.description, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
    }
}

// MARK: UITableViewDataSource
extension AddPropertyViewController: UITableViewDataSource, ExpandableHeaderViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 1 {
            return addpropertyViewModel.sections.count
        }else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            return 1
        }else {
            setTableViewHidden()
            return addpropertyViewModel.allCampaigns.count
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.tag == 1 {
            return 44
        }else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 1 {
            if (addpropertyViewModel.sections[indexPath.section].expanded) {
                self.campaignsTableViewHight.constant = 500
                if indexPath.section == 2 {
                    self.campaignsTableViewHight.constant = 400
                    return 250
                }
                return 350
            }
            return 0
        } else {
            return 250
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView.tag == 1 {
            let header = ExpandableHeaderView()
            header.customInit(title: addpropertyViewModel.sections[section].campaignTitle, section: section, delegate: self)
            return header
        }
        return nil
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CampaignTableViewCell") as! CampaignTableViewCell
            cell.delegate = self
            setTextFieldDelegate(cell: cell)
            addpropertyViewModel.showPrivacyManagerDetails(cell: cell)
            if indexPath.section == 0 {
                cell.pmIDLabel.text = "GDPR PM ID:"
                addpropertyViewModel.resetFields(cell: cell, section: indexPath.section)
            }else if indexPath.section == 1 {
                cell.pmIDLabel.text = "CCPA PM ID:"
                addpropertyViewModel.resetFields(cell: cell, section: indexPath.section)
            }else if indexPath.section == 2 {
                addpropertyViewModel.hidePrivacyManagerDetails(cell: cell)
                addpropertyViewModel.resetFields(cell: cell, section: indexPath.section)
            }
            return cell
        } else if tableView.tag == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CampaignListCell") as! CampaignListCell
            cell.delegate = self
            cell.targetingParamTextView.isHidden = false
            cell.campaignNameLabel.text = addpropertyViewModel.allCampaigns[indexPath.row].campaignName
            cell.campaignEnvLabel.text = addpropertyViewModel.allCampaigns[indexPath.row].campaignEnv == Int64(0) ? "Campaign: \(SPLiteral.stageEnv)" : "\(SPLiteral.campaign)"
            cell.pmIDLabel.text = "PM ID: \(String(describing: addpropertyViewModel.allCampaigns[indexPath.row].privacyManagerId))"
            cell.pmTabLabel.text = "PM Tab: \(String(describing: addpropertyViewModel.allCampaigns[indexPath.row].pmTab))"
            if let abc = addpropertyViewModel.allCampaigns[indexPath.row].targetingParams {
                var targetingParamString = ""
                for targetingParam in abc {
                    let targetingParamModel = TargetingParamModel(targetingParamKey: targetingParam.targetingKey, targetingParamValue: targetingParam.targetingValue)
                    targetingParamString += "\(targetingParamModel.targetingKey!) : \(targetingParamModel.targetingValue!)\n"
                }
                cell.targetingParamTextView.text = targetingParamString
            }else {
                cell.targetingParamTextView.isHidden = true
            }
            return cell
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
        self.campaignsTableViewHight.constant = 150
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
