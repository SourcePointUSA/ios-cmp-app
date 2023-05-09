//
//  SPGDPRNativePrivacyManagerViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Vilas on 01/04/21.
//

import Foundation
import UIKit

// swiftlint:disable function_body_length

protocol SPNativePrivacyManagerHome {
    var delegate: SPNativePMDelegate? { get set }
}

@objcMembers class SPGDPRNativePrivacyManagerViewController: SPNativeScreenViewController, SPNativePrivacyManagerHome {
    weak var delegate: SPNativePMDelegate?

    var secondLayerData: GDPRPrivacyManagerViewResponse?

    var categories: [GDPRCategory] = []
    var vendorGrants: SPGDPRVendorGrants?
    let cellReuseIdentifier = "cell"

    var snapshot: GDPRPMConsentSnaptshot?

    override var preferredFocusedView: UIView? { acceptButton }

    @IBOutlet var categoriesExplainerLabel: UILabel!
    @IBOutlet var descriptionTextView: SPFocusableTextView!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var ourPartners: SPAppleTVButton!
    @IBOutlet var managePreferenceButton: SPAppleTVButton!
    @IBOutlet var acceptButton: SPAppleTVButton!
    @IBOutlet var rejectButton: SPAppleTVButton!
    @IBOutlet var saveAndExitButton: SPAppleTVButton!
    @IBOutlet var privacyPolicyButton: SPAppleTVButton!
    @IBOutlet var categoryTableView: UITableView!
    @IBOutlet var header: SPPMHeader!
    @IBOutlet var buttonsStack: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "GDPR Message"
        setHeader()
        loadTextView(forComponentId: "PublisherDescription", textView: descriptionTextView, bounces: false)
        descriptionTextView.flashScrollIndicators()
        loadButton(forComponentId: "AcceptAllButton", button: acceptButton)
        loadButton(forComponentId: "RejectAllButton", button: rejectButton)
        loadButton(forComponentId: "SaveAndExitButton", button: saveAndExitButton)
        loadButton(forComponentId: "NavCategoriesButton", button: managePreferenceButton)
        loadButton(forComponentId: "NavVendorsButton", button: ourPartners)
        loadButton(forComponentId: "NavPrivacyPolicyButton", button: privacyPolicyButton)
        loadImage(forComponentId: "LogoImage", imageView: logoImageView)
        setFocusGuidesForButtons()
        categoryTableView.accessibilityIdentifier = "Categories List"
        categoryTableView.allowsSelection = false
        categoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        disableMenuButton()
    }

    @IBAction func onAcceptTap(_ sender: Any) {
        action(
            SPAction(type: .AcceptAll, campaignType: campaignType),
            from: self
        )
    }

    @IBAction func onRejectTap(_ sender: Any) {
        action(
            SPAction(type: .RejectAll, campaignType: campaignType),
            from: self
        )
    }

    @IBAction func onSaveAndExitTap(_ sender: Any) {
        messageUIDelegate?.action(SPAction(
            type: .SaveAndExit,
            campaignType: campaignType,
            pmPayload: snapshot?.toPayload(language: .English, pmId: messageId).json() ?? SPJson()
        ), from: self)
    }

    @IBAction func onManagePreferenceTap(_ sender: Any) {
        guard let secondLayerData = secondLayerData else {
            delegate?.onGDPR2ndLayerNavigate(messageId: messageId) { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.onError(error)

                case .success(let data):
                    if let strongSelf = self {
                        strongSelf.secondLayerData = data
                        let controller = SPGDPRManagePreferenceViewController(
                            messageId: strongSelf.messageId,
                            campaignType: strongSelf.campaignType,
                            viewData: strongSelf.pmData.categoriesView,
                            pmData: strongSelf.pmData,
                            delegate: self,
                            nibName: "SPGDPRManagePreferenceViewController"
                        )
                        if self?.snapshot == nil {
                            self?.snapshot = GDPRPMConsentSnaptshot(
                                grants: data.grants ?? SPGDPRVendorGrants(),
                                vendors: Set<GDPRVendor>(data.vendors),
                                categories: Set<GDPRCategory>(data.categories),
                                specialPurposes: Set<GDPRCategory>(data.specialPurposes),
                                features: Set<GDPRCategory>(data.features),
                                specialFeatures: Set<GDPRCategory>(data.specialFeatures)
                            )
                        }
                        controller.categories = data.categories
                        controller.consentsSnapshot = strongSelf.snapshot! // swiftlint:disable:this force_unwrapping
                        self?.present(controller, animated: true)
                    }
                }
            }
            return
        }
        let controller = SPGDPRManagePreferenceViewController(
            messageId: messageId,
            campaignType: campaignType,
            viewData: pmData.categoriesView,
            pmData: pmData,
            delegate: self,
            nibName: "SPGDPRManagePreferenceViewController"
        )
        if snapshot == nil {
            snapshot = GDPRPMConsentSnaptshot(
                grants: secondLayerData.grants ?? SPGDPRVendorGrants(),
                vendors: Set<GDPRVendor>(secondLayerData.vendors),
                categories: Set<GDPRCategory>(secondLayerData.categories),
                specialPurposes: Set<GDPRCategory>(secondLayerData.specialPurposes),
                features: Set<GDPRCategory>(secondLayerData.features),
                specialFeatures: Set<GDPRCategory>(secondLayerData.specialFeatures)
            )
        }
        controller.categories = secondLayerData.categories
        controller.consentsSnapshot = snapshot! // swiftlint:disable:this force_unwrapping
        present(controller, animated: true)
    }

    @IBAction func onPartnersTap(_ sender: Any) {
        delegate?.onGDPR2ndLayerNavigate(messageId: messageId) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.onError(error)

            case .success(let data):
                if let strongSelf = self {
                    if self?.snapshot == nil {
                        self?.snapshot = GDPRPMConsentSnaptshot(
                            grants: data.grants ?? SPGDPRVendorGrants(),
                            vendors: Set<GDPRVendor>(data.vendors),
                            categories: Set<GDPRCategory>(data.categories),
                            specialPurposes: Set<GDPRCategory>(data.specialPurposes),
                            features: Set<GDPRCategory>(data.features),
                            specialFeatures: Set<GDPRCategory>(data.specialFeatures)
                        )
                    }
                    let controller = SPGDPRPartnersViewController(
                        messageId: strongSelf.messageId,
                        campaignType: strongSelf.campaignType,
                        viewData: strongSelf.pmData.vendorsView,
                        pmData: strongSelf.pmData,
                        delegate: self,
                        nibName: "SPGDPRPartnersViewController"
                    )
                    controller.vendors = data.vendors
                    controller.consentsSnapshot = strongSelf.snapshot! // swiftlint:disable:this force_unwrapping
                    self?.present(controller, animated: true)
                }
            }
        }
    }

    @IBAction func onPrivacyPolicyTap(_ sender: Any) {
        guard let privacyPolicyView = pmData.privacyPolicyView else {
            onError(UnableToFindView(withId: "PrivacyPolicyView"))
            return
        }
        present(SPPrivacyPolicyViewController(
            messageId: messageId,
            campaignType: campaignType,
            viewData: privacyPolicyView,
            pmData: pmData,
            delegate: self,
            nibName: "SPPrivacyPolicyViewController"
        ), animated: true)
    }

    func setHeader () {
        header.spBackButton = viewData.byId("CloseButton") as? SPNativeButton
        header.spTitleText = viewData.byId("Header") as? SPNativeText
        header.onBackButtonTapped = { [weak self] in
            if let this = self {
                self?.messageUIDelegate?.action(SPAction(type: .Dismiss), from: this)
            }
        }
    }

    override func loadMessage() {
        loaded(self)
    }

    override func setFocusGuides() {
        addFocusGuide(from: descriptionTextView, to: categoryTableView, direction: .bottomTop)
    }

    func setFocusGuidesForButtons() {
        let visibleButtons: [UIView] = buttonsStack.arrangedSubviews.filter({ !$0.isHidden })
        for i in 0...visibleButtons.count - 2 {
            addFocusGuide(from: visibleButtons[i], to: visibleButtons[i + 1], direction: .bottomTop)
        }
    }

    func disableMenuButton() {
        let menuPressRecognizer = UITapGestureRecognizer()
        menuPressRecognizer.addTarget(self, action: #selector(menuButtonAction))
        menuPressRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
        view.addGestureRecognizer(menuPressRecognizer)
    }

    func menuButtonAction() {
        // override in order to disable menu button closing the Privacy Manager
    }
}

extension SPGDPRNativePrivacyManagerViewController: SPMessageUIDelegate {
    func loaded(_ message: SPNativeMessage) {}

    func loaded(_ controller: UIViewController) {
        messageUIDelegate?.loaded(self)
    }

    func action(_ action: SPAction, from controller: UIViewController) {
        dismiss(animated: false) {
            self.messageUIDelegate?.action(action, from: controller)
        }
    }

    func onError(_ error: SPError) {
        messageUIDelegate?.onError(error)
    }

    func finished(_ vcFinished: UIViewController) {}
}

// MARK: UITableViewDataSource
extension SPGDPRNativePrivacyManagerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        cell.textLabel?.setDefaultTextColorForDarkMode()
        addFocusGuide(from: acceptButton, to: cell, direction: .rightLeft)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SPGDPRNativePrivacyManagerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
        true
    }
}

class FocusableScrollView: UIScrollView {
    override var canBecomeFocused: Bool {
        true
    }
}
