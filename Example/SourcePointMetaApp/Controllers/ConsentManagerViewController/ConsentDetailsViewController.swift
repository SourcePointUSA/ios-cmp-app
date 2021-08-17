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

class ConsentDetailsViewController: BaseViewController, WKNavigationDelegate {

    @IBOutlet weak var gdprConsentUUIDLabel: UILabel!
    @IBOutlet weak var ccpaConsentUUIDLabel: UILabel!
    @IBOutlet weak var euConsentLabel: UILabel!
    @IBOutlet weak var consentTableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!

    // MARK: - Instance properties
    private let cellIdentifier = "ConsentCell"

    // Reference to the selected property managed object ID
    var propertyManagedObjectID: NSManagedObjectID?
    var userData: SPUserData?
    var isReset = false

    // MARK: - Initializer
    let addpropertyViewModel: AddPropertyViewModel = AddPropertyViewModel()
    let consentDetailsViewModel: ConsentDetailsViewModel = ConsentDetailsViewModel()
    var consentManager: SPConsentManager?
    var propertyDetails: PropertyDetailsModel?

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

    override func viewDidLoad() {
        super.viewDidLoad()
        consentTableView.tableFooterView = UIView(frame: .zero)
        navigationItem.hidesBackButton = true
        navigationSetup()
        setTableViewHidden()
        setconsentUUId()

        if let _propertyManagedObjectID = propertyManagedObjectID {
            showIndicator()
            consentDetailsViewModel.fetchPropertyFromDatabase(propertyManagedObjectID: _propertyManagedObjectID, completionHandler: { [weak self] (propertyDetails) in
                self?.propertyDetails = propertyDetails
                self?.loadConsentManager()
            })
        }

        // Shadow Background View
        sideMenuShadowView = UIView(frame: view.bounds)
        sideMenuShadowView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        sideMenuShadowView.backgroundColor = .black
        sideMenuShadowView.alpha = 0.0
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TapGestureRecognizer))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
        if revealSideMenuOnTop {
            view.insertSubview(sideMenuShadowView, at: 1)
        }

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        sideMenuViewController = storyboard.instantiateViewController(withIdentifier: "SideMenuID") as? SideMenuViewController
        sideMenuViewController.defaultHighlightedCell = 0 // Default Highlighted Cell
        sideMenuViewController.delegate = self
        view.addSubview(sideMenuViewController.view)
        sideMenuViewController!.didMove(toParent: self)
        sideMenuViewController.view.translatesAutoresizingMaskIntoConstraints = false
        if revealSideMenuOnTop {
            sideMenuTrailingConstraint = sideMenuViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: +sideMenuRevealWidth + paddingForRotation)
            sideMenuTrailingConstraint.isActive = true
        }
        NSLayoutConstraint.activate([
            sideMenuViewController.view.widthAnchor.constraint(equalToConstant: sideMenuRevealWidth),
            sideMenuViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sideMenuViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])
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
        navigationItem.leftBarButtonItem = backIconBarButton
    }

    @objc func back() {
        _ = navigationController?.popToRootViewController(animated: false)
    }

    func setTableViewHidden() {
        let isConsentsPresent = userData?.gdpr?.consents?.vendorGrants.count ?? 0 > 0 || userData?.ccpa?.consents?.rejectedCategories.count ?? 0 > 0 || userData?.ccpa?.consents?.rejectedVendors.count ?? 0 > 0
        consentTableView.isHidden = !isConsentsPresent
        noDataLabel.isHidden = isConsentsPresent
    }

    func setconsentUUId() {
        if let gdprUUID = userData?.gdpr?.consents?.uuid {
            gdprConsentUUIDLabel.text = gdprUUID
            euConsentLabel.text = userData?.gdpr?.consents?.euconsent
        } else {
            gdprConsentUUIDLabel.text = SPLiteral.gdprConsentUUID
            euConsentLabel.text = SPLiteral.euConsentID
        }
        if let ccpaUUID = userData?.ccpa?.consents?.uuid {
            ccpaConsentUUIDLabel.text = ccpaUUID
        } else {
            ccpaConsentUUIDLabel.text = SPLiteral.ccpaConsentUUID
        }
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
        UIView.animate(withDuration: 0.5) { [weak self] in
            // When targetPosition is 0, which means side menu is expanded, the shadow opacity is 0.6
            self?.sideMenuShadowView.alpha = (targetPosition == 0) ? 0.6 : 0.0
        }
    }

    func validateProperty() {
        let campaignEnv: SPCampaignEnv = propertyDetails?.campaignEnv == 0 ? .Stage : .Public
        if let propertyName = propertyDetails?.propertyName, let accountID = propertyDetails?.accountId {
            do {
                consentManager = SPConsentManager(accountId: Int(accountID), propertyName: try SPPropertyName(propertyName), campaignsEnv: campaignEnv, campaigns: SPCampaigns(
                    gdpr: consentDetailsViewModel.gdprCampaign(),
                    ccpa: addpropertyViewModel.ccpaCampaign(),
                    ios14: addpropertyViewModel.iOS14Campaign()
                ), delegate: self)
            } catch {
                showError(error: error as? SPError)
            }
        }
        consentManager?.messageLanguage = addpropertyViewModel.getMessageLanguage(countryName: propertyDetails?.messageLanguage ?? "")
    }

    func loadConsentManager() {
        validateProperty()
        consentManager?.loadMessage(forAuthId: propertyDetails?.authId)
    }

    func onError(error: SPError) {
        let okHandler = { [weak self] in
            self?.hideIndicator()
            self?.dismiss(animated: false, completion: nil)
        }
        AlertView.sharedInstance.showAlertView(title: Alert.message, message: error.description , actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
    }

    @IBAction func showPMAction(_ sender: Any) {
        sideMenuState(expanded: isExpanded ? false : true)
    }

    func sideMenuState(expanded: Bool) {
        if expanded {
            animateSideMenu(targetPosition: revealSideMenuOnTop ? 0 : sideMenuRevealWidth) { [weak self] _ in
                self?.isExpanded = true
            }
            // Animate Shadow (Fade In)
            UIView.animate(withDuration: 0.5) { [weak self] in self?.sideMenuShadowView.alpha = 0.6 }
        }
        else {
            animateSideMenu(targetPosition: revealSideMenuOnTop ? (sideMenuRevealWidth + paddingForRotation) : 0) { [weak self] _ in
                self?.isExpanded = false
            }
            // Animate Shadow (Fade Out)
            UIView.animate(withDuration: 0.5) { [weak self] in self?.sideMenuShadowView.alpha = 0.0 }
        }
    }

    func animateSideMenu(targetPosition: CGFloat, completion: @escaping (Bool) -> ()) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: .layoutSubviews, animations: { [weak self] in
            if ((self?.revealSideMenuOnTop) != nil) {
                self?.sideMenuTrailingConstraint.constant = targetPosition
                self?.view.layoutIfNeeded()
            }
            else {
                self?.view.subviews[1].frame.origin.x = targetPosition
            }
        }, completion: completion)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - SPDelegate implementation
extension ConsentDetailsViewController: SPDelegate {
    func onSPUIReady(_ controller: SPMessageViewController) {
        hideIndicator()
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true)
    }

    func onSPUIFinished(_ controller: SPMessageViewController) {
        dismiss(animated: true)
    }

    func onAction(_ action: SPAction, from controller: SPMessageViewController) {
        print(action)
    }

    func onConsentReady(userData: SPUserData) {
        showIndicator()
        self.userData = userData
        handleMultipleMessages(userData: userData)
    }

    func handleMultipleMessages(userData: SPUserData) {
        if isReset {
            if let ccpaApplies = consentManager?.ccpaApplies, let gdprApplies = consentManager?.gdprApplies {
                if !ccpaApplies && gdprApplies || ccpaApplies && !gdprApplies {
                    updateConsentTableview()
                    hideIndicator()
                } else if ccpaApplies && gdprApplies {
                    showIndicator()
                    updateConsentTableview()
                    isReset = false
                }
            }
        } else {
            updateConsentTableview()
            hideIndicator()
        }
    }

    func updateConsentTableview() {
        setconsentUUId()
        consentTableView.reloadData()
    }

    func showError(error: SPError?) {
        let okHandler = {}
        hideIndicator()
        AlertView.sharedInstance.showAlertView(title: Alert.alert, message: error?.description ?? "", actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
    }
}

// MARK: UITableViewDataSource
extension ConsentDetailsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return consentDetailsViewModel.sections(userData: userData)?.count ?? 0
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return consentDetailsViewModel.sections(userData: userData)?[section]
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
        if consentDetailsViewModel.sections(userData: userData)?[section] == SPLiteral.gdprConsents {
            return userData?.gdpr?.consents?.vendorGrants.count ?? 0
        } else if consentDetailsViewModel.sections(userData: userData)?[section] == SPLiteral.ccpaConsents {
            if userData?.ccpa?.consents?.rejectedCategories.count ?? 0 > 0 {
                return (userData?.ccpa?.consents?.rejectedCategories.count ?? 0)
            } else {
                return 1
            }
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConsentTableViewCell {
            if indexPath.section == 0 && consentDetailsViewModel.sections(userData: userData)?[0] == SPLiteral.gdprConsents {
                var vendorGrantsIDs = [String]()
                userData?.gdpr?.consents?.vendorGrants.forEach {(key, value) in
                    vendorGrantsIDs.append(key)
                }
                cell.consentIDLabel.text = SPLiteral.vendorGrantID
                cell.consentIDString.text = vendorGrantsIDs[indexPath.row]
            } else {
                if userData?.ccpa?.consents?.rejectedCategories.count ?? 0 > 0 {
                    cell.consentIDLabel.text = SPLiteral.rejectedCategoryID
                    cell.consentIDString.text = userData?.ccpa?.consents?.rejectedCategories[indexPath.row]
                } else {
                    if let status = userData?.ccpa?.consents?.status.rawValue {
                        cell.consentIDLabel.text = SPLiteral.ccpaStatus
                        cell.consentIDString.text = status
                    }
                }
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
            showIndicator()
            let pmDetails = consentDetailsViewModel.getPMIDAndTab(campaignName: SPLiteral.gdprCampaign, campaignDetails: propertyDetails?.campaignDetails)
            if let pmID = pmDetails.pmID, let pmTab = pmDetails.pmTab, pmID.count > 0 {
                loadPrivacyManager(isGDPRPM: true, pmID: pmID, pmTab: pmTab)
            } else {
                let okHandler = { [weak self]() -> Void in self?.hideIndicator() }
                AlertView.sharedInstance.showAlertView(title: Alert.alert, message: Alert.messageForEmptyPrivacyManagerIDError, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
            }
        case 1:
            showIndicator()
            let pmDetails = consentDetailsViewModel.getPMIDAndTab(campaignName: SPLiteral.ccpaCampaign, campaignDetails: propertyDetails?.campaignDetails)
            if let pmID = pmDetails.pmID, let pmTab = pmDetails.pmTab, pmID.count > 0 {
                loadPrivacyManager(isGDPRPM: false, pmID: pmID, pmTab: pmTab)
            } else {
                let okHandler = { [weak self]() -> Void in self?.hideIndicator() }
                AlertView.sharedInstance.showAlertView(title: Alert.alert, message: Alert.messageForEmptyPrivacyManagerIDError, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
            }
        case 2:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "wormholy_fire"), object: nil)
        default:
            break
        }
        // Collapse side menu with animation
        DispatchQueue.main.async { [weak self] in self?.sideMenuState(expanded: false) }
    }

    func loadPrivacyManager(isGDPRPM: Bool, pmID: String, pmTab: String) {
        validateProperty()
        if isGDPRPM {
            consentManager?.loadGDPRPrivacyManager(withId: pmID, tab: addpropertyViewModel.getPMTab(pmTab: pmTab))
        } else {
            consentManager?.loadCCPAPrivacyManager(withId: pmID, tab: addpropertyViewModel.getPMTab(pmTab: pmTab))
        }
    }
}

extension ConsentDetailsViewController: UIGestureRecognizerDelegate {
    @objc func TapGestureRecognizer(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if isExpanded { sideMenuState(expanded: false) }
        }
    }

    // Close side menu when you tap on the shadow background view
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if ((touch.view?.isDescendant(of: sideMenuViewController.view)) != nil) { return false }
        return true
    }
}

