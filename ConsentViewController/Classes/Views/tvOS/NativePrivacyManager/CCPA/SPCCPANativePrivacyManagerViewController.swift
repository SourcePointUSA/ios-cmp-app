//
//  SPCCPANativePrivacyManagerViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Vilas on 01/04/21.
//

import Foundation
import UIKit

@objcMembers class SPCCPANativePrivacyManagerViewController: SPNativeScreenViewController, SPNativePrivacyManagerHome {
    weak var delegate: SPNativePMDelegate?

    var doNotSellButton: SPNativeLongButton?

    var ccpaConsents: SPCCPAConsent?
    private var snapshot: CCPAPMConsentSnaptshot!

    var secondLayerData: CCPAPrivacyManagerViewResponse?

    let cellReuseIdentifier = "cell"

    override var preferredFocusedView: UIView? { acceptButton }

    @IBOutlet var header: SPPMHeader!
    @IBOutlet var descriptionTextView: SPFocusableTextView!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var ourPartners: SPAppleTVButton!
    @IBOutlet var managePreferenceButton: SPAppleTVButton!
    @IBOutlet var acceptButton: SPAppleTVButton!
    @IBOutlet var rejectButton: SPAppleTVButton!
    @IBOutlet var saveAndExitButton: SPAppleTVButton!
    @IBOutlet var privacyPolicyButton: SPAppleTVButton!
    @IBOutlet var customViewButton: SPAppleTVButton!
    @IBOutlet var doNotSellTableView: UITableView!
    @IBOutlet var actionsContainer: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initConsentsSnapshot()
        setHeader()
        loadTextView(forComponentId: "PublisherDescription", textView: descriptionTextView, bounces: false)
        descriptionTextView.flashScrollIndicators()
        loadButton(forComponentId: "AcceptAllButton", button: acceptButton)
        loadButton(forComponentId: "RejectAllButton", button: rejectButton)
        loadButton(forComponentId: "SaveAndExitButton", button: saveAndExitButton)
        loadButton(forComponentId: "NavCategoriesButton", button: managePreferenceButton)
        loadButton(forComponentId: "NavVendorsButton", button: ourPartners)
        loadButton(forComponentId: "NavPrivacyPolicyButton", button: privacyPolicyButton)
        loadButton(forComponentId: "NavCustomButton", button: customViewButton)
        loadImage(forComponentId: "LogoImage", imageView: logoImageView)
        setDoNotSellButton()
        setFocusGuidesForButtons()
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
        var actionType: SPActionType
        switch snapshot.consentStatus {
            case .RejectedSome: actionType = .SaveAndExit
            case .RejectedAll: actionType = .RejectAll
            case .ConsentedAll, .RejectedNone: actionType = .AcceptAll
            default: actionType = .SaveAndExit
        }

        action(
            SPAction(
                type: actionType,
                campaignType: campaignType,
                pmPayload: snapshot.toPayload(language: .English, pmId: messageId).json() ?? SPJson()
            ),
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
                        strongSelf.secondLayerData = data
                        let controller = SPCCPAManagePreferenceViewController(
                            messageId: strongSelf.messageId,
                            campaignType: strongSelf.campaignType,
                            viewData: strongSelf.pmData.categoriesView,
                            pmData: strongSelf.pmData,
                            delegate: self,
                            nibName: "SPCCPAManagePreferenceViewController"
                        )
                        self?.snapshot = CCPAPMConsentSnaptshot(
                            vendors: Set<CCPAVendor>(data.vendors),
                            categories: Set<CCPACategory>(data.categories),
                            rejectedVendors: data.rejectedVendors,
                            rejectedCategories: data.rejectedCategories,
                            consentStatus: data.consentStatus
                        )
                        controller.categories = data.categories
                        controller.consentsSnapshot = strongSelf.snapshot! // swiftlint:disable:this force_unwrapping
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
        controller.categories = secondLayerData.categories
        controller.consentsSnapshot = snapshot! // swiftlint:disable:this force_unwrapping
        present(controller, animated: true)
    }

    @IBAction func onPartnersTap(_ sender: Any) {
        delegate?.onCCPA2ndLayerNavigate(messageId: messageId) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.onError(error)

            case .success(let data):
                if let strongSelf = self {
                    self?.snapshot = CCPAPMConsentSnaptshot(
                        vendors: Set<CCPAVendor>(data.vendors),
                        categories: Set<CCPACategory>(data.categories),
                        rejectedVendors: data.rejectedVendors,
                        rejectedCategories: data.rejectedCategories, consentStatus: data.consentStatus
                    )
                    let controller = SPCCPAPartnersViewController(
                        messageId: strongSelf.messageId,
                        campaignType: strongSelf.campaignType,
                        viewData: strongSelf.pmData.vendorsView,
                        pmData: strongSelf.pmData,
                        delegate: self,
                        nibName: "SPPartnersViewController"
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

    @IBAction func onCustomViewTap(_ sender: Any) {
        guard let customView = pmData.customView else {
            onError(UnableToFindView(withId: "CustomView"))
            return
        }
        present(SPCustomViewController(
            messageId: messageId,
            campaignType: campaignType,
            viewData: customView,
            pmData: pmData,
            delegate: self,
            nibName: "SPCustomViewController"
        ), animated: true)
    }

    func setHeader () {
        loadButton(forComponentId: "BackButton", button: header.backButton)
        header.spTitleText = viewData.byId("Header") as? SPNativeText
        header.onBackButtonTapped = { [weak self] in
            if let this = self {
                self?.messageUIDelegate?.action(SPAction(type: .Dismiss), from: this)
            }
        }
    }

    func setDoNotSellButton() {
        doNotSellButton = viewData.byId("DoNotSellButton") as? SPNativeLongButton
        doNotSellTableView.register(
            UINib(nibName: "LongButtonViewCell", bundle: Bundle.framework),
            forCellReuseIdentifier: cellReuseIdentifier
        )
        doNotSellTableView.allowsSelection = true
        doNotSellTableView.delegate = self
        doNotSellTableView.dataSource = self
    }

    func initConsentsSnapshot() {
        snapshot = CCPAPMConsentSnaptshot(
            vendors: [],
            categories: [],
            rejectedVendors: ccpaConsents?.rejectedVendors,
            rejectedCategories: ccpaConsents?.rejectedCategories,
            consentStatus: ccpaConsents?.status)
        snapshot.onConsentsChange = { [weak self] in
            self?.doNotSellTableView.reloadData()
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

    func setFocusGuidesForButtons() {
        let visibleButtons: [UIView] = actionsContainer.arrangedSubviews.filter({ !$0.isHidden })
        if visibleButtons.count <= 1 {
            return
        }
        for i in 0...visibleButtons.count - 2 {
            addFocusGuide(from: visibleButtons[i], to: visibleButtons[i + 1], direction: .bottomTop)
        }
    }

    override func setFocusGuides() {
        addFocusGuide(from: header.backButton, to: actionsContainer, direction: .bottomTop)
        addFocusGuide(from: actionsContainer, to: doNotSellTableView, direction: .rightLeft)
    }

    override func loadMessage() {
        loaded(self)
    }
}

extension SPCCPANativePrivacyManagerViewController: SPMessageUIDelegate {
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
            let component = (viewData.byId("DoNotSellButton") as? SPNativeLongButton)
            fallBackCell.textLabel?.text = component?.settings.text
            fallBackCell.textLabel?.font = UIFont(from: component?.settings.style.font)
            addFocusGuide(from: acceptButton, to: fallBackCell, direction: .rightLeft)
            return fallBackCell
        }

        cell.labelText = doNotSellButton?.settings.text
        cell.selectable = false
        cell.isCustom = false
        cell.isOn = snapshot.consentStatus == .RejectedAll
        cell.setup(from: doNotSellButton)
        cell.loadUI()
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SPCCPANativePrivacyManagerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        descriptionTextView.contentFitsContainer
    }

    func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        snapshot.onDoNotSellToggle()
    }
}
