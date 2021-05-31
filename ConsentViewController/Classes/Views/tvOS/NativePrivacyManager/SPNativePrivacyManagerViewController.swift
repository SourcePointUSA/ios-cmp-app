//
//  SPNativePrivacyManagerViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Vilas on 01/04/21.
//

import UIKit
import Foundation

@objcMembers class SPNativePrivacyManagerViewController: SPNativeScreenViewController {
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

    let categoryList = [
        "Store and/or access information on a device",
        "Select personalized content",
        "Personalized ads, ad meansurement and audience insights",
        "Project developement",
        "Information storage and access",
        "Ad selection, delivery, reporting",
        "Measure ad performance",
        "Develop and improve products",
        "Use precise geolocation data"
    ]
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
        descriptionTextView.textContainer.lineFragmentPadding = 0
        descriptionTextView.textContainerInset = .zero
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
        present(SPManagePreferenceViewController(
            messageId: messageId,
            campaignType: campaignType,
            viewData: pmData.categoriesView,
            pmData: pmData,
            delegate: self,
            nibName: "SPManagePreferenceViewController"
        ), animated: true)
    }

    @IBAction func onPartnersTap(_ sender: Any) {
        present(SPPartnersViewController(
            messageId: messageId,
            campaignType: campaignType,
            viewData: pmData.vendorsView,
            pmData: pmData,
            delegate: self,
            nibName: "SPPartnersViewController"
        ), animated: true)
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
    func loaded(_ controller: SPMessageViewController) {}

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
        categoryList.count
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = categoryTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)! as UITableViewCell
        cell.textLabel?.text = categoryList[indexPath.row]
        return cell
    }

    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        loadLabelText(
            forComponentId: "CategoriesDescriptionText",
            labelText: categoryList[indexPath.row],
            label: selectedCategoryTextLabel
        )
        return true
    }
}

// MARK: - UITableViewDelegate
extension SPNativePrivacyManagerViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
