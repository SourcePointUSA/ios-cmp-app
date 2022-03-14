//
//  SPCCPAManagePreferenceViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Vilas on 03/05/21.
//

import UIKit
import Foundation

class SPCCPAManagePreferenceViewController: SPNativeScreenViewController {
    struct Section {
        let header: SPNativeText?
        let content: [CCPACategory]

        init? (header: SPNativeText?, content: [CCPACategory]?) {
            if content == nil || content!.isEmpty { return nil }
            self.header = header
            self.content = content!
        }
    }

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var selectedCategoryTextLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var acceptButton: SPAppleTVButton!
    @IBOutlet weak var saveAndExit: SPAppleTVButton!
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var header: SPPMHeader!
    @IBOutlet weak var actionsContainer: UIStackView!
    var nativeLongButton: SPNativeLongButton?

    var consentsSnapshot: CCPAPMConsentSnaptshot = CCPAPMConsentSnaptshot()

    var categories: [CCPACategory] = []
    var userConsentCategories: [CCPACategory] { categories.filter { $0.requiringConsentVendors.isNotEmpty() } }
    var legIntCategories: [CCPACategory] { categories.filter { $0.legIntVendors.isNotEmpty() } }

    var sections: [Section] {[
        Section(header: viewData.byId("PurposesHeader") as? SPNativeText, content: categories)
    ].compactMap { $0 }}

    let cellReuseIdentifier = "cell"

    override func setFocusGuides() {
        addFocusGuide(from: header.backButton, to: actionsContainer, direction: .bottomTop)
        addFocusGuide(from: actionsContainer, to: categoriesTableView, direction: .rightLeft)
    }

    func setHeader() {
        header.spBackButton = viewData.byId("BackButton") as? SPNativeButton
        header.spTitleText = viewData.byId("Header") as? SPNativeText
        header.onBackButtonTapped = { [weak self] in self?.dismiss(animated: true) }
    }

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
        messageUIDelegate?.action(SPAction(
            type: .SaveAndExit,
            campaignType: campaignType,
            pmPayload: consentsSnapshot.toPayload(language: .English, pmId: messageId).json()!
        ), from: self)
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
        let label = UILabel(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        label.text = sections[section].header?.settings.text
        label.font = UIFont(from: sections[section].header?.settings.style?.font)
        label.textColor = UIColor(hexString: sections[section].header?.settings.style?.font?.color)
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
        cell.isOn = !consentsSnapshot.toggledCategoriesIds.contains(category._id)
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
        let category = currentCategory(indexPath)
        loadLabelText(
            forComponentId: "CategoriesHeader",
            labelText: category.description,
            label: selectedCategoryTextLabel
        )
        return true
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
