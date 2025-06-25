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
        let definition: SPNativeText?
        var content: [GDPRCategory]

        init? (
            header: SPNativeText?,
            definition: SPNativeText?,
            content: [GDPRCategory]? = nil
        ) {
            self.header = header
            self.definition = definition
            self.content = content ?? []
        }
    }

    var nativeLongButton: SPNativeLongButton?

    var consentsSnapshot = GDPRPMConsentSnaptshot()
    var displayingLegIntCategories: Bool { categorySlider.selectedSegmentIndex == 1 || emptyConsentSection }

    var categories: [GDPRCategory] = []
    var legIntCategories: [GDPRCategory] { categories.filter { $0.legIntVendors?.isNotEmpty() ?? false } }
    var userConsentCategories: [GDPRCategory] { categories.filter { $0.requiringConsentVendors?.isNotEmpty() ?? false } }
    var categoryDescription = [String: String]()

    // Dynamic sections based on the current mode
    var dynamicSections: [Section] {
        if displayingLegIntCategories {
            return legIntSections
        } else {
            return consentSections
        }
    }
    
    // Sections for Consent Mode
    var consentSections: [Section] {
        [
            Section(
                header: viewData.byId("PurposesHeaderConsent", defaultId: "PurposesHeader") as? SPNativeText,
                definition: viewData.byId("PurposesDefinitionConsent", defaultId: "PurposesDefinition") as? SPNativeText,
                content: userConsentCategories
            ),
            Section(
                header: viewData.byId("SpecialPurposesHeaderConsent", defaultId: "SpecialPurposesHeader") as? SPNativeText,
                definition: viewData.byId("SpecialPurposesDefinitionConsent", defaultId: "SpecialPurposesDefinition") as? SPNativeText,
                content: Array(consentsSnapshot.specialPurposes)
            ),
            Section(
                header: viewData.byId("FeaturesHeaderConsent", defaultId: "FeaturesHeader") as? SPNativeText,
                definition: viewData.byId("FeaturesDefinitionConsent", defaultId: "FeaturesDefinition") as? SPNativeText,
                content: Array(consentsSnapshot.features)
            ),
            Section(
                header: viewData.byId("SpecialFeaturesHeaderConsent", defaultId: "SpecialFeaturesHeader") as? SPNativeText,
                definition: viewData.byId("SpecialFeaturesDefinitionConsent", defaultId: "SpecialFeaturesDefinition") as? SPNativeText,
                content: Array(consentsSnapshot.specialFeatures)
            )
        ].compactMap { $0 }
    }
    
    // Sections for Legitimate Interest Mode
    var legIntSections: [Section] {
        [
            Section(
                header: (viewData.byId("PurposesHeaderLegInt") ?? viewData.byId("PurposesHeaderConsent", defaultId: "PurposesHeader")) as? SPNativeText,
                definition: (viewData.byId("PurposesDefinitionLegInt") ?? viewData.byId("PurposesDefinitionConsent", defaultId: "PurposesDefinition")) as? SPNativeText,
                content: legIntCategories
            ),
            Section(
                header: (viewData.byId("SpecialPurposesHeaderLegInt") ?? viewData.byId("SpecialPurposesHeaderConsent", defaultId: "SpecialPurposesHeader")) as? SPNativeText,
                definition: (viewData.byId("SpecialPurposesDefinitionLegInt") ?? viewData.byId("SpecialPurposesDefinitionConsent", defaultId: "SpecialPurposesDefinition")) as? SPNativeText,
                content: Array(consentsSnapshot.specialPurposes)
            ),
            // Features and special features remain the same for both modes
            Section(
                header: viewData.byId("FeaturesHeaderConsent", defaultId: "FeaturesHeader") as? SPNativeText,
                definition: viewData.byId("FeaturesDefinitionConsent", defaultId: "FeaturesDefinition") as? SPNativeText,
                content: Array(consentsSnapshot.features)
            ),
            Section(
                header: viewData.byId("SpecialFeaturesHeaderConsent", defaultId: "SpecialFeaturesHeader") as? SPNativeText,
                definition: viewData.byId("SpecialFeaturesDefinitionConsent", defaultId: "SpecialFeaturesDefinition") as? SPNativeText,
                content: Array(consentsSnapshot.specialFeatures)
            )
        ].compactMap { $0 }
    }

    // Legacy sections property for compatibility
    var sections: [Section] {
        dynamicSections
    }

    var emptyConsentSection: Bool {
        return consentSections.isEmpty || (
            consentSections[0].content.isEmpty &&
            (consentSections.count < 2 || consentSections[1].content.isEmpty)
        )
    }

    var emptyLegIntSection: Bool {
        return legIntSections.isEmpty || (
            legIntSections[0].content.isEmpty &&
            (legIntSections.count < 2 || legIntSections[1].content.isEmpty)
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
    @IBOutlet var spacer: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setHeader()
        updateDescriptionForCurrentMode()
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
        loadLabelText(forComponentId: "CategoriesDescriptionText", labelText: "", longText: true, label: selectedCategoryTextLabel)
        nativeLongButton = viewData.byId("CategoryButton") as? SPNativeLongButton
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
        // Animation when changing
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.categoriesTableView.alpha = 0.5
        } completion: { [weak self] _ in
            self?.categoriesTableView.reloadData()
            UIView.animate(withDuration: 0.3) {
                self?.categoriesTableView.alpha = 1.0
            }
        }
        
        // Update header text based on mode
        updateHeaderForCurrentMode()
        
        // Update description text
        updateDescriptionForCurrentMode()
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
    
    // Helper method for updating the header
    func updateHeaderForCurrentMode() {
        // HeaderConsent and HeaderLegInt are not present in our test property
        if displayingLegIntCategories {
            // Legitimate Interest specific UI updates
            if let legIntHeader = viewData.byId("HeaderLegInt") as? SPNativeText {
                header.spTitleText = legIntHeader
            }
        } else {
            // Consent-specific UI updates
            if let consentHeader = viewData.byId("HeaderConsent") as? SPNativeText {
                header.spTitleText = consentHeader
            }
        }
    }
    
    // Helper method for updating the description
    func updateDescriptionForCurrentMode() {
        let textComponentId = displayingLegIntCategories ?
            viewData.getContainsIdOrDefault("CategoriesHeaderLegInt", defaultId: "CategoriesHeader")! :
            viewData.getContainsIdOrDefault("CategoriesHeaderConsent", defaultId: "CategoriesHeader")!
        loadTextView(forComponentId: textComponentId, textView: descriptionTextView, bounces: false)
        dynamicFrameForDescription()
    }
}

// MARK: UITableViewDataSource
extension SPGDPRManagePreferenceViewController: UITableViewDataSource, UITableViewDelegate {
    func currentCategory(_ index: IndexPath) -> GDPRCategory? {
        let categories = dynamicSections[index.section].content
        guard index.row < categories.count else { return nil }
        return categories[index.row]
    }

    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if dynamicSections[section].content.isEmpty { return 1 } else { return 50 }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionComponent = dynamicSections[section].header else { return nil }
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        loadLabelText(
            forComponent: sectionComponent,
            addTextForComponent: dynamicSections[section].definition,
            label: label
        )
        label.isHidden = dynamicSections[section].content.isEmpty
        return label
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if dynamicSections[section].content.isEmpty { return 1 } else { return UITableView.automaticDimension }
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dynamicSections[section].content.count
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if dynamicSections[indexPath.section].content.isEmpty { return 1 } else { return UITableView.automaticDimension }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? LongButtonViewCell,
              let category = currentCategory(indexPath) else {
            return UITableViewCell()
        }

        let section = indexPath.section
        cell.identifier = category._id
        cell.labelText = category.name
        
        // Determine the content type based on the section and the content
        if section == 0 { // Purposes
            if displayingLegIntCategories {
                cell.contentType = .legitimate
                cell.isOn = consentsSnapshot.toggledLICategoriesIds.contains(category._id)
            } else {
                cell.contentType = .consent
                cell.isOn = consentsSnapshot.toggledConsentCategoriesIds.contains(category._id)
            }
        } else if section == 3 { // Special Features (based on the original logic)
            cell.contentType = .specialFeatures
            cell.isOn = consentsSnapshot.toggledSpecialFeatures.contains(category._id)
        } else {
            // Regular Features and others
            cell.contentType = nil
            cell.isOn = nil
        }
        
        cell.selectable = true
        cell.isCustom = category.type != .IAB && category.type != .IAB_PURPOSE
        cell.setup(from: nativeLongButton)
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
            selectedCategoryTextLabel.text = categoryDescription[cell.identifier]?.stripOutCss(stripHtml: true)
            if let description = categoryDescription[cell.identifier], description.isNotEmpty() {
                spacer.isHidden = true
            } else {
                spacer.isHidden = false
            }
        }
        return true
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = tableView.cellForRow(at: indexPath) as? LongButtonViewCell
        return cell?.selectable ?? false ? indexPath : nil
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let category = currentCategory(indexPath),
              let cell = tableView.cellForRow(at: indexPath) as? LongButtonViewCell else { return }
        
        let categoryDetailsVC = SPGDPRCategoryDetailsViewController(
            messageId: messageId,
            campaignType: campaignType,
            viewData: pmData.categoryDetailsView,
            pmData: pmData,
            delegate: nil,
            nibName: "SPGDPRCategoryDetailsViewController"
        )
        categoryDetailsVC.category = category
        categoryDetailsVC.categoryManagerDelegate = consentsSnapshot
        categoryDetailsVC.categoryType = cell.contentType
        
        // Purpose toggle is active for the first section or special features (Section 3)
        categoryDetailsVC.purposeToggleActive = indexPath.section == 0 || indexPath.section == 3
        
        present(categoryDetailsVC, animated: true)
    }
}
