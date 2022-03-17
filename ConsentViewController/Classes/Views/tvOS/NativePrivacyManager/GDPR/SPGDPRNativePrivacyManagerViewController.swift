//
//  SPGDPRNativePrivacyManagerViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Vilas on 01/04/21.
//

import UIKit
import Foundation

protocol SPNativePrivacyManagerHome {
    var delegate: SPNativePMDelegate? { get set }
}

@objcMembers class SPGDPRNativePrivacyManagerViewController: SPNativeScreenViewController, SPNativePrivacyManagerHome {
    weak var delegate: SPNativePMDelegate?

    @IBOutlet weak var categoriesExplainerLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var selectedCategoryTextLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var ourPartners: SPAppleTVButton!
    @IBOutlet weak var managePreferenceButton: SPAppleTVButton!
    @IBOutlet weak var acceptButton: SPAppleTVButton!
    @IBOutlet weak var rejectButton: SPAppleTVButton!
    @IBOutlet weak var saveAndExitButton: SPAppleTVButton!
    @IBOutlet weak var privacyPolicyButton: SPAppleTVButton!
    @IBOutlet weak var categoryTableView: UITableView!
    @IBOutlet weak var header: SPPMHeader!

    var secondLayerData: GDPRPrivacyManagerViewResponse?

    var categories: [GDPRCategory] = []
    var vendorGrants: SPGDPRVendorGrants?
    let cellReuseIdentifier = "cell"

    var snapshot: GDPRPMConsentSnaptshot?

    override var preferredFocusedView: UIView? { acceptButton }

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

    override func viewDidLoad() {
        super.viewDidLoad()
        setHeader()
        loadLabelView(forComponentId: "CategoriesHeader", label: categoriesExplainerLabel)
        categoriesExplainerLabel.setDefaultTextColorForDarkMode()
        loadTextView(forComponentId: "PublisherDescription", textView: descriptionTextView)
        descriptionTextView.flashScrollIndicators()
        loadButton(forComponentId: "AcceptAllButton", button: acceptButton)
        loadButton(forComponentId: "RejectAllButton", button: rejectButton)
        loadButton(forComponentId: "SaveAndExitButton", button: saveAndExitButton)
        loadButton(forComponentId: "NavCategoriesButton", button: managePreferenceButton)
        loadButton(forComponentId: "NavVendorsButton", button: ourPartners)
        loadButton(forComponentId: "NavPrivacyPolicyButton", button: privacyPolicyButton)
        loadImage(forComponentId: "LogoImage", imageView: logoImageView)
        categoryTableView.allowsSelection = false
        categoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        disableMenuButton()
    }
    
    override func setFocusGuides() {
        addFocusGuide(from: descriptionTextView, to: categoryTableView, direction: .bottomTop)
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
                            nibName: "SPManagePreferenceViewController"
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
                        controller.consentsSnapshot = strongSelf.snapshot!
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
        controller.consentsSnapshot = snapshot!
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
                    controller.consentsSnapshot = strongSelf.snapshot!
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
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SPGDPRNativePrivacyManagerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        loadLabelText(
            forComponentId: "CategoriesDescriptionText",
            labelText: categories[indexPath.row].description,
            label: selectedCategoryTextLabel
        )
        return true
    }

    func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
        if context.nextFocusedIndexPath == nil {
            loadLabelText(
                forComponentId: "CategoriesDescriptionText",
                labelText: "",
                label: selectedCategoryTextLabel
            )
        }
        return true
    }
}

        true
    }
}
