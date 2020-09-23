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

class ConsentDetailsViewController: BaseViewController, WKNavigationDelegate, GDPRConsentDelegate {

    @IBOutlet weak var euConsentLabel: UILabel!
    @IBOutlet weak var consentUUIDLabel: UILabel!
    @IBOutlet weak var consentTableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!

    // MARK: - Instance properties
    private let cellIdentifier = "ConsentCell"

    // Reference to the selected property managed object ID
    var propertyManagedObjectID: NSManagedObjectID?

    /** PM is loaded or not
     */
    var isPMLoaded = false
    var userConsents: GDPRUserConsent?
    var gdprUUID: String = ""
    let sections = ["Vendor Consents", "Purpose Consents"]

    // MARK: - Initializer
    let addpropertyViewModel: AddPropertyViewModel = AddPropertyViewModel()
    var consentViewController: GDPRConsentViewController?
    var propertyDetails: PropertyDetailsModel?
    var targetingParams = [TargetingParamModel]()
    var nativeMessageController: GDPRNativeMessageViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        consentTableView.tableFooterView = UIView(frame: .zero)
        self.navigationItem.hidesBackButton = true
        navigationSetup()
        setTableViewHidden()
        setconsentUUId()

        if let _propertyManagedObjectID = propertyManagedObjectID {
            self.showIndicator()
            fetchDataFromDatabase(propertyManagedObjectID: _propertyManagedObjectID, completionHandler: {(propertyDetails, targetingParams) in
                self.propertyDetails = propertyDetails
                self.targetingParams = targetingParams
                self.loadConsentManager(propertyDetails: propertyDetails, targetingParams: targetingParams)
            })
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setconsentUUId()
    }

    func navigationSetup() {

        let backIcon = UIButton(frame: CGRect.zero)
        backIcon.setImage(UIImage(named: "Back"), for: UIControl.State())
        backIcon.addTarget(self, action: #selector(back), for: UIControl.Event.touchUpInside)
        let backIconBarButton: UIBarButtonItem = UIBarButtonItem(customView: backIcon)
        backIcon.sizeToFit()
        self.navigationItem.leftBarButtonItem = backIconBarButton
    }

    @objc func back() {
        _ = self.navigationController?.popToRootViewController(animated: false)
    }

    func setTableViewHidden() {
        consentTableView.isHidden = !(userConsents?.acceptedVendors.count ?? 0 > 0 || userConsents?.acceptedCategories.count ?? 0 > 0)
        noDataLabel.isHidden = userConsents?.acceptedVendors.count ?? 0 > 0 || userConsents?.acceptedCategories.count ?? 0 > 0
    }

    func setconsentUUId() {
        if gdprUUID.count > 0 {
            consentUUIDLabel.text = gdprUUID
            euConsentLabel.text = userConsents?.euconsent
        } else {
            consentUUIDLabel.text = SPLiteral.consentUUID
            euConsentLabel.text = SPLiteral.euConsentID
        }
    }

    func fetchDataFromDatabase(propertyManagedObjectID: NSManagedObjectID, completionHandler: @escaping (PropertyDetailsModel, [TargetingParamModel]) -> Void) {
        self.addpropertyViewModel.fetch(property: propertyManagedObjectID, completionHandler: {( propertyDataModel) in
            let propertyDetail = PropertyDetailsModel(accountId: propertyDataModel.accountId, propertyId: propertyDataModel.propertyId, propertyName: propertyDataModel.propertyName, campaign: propertyDataModel.campaign, privacyManagerId: propertyDataModel.privacyManagerId, creationTimestamp: propertyDataModel.creationTimestamp!, authId: propertyDataModel.authId, nativeMessage: propertyDataModel.nativeMessage)
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

    func loadConsentManager(propertyDetails: PropertyDetailsModel, targetingParams: [TargetingParamModel]) {
        let campaign: GDPRCampaignEnv = propertyDetails.campaign == 0 ? .Stage : .Public
        // optional, set custom targeting parameters supports Strings and Integers
        var targetingParameters = [String: String]()
        for targetingParam in targetingParams {
            targetingParameters[targetingParam.targetingKey!] = targetingParam.targetingValue
        }
        consentViewController = GDPRConsentViewController(accountId: Int(propertyDetails.accountId), propertyId: Int(propertyDetails.propertyId), propertyName: try! GDPRPropertyName(propertyDetails.propertyName!), PMId: propertyDetails.privacyManagerId!, campaignEnv: campaign, targetingParams: targetingParameters, consentDelegate: self)
        propertyDetails.nativeMessage == 1 ? consentViewController?.loadNativeMessage(forAuthId: propertyDetails.authId) :
            consentViewController?.loadMessage(forAuthId: propertyDetails.authId)
    }

    func gdprConsentUIWillShow() {
        hideIndicator()
        if nativeMessageController?.viewIfLoaded?.window != nil {
            nativeMessageController?.present(consentViewController!, animated: true, completion: nil)
        } else {
            present(self.consentViewController!, animated: true, completion: nil)
        }
    }

    func consentUIDidDisappear() {
        dismiss(animated: true, completion: nil)
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
        switch action.type {
        case .PMCancel:
            dismissPrivacyManager()
        case .ShowPrivacyManager:
            isPMLoaded = true
            showIndicator()
        case .AcceptAll:
            if propertyDetails?.nativeMessage == 1 && !isPMLoaded {
                consentViewController?.reportAction(action)
                dismiss(animated: true, completion: nil)
            }
        case .RejectAll:
            if propertyDetails?.nativeMessage == 1 && !isPMLoaded {
                consentViewController?.reportAction(action)
                dismiss(animated: true, completion: nil)
            }
        default:
            if propertyDetails?.nativeMessage == 1 {
                dismiss(animated: true, completion: nil)
            }
        }
    }

    func onConsentReady(gdprUUID: GDPRUUID, userConsent: GDPRUserConsent) {
        self.showIndicator()
        self.userConsents = userConsent
        self.gdprUUID = gdprUUID
        setconsentUUId()
        consentTableView.reloadData()
        self.hideIndicator()
    }

    func onError(error: GDPRConsentViewControllerError?) {
        let okHandler = {
            self.hideIndicator()
            self.dismiss(animated: false, completion: nil)
        }
        AlertView.sharedInstance.showAlertView(title: Alert.message, message: error?.description ?? "Something Went Wrong", actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
    }

    private func dismissPrivacyManager() {
        if nativeMessageController?.viewIfLoaded?.window != nil {
            nativeMessageController?.dismiss(animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func showPMAction(_ sender: Any) {
        self.showIndicator()
        let campaign: GDPRCampaignEnv = self.propertyDetails?.campaign == 0 ? .Stage : .Public
        // optional, set custom targeting parameters supports Strings and Integers
        var targetingParameters = [String: String]()
        for targetingParam in targetingParams {
            targetingParameters[targetingParam.targetingKey!] = targetingParam.targetingValue
        }
        consentViewController =  GDPRConsentViewController(accountId: Int(propertyDetails!.accountId), propertyId: Int(propertyDetails!.propertyId), propertyName: try! GDPRPropertyName((propertyDetails?.propertyName)!), PMId: (propertyDetails?.privacyManagerId)!, campaignEnv: campaign, targetingParams: targetingParameters, consentDelegate: self)
        consentViewController?.loadPrivacyManager()
    }
}

// MARK: UITableViewDataSource
extension ConsentDetailsViewController: UITableViewDataSource {

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
            return userConsents?.acceptedVendors.count ?? 0
        } else {
            return userConsents?.acceptedCategories.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConsentTableViewCell {
            if indexPath.section == 0 {
                cell.consentIDString.text = userConsents?.acceptedVendors[indexPath.row]
            } else {
                cell.consentIDString.text = userConsents?.acceptedCategories[indexPath.row]
            }
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension ConsentDetailsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        consentTableView.deselectRow(at: indexPath, animated: false)
    }
}
