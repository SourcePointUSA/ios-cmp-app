//
//  SPManagePreferenceViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Vilas on 03/05/21.
//

import Foundation
import UIKit

class SPGDPRManagePreferenceViewController: SPNativeScreenViewController {
    struct Section {
        let header: SPNativeText?
        var contentConsent: [GDPRCategory]
        var contentLegIntCategory: [GDPRCategory]

        init? (
            header: SPNativeText?,
            contentConsent: [GDPRCategory]? = nil,
            contentLegIntCategory: [GDPRCategory]? = nil,
            contentFeature: [GDPRCategory]? = nil
        ) {
            self.header = header
            self.contentConsent = contentConsent ?? []
            self.contentLegIntCategory = contentLegIntCategory ?? []
            if contentFeature != nil {
                self.contentConsent.append(contentsOf: contentFeature ?? [])
                self.contentLegIntCategory.append(contentsOf: contentFeature ?? [])
            }
        }
    }

    var nativeLongButton: SPNativeLongButton?

    var consentsSnapshot = GDPRPMConsentSnaptshot()
    var displayingLegIntCategories: Bool { categorySlider.selectedSegmentIndex == 1 || emptyConsentSection }

    var categories: [GDPRCategory] = []
    var legIntCategories: [GDPRCategory] { categories.filter { $0.legIntVendors?.isNotEmpty() ?? false } }
    var userConsentCategories: [GDPRCategory] { categories.filter { $0.requiringConsentVendors?.isNotEmpty() ?? false } }
    var legIntSpecialPurposes: [GDPRCategory] { consentsSnapshot.specialPurposes.filter { $0.disclosureOnly == true } }
    var categoryDescription = [String: String]()

    var sections: [Section] {[
        Section(
            header: viewData.byId("PurposesHeader") as? SPNativeText,
            contentConsent: userConsentCategories,
            contentLegIntCategory: legIntCategories),
        Section(
            header: viewData.byId("SpecialPurposesHeader") as? SPNativeText,
            contentConsent: Array(consentsSnapshot.specialPurposes),
            contentLegIntCategory: legIntSpecialPurposes),
        Section(
            header: viewData.byId("FeaturesHeader") as? SPNativeText,
            contentFeature: Array(consentsSnapshot.features)),
        Section(
            header: viewData.byId("SpecialFeaturesHeader") as? SPNativeText,
            contentFeature: Array(consentsSnapshot.specialFeatures))
    ].compactMap { $0 }}

    var emptyConsentSection: Bool {
        return (
            sections[0].contentConsent.isEmpty &&
            sections[1].contentConsent.isEmpty
        )
    }

    var emptyLegIntSection: Bool {
        return (
            sections[0].contentLegIntCategory.isEmpty &&
            sections[1].contentLegIntCategory.isEmpty
        )
    }

    let cellReuseIdentifier = "cell"

    @IBOutlet var selectedCategoryTextLabel: UILabel!
    @IBOutlet var descriptionTextView: SPFocusableTextView!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var acceptButton: SPAppleTVButton!
    @IBOutlet var saveAndExit: SPAppleTVButton!
    @IBOutlet var categorySlider: UISegmentedControl!
    @IBOutlet var categoriesTableView: UITableView!
    @IBOutlet var header: SPPMHeader!
    @IBOutlet var actionsContainer: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setHeader()
        loadTextView(forComponentId: "CategoriesHeader", textView: descriptionTextView, bounces: false)
        descriptionTextView.flashScrollIndicators()
        dynamicFrameForDescription()
        loadButton(forComponentId: "AcceptAllButton", button: acceptButton)
        loadButton(forComponentId: "SaveButton", button: saveAndExit)
        loadSliderButton(forComponentId: "CategoriesSlider", slider: categorySlider)
        if emptyConsentSection {
            removeSliderButtonSegment(slider: categorySlider, removeSegmentNum: 0) }
        if emptyLegIntSection {
            removeSliderButtonSegment(slider: categorySlider, removeSegmentNum: 1) }
        loadImage(forComponentId: "LogoImage", imageView: logoImageView)
        loadLabelText(forComponentId: "CategoriesDescriptionText", labelText: "", label: selectedCategoryTextLabel)
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
        guard let pmPayload = consentsSnapshot.toPayload(language: .English, pmId: messageId).json() else {
            messageUIDelegate?.onError(UnableToConvertConsentSnapshotIntoJsonError(campaignType: .gdpr))
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
        addFocusGuide(from: categorySlider, to: descriptionTextView, direction: .bottomTop)
        addFocusGuide(from: descriptionTextView, to: categoriesTableView, direction: .bottomTop)
        addFocusGuide(from: header.backButton, to: categorySlider, direction: .right)
        addFocusGuide(from: categorySlider, to: header.backButton, direction: .left)
        addFocusGuide(from: actionsContainer, to: categoriesTableView, direction: .rightLeft)
        categoriesTableView.remembersLastFocusedIndexPath = true
    }

    func setHeader() {
        loadButton(forComponentId: "BackButton", button: header.backButton)
        header.spTitleText = viewData.byId("Header") as? SPNativeText
        header.onBackButtonTapped = { [weak self] in self?.dismiss(animated: true) }
    }

    func dynamicFrameForDescription() {
        let width = descriptionTextView.frame.size.width
        let height = descriptionTextView.frame.height
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = true
        descriptionTextView.sizeToFit()
        descriptionTextView.frame.size.width = width
        if descriptionTextView.frame.size.height > height {
            descriptionTextView.frame.size.height = height
        }
    }
}

// MARK: UITableViewDataSource
extension SPGDPRManagePreferenceViewController: UITableViewDataSource, UITableViewDelegate {
    func currentCategory(_ index: IndexPath) -> GDPRCategory {
        if index.section >= 2 {
            return sections[index.section].contentConsent[index.row]
        } else {
            return displayingLegIntCategories ?
            sections[index.section].contentLegIntCategory[index.row] :
            sections[index.section].contentConsent[index.row]
        }
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        50
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionComponent = sections[section].header else { return nil }

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        loadLabelText(forComponent: sectionComponent, label: label)
        label.isHidden = displayingLegIntCategories ?
            sections[section].contentLegIntCategory.isEmpty : sections[section].contentConsent.isEmpty
        return label
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        displayingLegIntCategories ? sections[section].contentLegIntCategory.count : sections[section].contentConsent.count
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
        cell.identifier = category._id
        cell.labelText = category.name
        switch section {
        case 0:
            if displayingLegIntCategories {
                cell.contentType = .legitimate
                cell.isOn = consentsSnapshot.toggledLICategoriesIds.contains(category._id)
            } else {
                cell.contentType = .consent
                cell.isOn = consentsSnapshot.toggledConsentCategoriesIds.contains(category._id)
            }

        case 3:
            cell.contentType = .specialFeatures
            cell.isOn = consentsSnapshot.toggledSpecialFeatures.contains(category._id)

        default:
            cell.contentType = nil
            cell.isOn = nil
        }
        cell.selectable = true
        cell.isCustom = category.type != .IAB || category.type != .IAB_PURPOSE
        cell.setup(from: viewData.children.first(where: { $0.id == "CategoryButton" }) as? SPNativeLongButton, selectedLanguage: language)
        cell.loadUI()
        categoryDescription[category._id] = category.friendlyDescription
        return cell
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let cell = tableView.cellForRow(at: indexPath) as? LongButtonViewCell
        return cell?.selectable ?? false
    }

    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        if let cell = tableView.cellForRow(at: indexPath) as? LongButtonViewCell {
            selectedCategoryTextLabel.text = categoryDescription[cell.identifier]
        }
        return true
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath) as? LongButtonViewCell
        return cell?.selectable ?? false ? indexPath : nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? LongButtonViewCell
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
        categoryDetailsVC.categoryType = cell?.contentType
        categoryDetailsVC.purposeToggleActive = indexPath.section == 0 || indexPath.section == 3
        present(categoryDetailsVC, animated: true)
    }
}
