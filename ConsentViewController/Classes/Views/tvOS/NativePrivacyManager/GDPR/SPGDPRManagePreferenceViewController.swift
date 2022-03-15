//
//  SPManagePreferenceViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Vilas on 03/05/21.
//

import UIKit
import Foundation

class SPGDPRManagePreferenceViewController: SPNativeScreenViewController {
    struct Section {
        let header: SPNativeText?
        let content: [GDPRCategory]

        init? (header: SPNativeText?, content: [GDPRCategory]?) {
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
    @IBOutlet weak var categorySlider: UISegmentedControl!
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var header: SPPMHeader!
    @IBOutlet weak var actionsContainer: UIStackView!
    var nativeLongButton: SPNativeLongButton?

    var consentsSnapshot: GDPRPMConsentSnaptshot = GDPRPMConsentSnaptshot()
    var displayingLegIntCategories: Bool { categorySlider.selectedSegmentIndex == 1 }

    var categories: [GDPRCategory] = []
    var userConsentCategories: [GDPRCategory] { categories.filter { $0.requiringConsentVendors?.isNotEmpty() ?? false } }
    var legIntCategories: [GDPRCategory] { categories.filter { $0.legIntVendors?.isNotEmpty() ?? false } }

    var sections: [Section] {[
        Section(header: viewData.byId("PurposesHeader") as? SPNativeText, content: userConsentCategories),
        Section(header: viewData.byId("SpecialPurposesHeader") as? SPNativeText, content: Array(consentsSnapshot.specialPurposes)),
        Section(header: viewData.byId("FeaturesHeader") as? SPNativeText, content: Array(consentsSnapshot.features)),
        Section(header: viewData.byId("SpecialFeaturesHeader") as? SPNativeText, content: Array(consentsSnapshot.specialFeatures))
    ].compactMap { $0 }}

    let cellReuseIdentifier = "cell"

    override func setFocusGuides() {
        addFocusGuide(from: header.backButton, to: actionsContainer, direction: .bottomTop)
        addFocusGuide(from: categorySlider, to: categoriesTableView, direction: .bottomTop)
        addFocusGuide(from: categorySlider, to: header.backButton, direction: .left)
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
        loadSliderButton(forComponentId: "CategoriesSlider", slider: categorySlider)
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

    @IBAction func onCategorySliderTap(_ sender: Any) {
        categoriesTableView.reloadData()
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
extension SPGDPRManagePreferenceViewController: UITableViewDataSource, UITableViewDelegate {
    func currentCategory(_ index: IndexPath) -> GDPRCategory {
        displayingLegIntCategories ?
            legIntCategories[index.row] :
            sections[index.section].content[index.row]
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        50
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        displayingLegIntCategories ? 1 : sections.count
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
        displayingLegIntCategories ? legIntCategories.count : sections[section].content.count
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? LongButtonViewCell else {
            return UITableViewCell()
        }

        let section = indexPath.section
        let category = currentCategory(indexPath)
        cell.labelText = category.name
        cell.isOn = section == 0 || section == 3 ?
            consentsSnapshot.toggledCategoriesIds.contains(category._id) :
            nil
        cell.selectable = section != 1
        cell.isCustom = category.type != .IAB || category.type != .IAB_PURPOSE
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
        indexPath.section == 1 ? nil : indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categoryDetailsVC = SPGDPRCategoryDetailsViewController(
            messageId: messageId,
            campaignType: campaignType,
            viewData: pmData.categoryDetailsView,
            pmData: pmData,
            delegate: nil,
            nibName: "SPGDPRCategoryDetailsViewController"
        )
        categoryDetailsVC.category = currentCategory(indexPath)
        categoryDetailsVC.categoryManagerDelegate = consentsSnapshot
        present(categoryDetailsVC, animated: true)
    }
}
