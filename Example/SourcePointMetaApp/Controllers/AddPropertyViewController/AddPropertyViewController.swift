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

class AddPropertyViewController: BaseViewController, TargetingParamCellDelegate, UITextFieldDelegate, WKNavigationDelegate, GDPRConsentDelegate {

    // MARK: - IBOutlet
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

    /** UISwitch outlet for Native message switch.
        */
    @IBOutlet weak var isNativeMessageSwitch: UISwitch!

    /** UILabel outlet for showing No targeting param data.
    */
    @IBOutlet weak var noTargetingParamDataLabel: UILabel!

    @IBOutlet weak var SelectLanguageOutlet: UITextField!

    @IBOutlet weak var PMTabOutlet: UITextField!

    var messageLanguagePickerView = UIPickerView()

    var pmTabPickerView = UIPickerView()

    /** Default campaign value is public
     */
    var campaign = GDPRCampaignEnv.Public

    // Reference to the selected property managed object ID
    var propertyManagedObjectID: NSManagedObjectID?

    // MARK: - Instance properties
    private let cellIdentifier = "targetingParamCell"

    // Will add all the targeting params to this array
    var targetingParams = [TargetingParamModel]()

    // this variable holds the property details entered by user
    var propertyDetailsModel: PropertyDetailsModel?

    var isPMLoaded = false

    // MARK: - Initializer
    let addpropertyViewModel: AddPropertyViewModel = AddPropertyViewModel()
    var consentViewController: GDPRConsentViewController?
    var nativeMessageController: GDPRNativeMessageViewController?

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
                self?.propertyIdTextFieldOutlet.text = String(propertyDetailsModel.propertyId)
                self?.propertyNameTextField.text = propertyDetailsModel.propertyName
                self?.privacyManagerTextField.text = propertyDetailsModel.privacyManagerId
                if let authId = propertyDetailsModel.authId {
                    self?.authIdTextField.text = authId
                }
                self?.SelectLanguageOutlet.text = propertyDetailsModel.messageLanguage
                self?.PMTabOutlet.text = propertyDetailsModel.pmId
                self?.isStagingSwitchOutlet.isOn = propertyDetailsModel.campaign == 0 ? true : false
                self?.isNativeMessageSwitch.isOn = propertyDetailsModel.nativeMessage == 1 ? true : false
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

    func addTapGestureRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(touch))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(recognizer)
    }

    func setTextFieldDelegate() {
        messageLanguagePickerView.delegate = self
        messageLanguagePickerView.dataSource = self
        pmTabPickerView.delegate = self
        pmTabPickerView.dataSource = self
        SelectLanguageOutlet.inputView = messageLanguagePickerView
        SelectLanguageOutlet.text = addpropertyViewModel.countries[0]
        PMTabOutlet.inputView = pmTabPickerView
        PMTabOutlet.text = addpropertyViewModel.pmTabs[0]
        accountIDTextFieldOutlet.delegate = self
        propertyIdTextFieldOutlet.delegate = self
        propertyNameTextField.delegate = self
        authIdTextField.delegate = self
        privacyManagerTextField.delegate = self
        keyTextFieldOutlet.delegate = self
        valueTextFieldOutlet.delegate = self
        SelectLanguageOutlet.delegate = self
        PMTabOutlet.delegate = self
        let toolBar = UIToolbar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: view.frame.width, height: CGFloat(44))))
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        SelectLanguageOutlet.inputAccessoryView = toolBar
        PMTabOutlet.inputAccessoryView = toolBar
    }

    @objc func done() {
        SelectLanguageOutlet.resignFirstResponder()
        PMTabOutlet.resignFirstResponder()
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
                if let targetingIndex = targetingParams.firstIndex(where: { $0.targetingKey == targetingKeyString}) {
                    var targetingParamModelLocal = targetingParams[targetingIndex]
                    targetingParamModelLocal.targetingValue = targetingValueString
                    targetingParams.remove(at: targetingIndex)
                    targetingParams.insert(targetingParamModelLocal, at: targetingIndex)
                } else {
                    targetingParams.append(targetingParamModel)
                }
            }

            keyTextFieldOutlet.text = ""
            valueTextFieldOutlet.text = ""
            targetingParamTableview.reloadData()
        } else {
            let okHandler = {
            }
            AlertView.sharedInstance.showAlertView(title: Alert.alert, message: Alert.messageForEmptyTargetingParamError, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
        }
    }

    func deleteButton(sender: TargetingParamCell) {
        let buttonPosition: CGPoint = sender.convert(sender.bounds.origin, to: targetingParamTableview)
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
        var authId = authIdTextField.text?.trimmingCharacters(in: .whitespaces)
        let messageLanguage = SelectLanguageOutlet.text?.trimmingCharacters(in: .whitespaces)
        let pmTab = PMTabOutlet.text?.trimmingCharacters(in: .whitespaces)
        if authId?.isEmpty ?? true {
            authId = nil
        }
        if addpropertyViewModel.validatepropertyDetails(accountID: accountIDString, propertyId: propertyId, propertyName: propertyName, privacyManagerId: privacyManagerId) {
            guard let accountIDText = accountIDString, let accountID = Int64(accountIDText),
                let propertyIDText = propertyId, let propertyID = Int64(propertyIDText) else {
                    let okHandler = {
                    }
                    self.hideIndicator()
                    AlertView.sharedInstance.showAlertView(title: Alert.alert, message: Alert.messageForWrongAccountIdAndPropertyId, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
                    return
            }
            propertyDetailsModel = PropertyDetailsModel(accountId: accountID, propertyId: propertyID, propertyName: propertyName, campaign: Int64(campaign.rawValue), privacyManagerId: privacyManagerId, creationTimestamp: Date(), authId: authId, nativeMessage: Int64(truncating: NSNumber(value: isNativeMessageSwitch.isOn)), messageLanguage: messageLanguage, pmTab: pmTab)

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

    func checkExitanceOfpropertyData(propertyDetails: PropertyDetailsModel) {
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

    func loadConsentManager(propertyDetails: PropertyDetailsModel) {
        // optional, set custom targeting parameters supports Strings and Integers
        var targetingParameters = [String: String]()
        for targetingParam in targetingParams {
            targetingParameters[targetingParam.targetingKey!] = targetingParam.targetingValue
        }
        if let propertyName = propertyDetails.propertyName, let propertyId = propertyDetails.privacyManagerId {
            do {
                consentViewController = GDPRConsentViewController(accountId: Int(propertyDetails.accountId), propertyId: Int(propertyDetails.propertyId), propertyName: try GDPRPropertyName(propertyName), PMId:propertyId , campaignEnv: campaign, targetingParams: targetingParameters, consentDelegate: self)
                if let messageLanguage = propertyDetails.messageLanguage {
                    consentViewController?.messageLanguage = addpropertyViewModel.getMessageLanguage(countryName: messageLanguage)
                }
                consentViewController?.privacyManagerTab = addpropertyViewModel.getPMTab(pmTab: propertyDetails.pmTab ?? "")
                isNativeMessageSwitch.isOn ? consentViewController?.loadNativeMessage(forAuthId: propertyDetails.authId) :
                    consentViewController?.loadMessage(forAuthId: propertyDetails.authId)
            } catch {
                let okHandler = {
                }
                self.hideIndicator()
                let errorString = error as? GDPRConsentViewControllerError
                AlertView.sharedInstance.showAlertView(title: Alert.alert, message: errorString?.description ?? "", actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
            }
        }
    }

    func gdprConsentUIWillShow() {
        hideIndicator()
        if nativeMessageController?.viewIfLoaded?.window != nil {
            nativeMessageController?.present(consentViewController!, animated: true, completion: nil)
        } else {
            present(consentViewController!, animated: true, completion: nil)
        }
    }

    func consentUIWillShow(message: GDPRMessage) {
        hideIndicator()
        if let consentViewController = consentViewController {
            nativeMessageController = GDPRNativeMessageViewController(messageContents: message, consentViewController: consentViewController)
            nativeMessageController?.modalPresentationStyle = .overFullScreen
            present(nativeMessageController!, animated: true, completion: nil)
        }
    }

    /// called on every Consent Message / PrivacyManager action. For more info on the different kinds of actions check
    /// `GDPRActionType`
    func onAction(_ action: GDPRAction) {
        if isNativeMessageSwitch.isOn {
            switch action.type {
            case .PMCancel:
                dismissPrivacyManager()
            case .ShowPrivacyManager:
                isPMLoaded = true
                showIndicator()
            case .AcceptAll:
                if !isPMLoaded {
                    consentViewController?.reportAction(action)
                    dismiss(animated: true, completion: nil)
                }
            case .RejectAll:
                if !isPMLoaded {
                    consentViewController?.reportAction(action)
                    dismiss(animated: true, completion: nil)
                }
            default:
                dismiss(animated: true, completion: nil)
            }
        }
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

    func onError(error: GDPRConsentViewControllerError) {
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

    func loadConsentInfoController(gdprUUID: GDPRUUID, userConsents: GDPRUserConsent) {
        if let consentDetailsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConsentDetailsViewController") as? ConsentDetailsViewController {
            consentDetailsController.gdprUUID = gdprUUID
            consentDetailsController.userConsents =  userConsents
            consentDetailsController.propertyDetails = propertyDetailsModel
            consentDetailsController.targetingParams = targetingParams
            self.navigationController?.pushViewController(consentDetailsController, animated: false)
        }
    }

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

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == SelectLanguageOutlet {
            return false
        }else if textField == PMTabOutlet {
            return false
        }
        return true
    }

    @objc func touch() {
        self.view.endEditing(true)
    }
}

// MARK: UITableViewDataSource
extension AddPropertyViewController: UITableViewDataSource {

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
        } else {
            PMTabOutlet.text = addpropertyViewModel.pmTabs[row]
        }
    }
}
