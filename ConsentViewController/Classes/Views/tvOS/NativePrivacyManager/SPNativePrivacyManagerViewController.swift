//
//  SPNativePrivacyManagerViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Vilas on 01/04/21.
//

import UIKit
import Foundation

@objcMembers class SPNativePrivacyManagerViewController: SPNativeScreenViewController {
    weak var delegate: SPNativePMDelegate?

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var subDescriptionTextLabel: UILabel!
    @IBOutlet weak var selectedCategoryTextLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var ourPartners: UIButton!
    @IBOutlet weak var managePreferenceButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    @IBOutlet weak var categoryTableView: UITableView!

    @IBOutlet weak var header: SPPMHeader!

    var categories: [VendorListCategory] { pmData.categories }
    let cellReuseIdentifier = "cell"

    override var preferredFocusedView: UIView? { acceptButton }

    func setHeader () {
        header.spBackButton = viewData.byId("BackButton") as? SPNativeButton
        header.spTitleText = viewData.byId("HeaderText") as? SPNativeText
        header.onBackButtonTapped = {
            self.messageUIDelegate?.action(SPAction(type: .Dismiss), from: self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setHeader()
        loadLabelView(forComponentId: "CategoriesSubDescriptionText", label: subDescriptionTextLabel)
        loadTextView(forComponentId: "CategoriesDescriptionText", textView: descriptionTextView)
        loadButton(forComponentId: "AcceptAllButton", button: acceptButton)
        loadButton(forComponentId: "NavCategoriesButton", button: managePreferenceButton)
        loadButton(forComponentId: "NavVendorsButton", button: ourPartners)
        loadButton(forComponentId: "NavPrivacyPolicyButton", button: privacyPolicyButton)
        categoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    }

    @IBAction func onAcceptTap(_ sender: Any) {
        messageUIDelegate?.action(
            SPAction(type: .AcceptAll, id: nil, campaignType: campaignType),
            from: self
        )
    }

    @IBAction func onManagePreferenceTap(_ sender: Any) {
        delegate?.on2ndLayerNavigating(messageId: messageId) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.onError(error)
            case .success(let data):
                if let strongSelf = self {
                    let controller = SPManagePreferenceViewController(
                        messageId: self?.messageId,
                        campaignType: strongSelf.campaignType,
                        viewData: strongSelf.pmData.categoriesView,
                        pmData: strongSelf.pmData,
                        delegate: self,
                        nibName: "SPManagePreferenceViewController"
                    )
                    controller.categories = data.categories
                    controller.specialPurposes = data.specialPurposes
                    controller.features = data.features
                    controller.specialFeatures = data.specialFeatures
                    self?.present(controller, animated: true)
                }
            }
        }
    }

    @IBAction func onPartnersTap(_ sender: Any) {
        delegate?.on2ndLayerNavigating(messageId: messageId) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.onError(error)
            case .success(let data):
                if let strongSelf = self {
                    let controller = SPPartnersViewController(
                        messageId: self?.messageId,
                        campaignType: strongSelf.campaignType,
                        viewData: strongSelf.pmData.vendorsView,
                        pmData: strongSelf.pmData,
                        delegate: self,
                        nibName: "SPPartnersViewController"
                    )
                    controller.vendors = data.vendors
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

extension SPNativePrivacyManagerViewController: SPMessageUIDelegate {
    func loaded(_ controller: SPMessageViewController) {
        messageUIDelegate?.loaded(self)
    }

    func action(_ action: SPAction, from controller: SPMessageViewController) {

    }

    func onError(_ error: SPError) {
        messageUIDelegate?.onError(error)
    }

    func finished(_ vcFinished: SPMessageViewController) {}
}

// MARK: UITableViewDataSource
extension SPNativePrivacyManagerViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SPNativePrivacyManagerViewController: UITableViewDelegate {
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

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
