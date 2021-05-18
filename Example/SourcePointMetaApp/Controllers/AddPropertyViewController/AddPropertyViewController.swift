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

class AddPropertyViewController: BaseViewController, TargetingParamCellDelegate, UITextFieldDelegate, WKNavigationDelegate, CampaignTableViewCellDelegate //GDPRConsentDelegate
{

    // MARK: - IBOutlet
    /** UITextField outlet for account ID textField.
     */
    @IBOutlet weak var accountIDTextFieldOutlet: UITextField!

    /** UIScrollView outlet for scrollView.
    */
    @IBOutlet weak var scrollView: UIScrollView!

    /** UITextField outlet for property Name textField.
    */
    @IBOutlet weak var propertyNameTextField: UITextField!

    /** UITextField outlet for auth Id textField.
     */
    @IBOutlet weak var authIdTextField: UITextField!

    /** UITableView outlet for targeting param values.
     */
    @IBOutlet weak var targetingParamTableview: UITableView!

    /** UILabel outlet for showing No targeting param data.
    */
    @IBOutlet weak var noTargetingParamDataLabel: UILabel!

    @IBOutlet weak var SelectLanguageOutlet: UITextField!

    @IBOutlet weak var campaignsTableView: UITableView!

    @IBOutlet weak var campaignsTableViewHight: NSLayoutConstraint!
    
    var messageLanguagePickerView = UIPickerView()

    var pmTabPickerView = UIPickerView()

    // Reference to the selected property managed object ID
    var propertyManagedObjectID: NSManagedObjectID?

    // MARK: - Instance properties
    private var campaignCell: CampaignTableViewCell?

    var campaignIndexPath: Int?

    // Will add all the targeting params to this array
    var targetingParams = [TargetingParamModel]()

    // this variable holds the property details entered by user
    var propertyDetailsModel: PropertyDetailsModel?

    var isPMLoaded = false

    /** Default campaign value is public
     */
    var ccpaCampaign = SPCampaignEnv.Public

    var gdprCampaign = SPCampaignEnv.Public

    var iOS14Campaign = SPCampaignEnv.Public

    var gdprPMID: String?
    var ccpaPMID: String?
    var gdprPMTab: String?
    var ccpaPMTab: String?

    // Will add all the targeting params to this array
    var ccpaTargetingParams = [TargetingParamModel]()

    var gdprTargetingParams = [TargetingParamModel]()

    var iOS14TargetingParams = [TargetingParamModel]()


    // MARK: - Initializer
    let addpropertyViewModel: AddPropertyViewModel = AddPropertyViewModel()
//    var consentViewController: GDPRConsentViewController?
    var nativeMessageController: SPNativeMessageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldDelegate()
        addTapGestureRecognizer()
        targetingParamTableview.tableFooterView = UIView(frame: .zero)
        setTableViewHidden()

        if let _propertyManagedObjectID = propertyManagedObjectID {
            self.title = "Edit Property"
            self.addpropertyViewModel.fetch(property: _propertyManagedObjectID, completionHandler: { [weak self] ( propertyDetailsModel) in

                self?.accountIDTextFieldOutlet.text = String(propertyDetailsModel.accountId)
                self?.propertyNameTextField.text = propertyDetailsModel.propertyName
//                self?.privacyManagerTextField.text = propertyDetailsModel.privacyManagerId
                if let authId = propertyDetailsModel.authId {
                    self?.authIdTextField.text = authId
                }
                self?.SelectLanguageOutlet.text = propertyDetailsModel.messageLanguage
//                self?.PMTabOutlet.text = propertyDetailsModel.pmId
//                self?.isStagingSwitchOutlet.isOn = propertyDetailsModel.campaign == 0 ? true : false
//                self?.isNativeMessageSwitch.isOn = propertyDetailsModel.nativeMessage == 1 ? true : false
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
//        campaign = sender.isOn ? SPCampaignEnv.Stage : SPCampaignEnv.Public
    }

    func setTableViewHidden() {
        targetingParamTableview.isHidden = !(targetingParams.count > 0)
        noTargetingParamDataLabel.isHidden = targetingParams.count > 0
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

    // add targeting param value to the tableview
//    @IBAction func addTargetingParamAction(_ sender: Any) {
//
//        let targetingKeyString = keyTextFieldOutlet.text?.trimmingCharacters(in: .whitespaces)
//        let targetingValueString = valueTextFieldOutlet.text?.trimmingCharacters(in: .whitespaces)
//
//        if targetingKeyString!.count > 0 && targetingValueString!.count > 0 {
//            let targetingParamModel = TargetingParamModel(targetingParamKey: targetingKeyString, targetingParamValue: targetingValueString)
//            if targetingParams.count == 0 {
//                targetingParams.append(targetingParamModel)
//            } else if targetingParams.count > 0 {
//                if let targetingIndex = targetingParams.firstIndex(where: { $0.targetingKey == targetingKeyString}) {
//                    var targetingParamModelLocal = targetingParams[targetingIndex]
//                    targetingParamModelLocal.targetingValue = targetingValueString
//                    targetingParams.remove(at: targetingIndex)
//                    targetingParams.insert(targetingParamModelLocal, at: targetingIndex)
//                } else {
//                    targetingParams.append(targetingParamModel)
//                }
//            }
//
//            keyTextFieldOutlet.text = ""
//            valueTextFieldOutlet.text = ""
//            targetingParamTableview.reloadData()
//        } else {
//            let okHandler = {
//            }
//            AlertView.sharedInstance.showAlertView(title: Alert.alert, message: Alert.messageForEmptyTargetingParamError, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
//        }
//    }

    func deleteButton(sender: TargetingParamCell) {
        let buttonPosition: CGPoint = sender.convert(sender.bounds.origin, to: targetingParamTableview)
        let indexPath = targetingParamTableview.indexPathForRow(at: buttonPosition)
        if let row = indexPath?.row {
            targetingParams.remove(at: row)
            targetingParamTableview.reloadData()
        }
    }

    func updateCampaign(sender: CampaignTableViewCell) {
        print("")
    }

    func addCampaignDetails(sender: CampaignTableViewCell) {
//        let targetingKeyString = keyTextFieldOutlet.text?.trimmingCharacters(in: .whitespaces)
        print("")
    }

    // save property details to database and show SP messages/PM
    @IBAction func savepropertyDetailsAction(_ sender: Any) {
//        self.showIndicator()
//        let accountIDString = accountIDTextFieldOutlet.text?.trimmingCharacters(in: .whitespaces)
//        let propertyId = propertyIdTextFieldOutlet.text?.trimmingCharacters(in: .whitespaces)
//        let propertyName = propertyNameTextField.text?.trimmingCharacters(in: .whitespaces)
//        let privacyManagerId = privacyManagerTextField.text?.trimmingCharacters(in: .whitespaces)
//        var authId = authIdTextField.text?.trimmingCharacters(in: .whitespaces)
//        let messageLanguage = SelectLanguageOutlet.text?.trimmingCharacters(in: .whitespaces)
//        let pmTab = PMTabOutlet.text?.trimmingCharacters(in: .whitespaces)
//        if authId?.isEmpty ?? true {
//            authId = nil
//        }
//        if addpropertyViewModel.validatepropertyDetails(accountID: accountIDString, propertyId: propertyId, propertyName: propertyName, privacyManagerId: privacyManagerId) {
//            guard let accountIDText = accountIDString, let accountID = Int64(accountIDText),
//                let propertyIDText = propertyId, let propertyID = Int64(propertyIDText) else {
//                    let okHandler = {
//                    }
//                    self.hideIndicator()
//                    AlertView.sharedInstance.showAlertView(title: Alert.alert, message: Alert.messageForWrongAccountIdAndPropertyId, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
//                    return
//            }
//            propertyDetailsModel = PropertyDetailsModel(accountId: accountID, propertyId: propertyID, propertyName: propertyName, campaign: Int64(campaign.rawValue), privacyManagerId: privacyManagerId, creationTimestamp: Date(), authId: authId, nativeMessage: Int64(truncating: NSNumber(value: isNativeMessageSwitch.isOn)), messageLanguage: messageLanguage, pmTab: pmTab)
//
//            if let propertyDetails = propertyDetailsModel {
//                checkExitanceOfpropertyData(propertyDetails: propertyDetails)
//            }
//        } else {
//            let okHandler = {
//            }
//            self.hideIndicator()
//            AlertView.sharedInstance.showAlertView(title: Alert.alert, message: Alert.messageForPropertyUnavailability, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
//        }
    }

    func checkExitanceOfpropertyData(propertyDetails: PropertyDetailsModel) {
        addpropertyViewModel.checkExitanceOfData(propertyDetails: propertyDetails, targetingParams: targetingParams, completionHandler: { [weak self] (isStored) in
            if isStored {
                let okHandler = {
                }
                self?.hideIndicator()
                AlertView.sharedInstance.showAlertView(title: Alert.message, message: Alert.messageForPropertyDataStored, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
            } else {
//                self?.loadConsentManager(propertyDetails: propertyDetails)
            }
        })
    }

//    func loadConsentManager(propertyDetails: PropertyDetailsModel) {
//        self.validateProperty(propertyDetails: propertyDetails)
//            if let messageLanguage = propertyDetails.messageLanguage {
//                consentViewController?.messageLanguage = addpropertyViewModel.getMessageLanguage(countryName: messageLanguage)
//            }
//            consentViewController?.privacyManagerTab = addpropertyViewModel.getPMTab(pmTab: propertyDetails.pmTab ?? "")
//            isNativeMessageSwitch.isOn ? consentViewController?.loadNativeMessage(forAuthId: propertyDetails.authId) :
//                consentViewController?.loadMessage(forAuthId: propertyDetails.authId)
//    }

    func validateProperty(propertyDetails: PropertyDetailsModel) {
        // optional, set custom targeting parameters supports Strings and Integers
        var targetingParameters = [String: String]()
        for targetingParam in targetingParams {
            targetingParameters[targetingParam.targetingKey!] = targetingParam.targetingValue
        }
//        if let propertyName = propertyDetails.propertyName, let privacyManagerID = propertyDetails.privacyManagerId {
//            do {
//                consentViewController = GDPRConsentViewController(accountId: Int(propertyDetails.accountId), propertyId: Int(propertyDetails.propertyId), propertyName: try GDPRPropertyName(propertyName), PMId: privacyManagerID , campaignEnv: campaign, targetingParams: targetingParameters, consentDelegate: self)
//            } catch {
//                self.showError(error: error as? GDPRConsentViewControllerError)
//            }
//        }
    }

//    func showError(error: GDPRConsentViewControllerError?) {
//        let okHandler = {
//        }
//        self.hideIndicator()
//        AlertView.sharedInstance.showAlertView(title: Alert.alert, message: error?.description ?? "" , actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
//    }

//    func gdprConsentUIWillShow() {
//        hideIndicator()
//        if nativeMessageController?.viewIfLoaded?.window != nil {
//            nativeMessageController?.present(consentViewController!, animated: true, completion: nil)
//        } else {
//            present(consentViewController!, animated: true, completion: nil)
//        }
//    }

//    func consentUIWillShow(message: GDPRMessage) {
//        hideIndicator()
//        if let consentViewController = consentViewController {
//            nativeMessageController = SPNativeMessageViewController(messageContents: message, consentViewController: consentViewController)
//            nativeMessageController?.modalPresentationStyle = .overFullScreen
//            present(nativeMessageController!, animated: true, completion: nil)
//        }
//    }

    /// called on every Consent Message / PrivacyManager action. For more info on the different kinds of actions check
    /// `SPActionType`
//    func onAction(_ action: SPAction) {
//        if isNativeMessageSwitch.isOn {
//            switch action.type {
//            case .PMCancel:
//                dismissPrivacyManager()
//            case .ShowPrivacyManager:
//                isPMLoaded = true
//                showIndicator()
//            case .AcceptAll:
//                if !isPMLoaded {
//                    consentViewController?.reportAction(action)
//                    dismiss(animated: true, completion: nil)
//                }
//            case .RejectAll:
//                if !isPMLoaded {
//                    consentViewController?.reportAction(action)
//                    dismiss(animated: true, completion: nil)
//                }
//            default:
//                dismiss(animated: true, completion: nil)
//            }
//        }
//    }

    func consentUIDidDisappear() {
        dismiss(animated: true, completion: nil)
    }

//    func onConsentReady(consentUUID: SPConsentUUID, userConsent: SPGDPRConsent) {
//        showIndicator()
//        saveSitDataToDatabase(propertyDetailsModel: propertyDetailsModel!)
//        self.loadConsentInfoController(consentUUID: consentUUID, userConsents: userConsent)
//        hideIndicator()
//    }

    func onError(error: SPError) {
        let okHandler = {
            self.hideIndicator()
            self.dismiss(animated: false, completion: nil)
        }
        AlertView.sharedInstance.showAlertView(title: Alert.message, message: error.description, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
    }

    private func dismissPrivacyManager() {
        if nativeMessageController?.viewIfLoaded?.window != nil {
            nativeMessageController?.dismiss(animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

//    func loadConsentInfoController(consentUUID: SPConsentUUID, userConsents: SPGDPRConsent) {
//        if let consentDetailsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConsentDetailsViewController") as? ConsentDetailsViewController {
//            consentDetailsController.consentUUID = consentUUID
//            consentDetailsController.userConsents =  userConsents
//            consentDetailsController.propertyDetails = propertyDetailsModel
//            consentDetailsController.targetingParams = targetingParams
//            self.navigationController?.pushViewController(consentDetailsController, animated: false)
//        }
//    }

    // save property details to database
    func saveSitDataToDatabase(propertyDetailsModel: PropertyDetailsModel) {

        if let _propertyManagedObjectID = propertyManagedObjectID {
            addpropertyViewModel.update(propertyDetails: propertyDetailsModel, targetingParams: targetingParams, whereManagedObjectID: _propertyManagedObjectID, completionHandler: {(_, executionStatus) in
                if executionStatus {
                    Log.sharedLog.DLog(message: "property details are updated")
                } else {
                    Log.sharedLog.DLog(message: "Failed to update property details")
                }
            })
        } else {
            addpropertyViewModel.addproperty(propertyDetails: propertyDetailsModel, targetingParams: targetingParams, completionHandler: { (error, _, _) in

                if let _error = error {
                    let okHandler = {
                    }
                    AlertView.sharedInstance.showAlertView(title: Alert.message, message: _error.message, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
                } else {
                    Log.sharedLog.DLog(message: "property details are saved")
                }
            })
        }
    }

    // MARK: UITextField delegate methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == accountIDTextFieldOutlet { // Switch focus to property text field
            propertyNameTextField.becomeFirstResponder()
        } else if textField == propertyNameTextField {
            authIdTextField.becomeFirstResponder()
        } else {
//            addTargetingParamAction(textField)
            textField.resignFirstResponder()
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == SelectLanguageOutlet || textField.tag == 12 {
            return false
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        let cell: UITableViewCell = textField.superview?.superview as! CampaignTableViewCell
        let table: UITableView = cell.superview as! UITableView
        let textFieldIndexPath = table.indexPath(for: cell)
        if textField.tag == 11 {
            if textFieldIndexPath?.section == 0 {
                self.gdprPMID = textField.text
            }else if textFieldIndexPath?.section == 1 {
                self.ccpaPMID = textField.text
            }
        }else if textField.tag == 12 {
            if textFieldIndexPath?.section == 0 {
                self.gdprPMTab = textField.text
            }else if textFieldIndexPath?.section == 1 {
                self.ccpaPMTab = textField.text
            }
        }
    }

    @objc func touch() {
        self.view.endEditing(true)
    }

    var sections = [
        Section(campaignTitle: "Add GDPR Campaign", expanded: false),
        Section(campaignTitle: "Add CCPA Campaign", expanded: false),
        Section(campaignTitle: "Add iOS 14 Campaign", expanded: false)
    ]
}

// MARK: UITableViewDataSource
extension AddPropertyViewController: UITableViewDataSource, ExpandableHeaderViewDelegate {

//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        setTableViewHidden()
//        return targetingParams.count
//    }

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TargetingParamCell {
//            cell.delegate = self
//            let targetingParamName = targetingParams[indexPath.row].targetingKey! + " : " + targetingParams[indexPath.row].targetingValue!
//            cell.targetingParamLabel.text = targetingParamName
//            return cell
//        }
//        return UITableViewCell()
//    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 1 {
            if (sections[indexPath.section].expanded) {
                self.campaignsTableViewHight.constant = 500
                if indexPath.section == 2 {
                    self.campaignsTableViewHight.constant = 400
                    return 250
                }
                return 350
            }
            return 0
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 2
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ExpandableHeaderView()
        header.customInit(title: sections[section].campaignTitle, section: section, delegate: self)
        return header
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CampaignTableViewCell") as! CampaignTableViewCell
            cell.delegate = self
            campaignCell = cell
            setTextFieldDelegate(cell: cell)
            showPrivacyManagerDetails(cell: cell)
            resetTextFields(cell: cell)
            if indexPath.section == 0 {
                cell.pmIDLabel.text = "GDPR PM ID:"
                cell.pmTabTextField.text = self.gdprPMTab
            }else if indexPath.section == 1 {
                cell.pmIDLabel.text = "CCPA PM ID:"
            } else if indexPath.section == 2 {
                hidePrivacyManagerDetails(cell: cell)
            }
            return cell
        }
        return UITableViewCell()
    }

    func setTextFieldDelegate(cell: CampaignTableViewCell) {
        cell.privacyManagerTextField.delegate = self
        cell.targetingParamKeyTextfield.delegate = self
        cell.targetingParamValueTextField.delegate = self
        cell.pmTabTextField.delegate = self
        pmTabPickerView.delegate = self
        pmTabPickerView.dataSource = self
        cell.pmTabTextField.inputView = pmTabPickerView
        cell.pmTabTextField.text = addpropertyViewModel.pmTabs[0]
        let toolBar = UIToolbar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: view.frame.width, height: CGFloat(44))))
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(selectPMTab))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        cell.pmTabTextField.inputAccessoryView = toolBar

    }

    @objc func selectPMTab() {
        campaignCell?.pmTabTextField.resignFirstResponder()
    }

    func resetTextFields(cell: CampaignTableViewCell) {
        cell.privacyManagerTextField.text = ""
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

    func toggleSection(header: ExpandableHeaderView, section: Int) {
        sections[section].expanded = !sections[section].expanded
        self.campaignsTableViewHight.constant = 150
        self.campaignIndexPath = section
        print("vilas \(self.campaignIndexPath)")
        campaignsTableView.beginUpdates()
        campaignsTableView.reloadRows(at: [IndexPath(row: 0, section: section)], with: .automatic)
        campaignsTableView.endUpdates()
    }
}

// MARK: - UITableViewDelegate
extension AddPropertyViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        targetingParamTableview.deselectRow(at: indexPath, animated: false)
    }
}

extension AddPropertyViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == messageLanguagePickerView {
            return addpropertyViewModel.countries.count
        } else {
            return addpropertyViewModel.pmTabs.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == messageLanguagePickerView {
            return addpropertyViewModel.countries[row]
        } else {
            return addpropertyViewModel.pmTabs[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == messageLanguagePickerView {
            SelectLanguageOutlet.text = addpropertyViewModel.countries[row]
        } else if pickerView == pmTabPickerView {
            self.gdprPMTab = addpropertyViewModel.pmTabs[row]
            campaignsTableView.beginUpdates()
            campaignsTableView.reloadRows(at: [IndexPath(row: 0, section: self.campaignIndexPath!)], with: .automatic)
            campaignsTableView.endUpdates()
        }
    }
}
