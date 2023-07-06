//
//  SPCCPAManagePreferenceViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Vilas on 03/05/21.
//

import Foundation
import UIKit

class SPCCPAManagePreferenceViewController: SPNativeScreenViewController {
    struct Section {
        let header: SPNativeText?
        let content: [CCPACategory]

        init? (header: SPNativeText?, content: [CCPACategory]?) {
            if content == nil || content?.isEmpty == true { return nil }
            self.header = header
            self.content = content! // swiftlint:disable:this force_unwrapping
        }
    }

    var nativeLongButton: SPNativeLongButton?

    var consentsSnapshot = CCPAPMConsentSnaptshot()

    var categories: [CCPACategory] = []
    var userConsentCategories: [CCPACategory] { categories.filter { $0.requiringConsentVendors.isNotEmpty() } }
    var legIntCategories: [CCPACategory] { categories.filter { $0.legIntVendors.isNotEmpty() } }

    var sections: [Section] {[
        Section(header: viewData.byId("PurposesHeader") as? SPNativeText, content: categories)
    ].compactMap { $0 }}

    let cellReuseIdentifier = "cell"

    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var acceptButton: SPAppleTVButton!
    @IBOutlet var saveAndExit: SPAppleTVButton!
    @IBOutlet var categoriesTableView: UITableView!
    @IBOutlet var header: SPPMHeader!
    @IBOutlet var actionsContainer: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setHeader()
        loadTextView(forComponentId: "CategoriesHeader", textView: descriptionTextView)
        loadButton(forComponentId: "AcceptAllButton", button: acceptButton)
        loadButton(forComponentId: "SaveButton", button: saveAndExit)
        loadImage(forComponentId: "LogoImage", imageView: logoImageView)
        nativeLongButton = viewData.byId("CategoryButtons") as? SPNativeLongButton
        categoriesTableView.register(
            UINib(nibName: "LongButtonViewCell", bundle: Bundle.framework),
            forCellReuseIdentifier: cellReuseIdentifier
        )
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        consentsSnapshot.onConsentsChange = { [weak self] in
            self?.categoriesTableView.reloadData()
        }
    }

    @IBAction func onAcceptTap(_ sender: Any) {
        messageUIDelegate?.action(SPAction(type: .AcceptAll, campaignType: campaignType), from: self)
    }

    @IBAction func onSaveAndExitTap(_ sender: Any) {
        guard let pmPayload = consentsSnapshot.toPayload(language: .English, pmId: messageId).json() else {
            messageUIDelegate?.onError(UnableToConvertConsentSnapshotIntoJsonError(campaignType: .ccpa))
            return
        }
        messageUIDelegate?.action(SPAction(
            type: .SaveAndExit,
            campaignType: campaignType,
            pmPayload: pmPayload
        ), from: self)
    }

    override func setFocusGuides() {
        addFocusGuide(from: header.backButton, to: actionsContainer, direction: .bottomTop)
        addFocusGuide(from: actionsContainer, to: categoriesTableView, direction: .rightLeft)
        categoriesTableView.remembersLastFocusedIndexPath = true
    }

    func setHeader() {
        loadButton(forComponentId: "BackButton", button: header.backButton)
        header.spTitleText = viewData.byId("Header") as? SPNativeText
        header.onBackButtonTapped = { [weak self] in self?.dismiss(animated: true) }
    }
}

// MARK: UITableViewDataSource
extension SPCCPAManagePreferenceViewController: UITableViewDataSource, UITableViewDelegate {
    func currentCategory(_ index: IndexPath) -> CCPACategory {
        sections[index.section].content[index.row]
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        50
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        label.text = sections[section].header?.settings.text
        label.font = UIFont(from: sections[section].header?.settings.style?.font)
        label.textColor = UIColor(hexString: sections[section].header?.settings.style?.font.color)
        return label
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].content.count
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? LongButtonViewCell else {
            return UITableViewCell()
        }

        let category = currentCategory(indexPath)
        cell.labelText = category.name
        switch consentsSnapshot.consentStatus {
            case .ConsentedAll, .RejectedNone: cell.isOn = true
            case .RejectedAll: cell.isOn = false
            default: cell.isOn = !consentsSnapshot.toggledCategoriesIds.contains(category._id)
        }

        cell.selectable = true
        cell.isCustom = false
        cell.setup(from: nativeLongButton)
        cell.loadUI()
        return cell
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        indexPath.section != 1
    }

    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categoryDetailsVC = SPCCPACategoryDetailsViewController(
            messageId: messageId,
            campaignType: campaignType,
            viewData: pmData.categoryDetailsView,
            pmData: pmData,
            delegate: nil,
            nibName: "SPCCPACategoryDetailsViewController"
        )
        categoryDetailsVC.category = currentCategory(indexPath)
        categoryDetailsVC.categoryManagerDelegate = consentsSnapshot
        present(categoryDetailsVC, animated: true)
    }
}
