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
import SafariServices

class ConsentDetailsViewController: BaseViewController, WKNavigationDelegate
{

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
    var userData: SPUserData?
    let sections = ["Vendor Consents", "Purpose Consents"]

    // MARK: - Initializer
    let addpropertyViewModel: AddPropertyViewModel = AddPropertyViewModel()
//    var consentViewController: GDPRConsentViewController?
    var propertyDetails: PropertyDetailsModel?
    var targetingParams = [TargetingParamModel]()
    var nativeMessageController: SPNativeMessageViewController?

    //side menu
    private var sideMenuViewController: SideMenuViewController!
    private var sideMenuShadowView: UIView!
    private var sideMenuRevealWidth: CGFloat = 225
    private let paddingForRotation: CGFloat = 150
    private var isExpanded: Bool = false
    private var draggingIsEnabled: Bool = false
    private var panBaseLocation: CGFloat = 0.0

    // Expand/Collapse the side menu by changing trailing's constant
    private var sideMenuTrailingConstraint: NSLayoutConstraint!

    private var revealSideMenuOnTop: Bool = true
    // side menu

    override func viewDidLoad() {
        super.viewDidLoad()
        consentTableView.tableFooterView = UIView(frame: .zero)
        self.navigationItem.hidesBackButton = true
        navigationSetup()
//        setTableViewHidden()
        setconsentUUId()

//        if let _propertyManagedObjectID = propertyManagedObjectID {
//            self.showIndicator()
//            fetchDataFromDatabase(propertyManagedObjectID: _propertyManagedObjectID, completionHandler: {(propertyDetails, targetingParams) in
//                self.propertyDetails = propertyDetails
//                self.targetingParams = targetingParams
////                self.loadConsentManager(propertyDetails: propertyDetails, targetingParams: targetingParams)
//            })
//        }

        //side menu
        // Shadow Background View
        self.sideMenuShadowView = UIView(frame: self.view.bounds)
        self.sideMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.sideMenuShadowView.backgroundColor = .black
        self.sideMenuShadowView.alpha = 0.0
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapGestureRecognizer))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
        if self.revealSideMenuOnTop {
            view.insertSubview(self.sideMenuShadowView, at: 1)
        }

        // Side Menu
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        self.sideMenuViewController = storyboard.instantiateViewController(withIdentifier: "SideMenuID") as? SideMenuViewController
        self.sideMenuViewController.defaultHighlightedCell = 0 // Default Highlighted Cell
        self.sideMenuViewController.delegate = self
        view.addSubview(sideMenuViewController.view)
        self.sideMenuViewController!.didMove(toParent: self)

        // Side Menu AutoLayout
        self.sideMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false

        if self.revealSideMenuOnTop {
            self.sideMenuTrailingConstraint = self.sideMenuViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: +self.sideMenuRevealWidth + self.paddingForRotation)
            self.sideMenuTrailingConstraint.isActive = true
        }
        NSLayoutConstraint.activate([
            self.sideMenuViewController.view.widthAnchor.constraint(equalToConstant: self.sideMenuRevealWidth),
            self.sideMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.sideMenuViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        // side menu end
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

//    func setTableViewHidden() {
//        consentTableView.isHidden = !(userConsents?.acceptedVendors.count ?? 0 > 0 || userConsents?.acceptedCategories.count ?? 0 > 0)
//        noDataLabel.isHidden = userConsents?.acceptedVendors.count ?? 0 > 0 || userConsents?.acceptedCategories.count ?? 0 > 0
//    }

    func setconsentUUId() {
//        if consentUUID.count > 0 {
//            consentUUIDLabel.text = consentUUID
//            euConsentLabel.text = userConsents?.euconsent
//        } else {
//            consentUUIDLabel.text = SPLiteral.consentUUID
//            euConsentLabel.text = SPLiteral.euConsentID
//        }
    }

    // Keep the state of the side menu (expanded or collapse) in rotation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            if self.revealSideMenuOnTop {
                self.sideMenuTrailingConstraint.constant = self.isExpanded ? 0 : (self.sideMenuRevealWidth + self.paddingForRotation)
            }
        }
    }

    func animateShadow(targetPosition: CGFloat) {
        UIView.animate(withDuration: 0.5) {
            // When targetPosition is 0, which means side menu is expanded, the shadow opacity is 0.6
            self.sideMenuShadowView.alpha = (targetPosition == 0) ? 0.6 : 0.0
        }
    }

    func fetchDataFromDatabase(propertyManagedObjectID: NSManagedObjectID, completionHandler: @escaping (PropertyDetailsModel, [TargetingParamModel]) -> Void) {
//        self.addpropertyViewModel.fetch(property: propertyManagedObjectID, completionHandler: {( propertyDataModel) in
//            let propertyDetail = PropertyDetailsModel(accountId: propertyDataModel.accountId, propertyId: propertyDataModel.propertyId, propertyName: propertyDataModel.propertyName, campaign: propertyDataModel.campaign, privacyManagerId: propertyDataModel.privacyManagerId, creationTimestamp: propertyDataModel.creationTimestamp!, authId: propertyDataModel.authId, nativeMessage: propertyDataModel.nativeMessage, messageLanguage: propertyDataModel.messageLanguage, pmTab: propertyDataModel.pmId)
//            var targetingParamsArray = [TargetingParamModel]()
//            if let targetingParams = propertyDataModel.manyTargetingParams?.allObjects as! [TargetingParams]? {
//                for targetingParam in targetingParams {
//                    let targetingParamModel = TargetingParamModel(targetingParamKey: targetingParam.key, targetingParamValue: targetingParam.value)
//                    targetingParamsArray.append(targetingParamModel)
//                }
//            }
//            completionHandler(propertyDetail, targetingParamsArray)
//        })
    }

//    func loadConsentManager(propertyDetails: PropertyDetailsModel, targetingParams: [TargetingParamModel]) {
//        let campaign: SPCampaignEnv = propertyDetails.campaign == 0 ? .Stage : .Public
//        // optional, set custom targeting parameters supports Strings and Integers
//        var targetingParameters = [String: String]()
//        for targetingParam in targetingParams {
//            targetingParameters[targetingParam.targetingKey!] = targetingParam.targetingValue
//        }
//        consentViewController = GDPRConsentViewController(accountId: Int(propertyDetails.accountId), propertyId: Int(propertyDetails.propertyId), propertyName: try! SPPropertyName(propertyDetails.propertyName!), PMId: propertyDetails.privacyManagerId!, campaignEnv: campaign, targetingParams: targetingParameters, consentDelegate: self)
//        if let messageLanguage = propertyDetails.messageLanguage {
//            consentViewController?.messageLanguage = addpropertyViewModel.getMessageLanguage(countryName: messageLanguage)
//        }
//        consentViewController?.privacyManagerTab = addpropertyViewModel.getPMTab(pmTab: propertyDetails.pmTab ?? "")
//        propertyDetails.nativeMessage == 1 ? consentViewController?.loadNativeMessage(forAuthId: propertyDetails.authId) :
//            consentViewController?.loadMessage(forAuthId: propertyDetails.authId)
//    }

//    func gdprConsentUIWillShow() {
//        hideIndicator()
//        if nativeMessageController?.viewIfLoaded?.window != nil {
//            nativeMessageController?.present(consentViewController!, animated: true, completion: nil)
//        } else {
//            present(self.consentViewController!, animated: true, completion: nil)
//        }
//    }

    func consentUIDidDisappear() {
        dismiss(animated: true, completion: nil)
    }

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
//        if propertyDetails?.nativeMessage == 1 {
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

//    func onConsentReady(consentUUID: SPConsentUUID, userConsent: SPGDPRConsent) {
//        self.showIndicator()
//        self.userConsents = userConsent
//        self.consentUUID = consentUUID
//        setconsentUUId()
//        consentTableView.reloadData()
//        self.hideIndicator()
//    }

    func onError(error: SPError) {
        let okHandler = {
            self.hideIndicator()
            self.dismiss(animated: false, completion: nil)
        }
        AlertView.sharedInstance.showAlertView(title: Alert.message, message: error.description , actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
    }

    private func dismissPrivacyManager() {
        if nativeMessageController?.viewIfLoaded?.window != nil {
            nativeMessageController?.dismiss(animated: true, completion: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func showPMAction(_ sender: Any) {
//        self.showIndicator()
//        let campaign: SPCampaignEnv = self.propertyDetails?.campaign == 0 ? .Stage : .Public
        // optional, set custom targeting parameters supports Strings and Integers
//        var targetingParameters = [String: String]()
//        for targetingParam in targetingParams {
//            targetingParameters[targetingParam.targetingKey] = targetingParam.targetingValue
//        }
//        consentViewController =  GDPRConsentViewController(accountId: Int(propertyDetails!.accountId), propertyId: Int(propertyDetails!.propertyId), propertyName: try! SPPropertyName((propertyDetails?.propertyName)!), PMId: (propertyDetails?.privacyManagerId)!, campaignEnv: campaign, targetingParams: targetingParameters, consentDelegate: self)
//        if let messageLanguage = propertyDetails?.messageLanguage {
//            consentViewController?.messageLanguage = addpropertyViewModel.getMessageLanguage(countryName: messageLanguage)
//        }
//        consentViewController?.privacyManagerTab = addpropertyViewModel.getPMTab(pmTab: propertyDetails?.pmTab ?? "")
//        consentViewController?.loadPrivacyManager()
//        consentTableView.isHidden = true
        self.sideMenuState(expanded: self.isExpanded ? false : true)
    }

    func sideMenuState(expanded: Bool) {
        if expanded {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? 0 : self.sideMenuRevealWidth) { _ in
                self.isExpanded = true
            }
            // Animate Shadow (Fade In)
            UIView.animate(withDuration: 0.5) { self.sideMenuShadowView.alpha = 0.6 }
        }
        else {
            self.animateSideMenu(targetPosition: self.revealSideMenuOnTop ? (self.sideMenuRevealWidth + self.paddingForRotation) : 0) { _ in
                self.isExpanded = false
            }
            // Animate Shadow (Fade Out)
            UIView.animate(withDuration: 0.5) { self.sideMenuShadowView.alpha = 0.0 }
        }
    }

    func animateSideMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews, animations: {
            if self.revealSideMenuOnTop {
                self.sideMenuTrailingConstraint.constant = targetPosition
                self.view.layoutIfNeeded()
            }
            else {
                self.view.subviews[1].frame.origin.x = targetPosition
            }
        }, completion: completion)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
//        setTableViewHidden()
        if section == 0 {
//            return userConsents?.acceptedVendors.count ?? 0
        } else {
//            return userConsents?.acceptedCategories.count ?? 0
        }
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConsentTableViewCell {
            if indexPath.section == 0 {
//                cell.consentIDString.text = userConsents?.acceptedVendors[indexPath.row]
            } else {
//                cell.consentIDString.text = userConsents?.acceptedCategories[indexPath.row]
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

extension ConsentDetailsViewController: SideMenuViewControllerDelegate {
    func selectedCell(_ row: Int) {
        switch row {
        case 0:
            print("1")
        case 1:
        print("2")
        case 2:
            print("3")
        default:
            break
        }
        // Collapse side menu with animation
        DispatchQueue.main.async { self.sideMenuState(expanded: false) }
    }
}

extension ConsentDetailsViewController: UIGestureRecognizerDelegate {
    @objc func TapGestureRecognizer(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if self.isExpanded {
                self.sideMenuState(expanded: false)
            }
        }
    }

    // Close side menu when you tap on the shadow background view
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: self.sideMenuViewController.view))! {
            return false
        }
        return true
    }
}

