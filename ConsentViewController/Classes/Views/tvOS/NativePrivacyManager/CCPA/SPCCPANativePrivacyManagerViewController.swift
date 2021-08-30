//
//  SPCCPANativePrivacyManagerViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Vilas on 01/04/21.
//

import UIKit
import Foundation

@objcMembers class SPCCPANativePrivacyManagerViewController: SPNativeScreenViewController, SPNativePrivacyManagerHome {
    weak var delegate: SPNativePMDelegate?

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var selectedCategoryTextLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var ourPartners: UIButton!
    @IBOutlet weak var managePreferenceButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var saveAndExitButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    @IBOutlet weak var doNotSellTableView: UITableView!
    @IBOutlet weak var actionsContainer: UIStackView!

    var doNotSellButton: SPNativeLongButton?

    @IBOutlet weak var header: SPPMHeader!

    var secondLayerData: CCPAPrivacyManagerViewResponse?

    let cellReuseIdentifier = "cell"

    var snapshot: CCPAPMConsentSnaptshot?

    override var preferredFocusedView: UIView? { acceptButton }

    override func setFocusGuides() {
        addFocusGuide(from: header.backButton, to: actionsContainer, direction: .bottomTop)
        addFocusGuide(from: actionsContainer, to: doNotSellTableView, direction: .rightLeft)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setHeader()
        loadTextView(forComponentId: "PublisherDescription", textView: descriptionTextView)
        loadButton(forComponentId: "AcceptAllButton", button: acceptButton)
        loadButton(forComponentId: "RejectAllButton", button: rejectButton)
        loadButton(forComponentId: "SaveAndExitButton", button: saveAndExitButton)
        loadButton(forComponentId: "NavCategoriesButton", button: managePreferenceButton)
        loadButton(forComponentId: "NavVendorsButton", button: ourPartners)
        loadButton(forComponentId: "NavPrivacyPolicyButton", button: privacyPolicyButton)
        loadImage(forComponentId: "LogoImage", imageView: logoImageView)
        doNotSellButton = viewData.byId("DoNotSellButton") as? SPNativeLongButton
        doNotSellTableView.register(
            UINib(nibName: "LongButtonViewCell", bundle: Bundle.framework),
            forCellReuseIdentifier: cellReuseIdentifier
        )
        doNotSellTableView.allowsSelection = true
        doNotSellTableView.delegate = self
        doNotSellTableView.dataSource = self
        snapshot?.onConsentsChange = { [weak self] in
            self?.doNotSellTableView.reloadData()
        }
    }

    @IBAction func onAcceptTap(_ sender: Any) {
        action(
            SPAction(type: .AcceptAll, id: nil, campaignType: campaignType),
            from: self
        )
    }

    @IBAction func onRejectTap(_ sender: Any) {
        action(
            SPAction(type: .RejectAll, id: nil, campaignType: campaignType),
            from: self
        )
    }

    @IBAction func onSaveAndExitTap(_ sender: Any) {
        let actionType: SPActionType = (snapshot?.consentStatus == .RejectedAll) ? .RejectAll : .AcceptAll
        action(
            SPAction(type: actionType, id: nil, campaignType: campaignType),
            from: self
        )
    }

    @IBAction func onManagePreferenceTap(_ sender: Any) {
        guard let secondLayerData = secondLayerData else {
            delegate?.onCCPA2ndLayerNavigate(messageId: messageId) { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.onError(error)
                case .success(let data):
                    if let strongSelf = self {
                        let controller = SPCCPAManagePreferenceViewController(
                            messageId: strongSelf.messageId,
                            campaignType: strongSelf.campaignType,
                            viewData: strongSelf.pmData.categoriesView,
                            pmData: strongSelf.pmData,
                            delegate: self,
                            nibName: "SPCCPAManagePreferenceViewController"
                        )
                        if self?.snapshot == nil {
                            self?.snapshot = CCPAPMConsentSnaptshot(
                                vendors: Set<CCPAVendor>(data.vendors),
                                categories: Set<CCPACategory>(data.categories),
                                rejectedVendors: data.rejectedVendors,
                                rejectedCategories: data.rejectedCategories,
                                consentStatus: data.consentStatus
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
        let controller = SPCCPAManagePreferenceViewController(
            messageId: messageId,
            campaignType: campaignType,
            viewData: pmData.categoriesView,
            pmData: pmData,
            delegate: self,
            nibName: "SPManagePreferenceViewController"
        )
        if snapshot == nil {
            snapshot = CCPAPMConsentSnaptshot(
                vendors: Set<CCPAVendor>(secondLayerData.vendors),
                categories: Set<CCPACategory>(secondLayerData.categories),
                rejectedVendors: secondLayerData.rejectedVendors,
                rejectedCategories: secondLayerData.rejectedCategories,
                consentStatus: secondLayerData.consentStatus
            )
        }
        controller.categories = secondLayerData.categories
        controller.consentsSnapshot = snapshot!
        present(controller, animated: true)
    }

    @IBAction func onPartnersTap(_ sender: Any) {
        delegate?.onCCPA2ndLayerNavigate(messageId: messageId) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.onError(error)
            case .success(let data):
                if let strongSelf = self {
                    if self?.snapshot == nil {
                        self?.snapshot = CCPAPMConsentSnaptshot(
                            vendors: Set<CCPAVendor>(data.vendors),
                            categories: Set<CCPACategory>(data.categories),
                            rejectedVendors: data.rejectedVendors,
                            rejectedCategories: data.rejectedCategories, consentStatus: data.consentStatus
                        )
                    }
                    let controller = SPCCPAPartnersViewController(
                        messageId: strongSelf.messageId,
                        campaignType: strongSelf.campaignType,
                        viewData: strongSelf.pmData.vendorsView,
                        pmData: strongSelf.pmData,
                        delegate: self,
                        nibName: "SPPartnersViewController"
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

extension SPCCPANativePrivacyManagerViewController: SPMessageUIDelegate {
    func loaded(_ controller: SPMessageViewController) {
        messageUIDelegate?.loaded(self)
    }

    func action(_ action: SPAction, from controller: SPMessageViewController) {
        dismiss(animated: false) {
            self.messageUIDelegate?.action(action, from: controller)
        }
    }

    func onError(_ error: SPError) {
        messageUIDelegate?.onError(error)
    }

    func finished(_ vcFinished: SPMessageViewController) {}
}

// MARK: UITableViewDataSource
extension SPCCPANativePrivacyManagerViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? LongButtonViewCell else {
            let fallBackCell = UITableViewCell()
            fallBackCell.textLabel?.text = (viewData.byId("DoNotSellButton") as? SPNativeLongButton)?.settings.text ?? "Do not sell"
            return fallBackCell
        }

        cell.labelText = doNotSellButton?.settings.text ?? "Do not sell"
        cell.selectable = false
        cell.isCustom = false
        cell.isOn = snapshot?.consentStatus == .RejectedAll
        cell.setup(from: doNotSellButton)
        cell.loadUI()
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SPCCPANativePrivacyManagerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        snapshot?.onDoNotSellToggle()
    }
}
