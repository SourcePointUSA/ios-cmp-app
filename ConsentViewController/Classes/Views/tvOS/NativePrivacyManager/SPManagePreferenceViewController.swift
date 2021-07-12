//
//  SPManagePreferenceViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Vilas on 03/05/21.
//

import UIKit
import Foundation

class SPManagePreferenceViewController: SPNativeScreenViewController {
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var selectedCategoryTextLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var saveAndExit: UIButton!
    @IBOutlet weak var categorySlider: UISegmentedControl!
    @IBOutlet weak var categoriesTableView: UITableView!
    @IBOutlet weak var header: SPPMHeader!
    @IBOutlet weak var actionsContainer: UIStackView!

    weak var categoryManagerDelegate: PMCategoryManager?

    var acceptedCategories: [String: Bool] = [:]

    var categories: [VendorListCategory] = []
    var userConsentCategories: [VendorListCategory] { categories.filter { $0.requiringConsentVendors?.isNotEmpty() ?? false } }
    var legIntCategories: [VendorListCategory] { categories.filter { $0.legIntVendors?.isNotEmpty() ?? false } }
    var specialPurposes: [VendorListCategory] = []
    var features: [VendorListCategory] = []
    var specialFeatures: [VendorListCategory] = []

    var categoriesTable: [[VendorListCategory]] {[
        userConsentCategories,
        specialPurposes,
        features,
        specialFeatures
    ]}

    var sections: [SPNativeText?] {
        var sections: [SPNativeText?] = []
        if userConsentCategories.isNotEmpty() {
            sections.append(viewData.byId("PurposesHeader") as? SPNativeText)
            // TODO: add definition
        }
        if specialPurposes.isNotEmpty() {
            sections.append(viewData.byId("SpecialPurposesHeader") as? SPNativeText)
            // TODO: add definition
        }
        if features.isNotEmpty() {
            sections.append(viewData.byId("FeaturesHeader") as? SPNativeText)
            // TODO: add definition
        }
        if specialFeatures.isNotEmpty() {
            sections.append(viewData.byId("SpecialFeaturesHeader") as? SPNativeText)
            // TODO: add definition
        }
        return sections
    }
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
        categoriesTableView.register(
            UINib(nibName: "LongButtonViewCell", bundle: Bundle.framework),
            forCellReuseIdentifier: cellReuseIdentifier
        )
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
    }

    @IBAction func onCategorySliderTap(_ sender: Any) {
        categoriesTableView.reloadData()
    }

    @IBAction func onAcceptTap(_ sender: Any) {
        messageUIDelegate?.action(SPAction(type: .AcceptAll, id: nil, campaignType: campaignType), from: self)
    }

    @IBAction func onSaveAndExitTap(_ sender: Any) {
        messageUIDelegate?.action(SPAction(type: .SaveAndExit, id: nil, campaignType: campaignType), from: self)
    }
}

// MARK: UITableViewDataSource
extension SPManagePreferenceViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        switch categorySlider.selectedSegmentIndex {
        case 0: return sections.count
        default: return 1
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        label.text = sections[section]?.settings.text
        label.font = UIFont(from: sections[section]?.settings.style?.font)
        label.textColor = UIColor(hexString: sections[section]?.settings.style?.font?.color)
        return label
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch categorySlider.selectedSegmentIndex {
        case 0:
            return categoriesTable[section].count
        case 1:
            return legIntCategories.count
        default:
            break
        }
        return 0
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? LongButtonViewCell else {
            return UITableViewCell()
        }

        let section = indexPath.section
        let row = indexPath.row
        if categorySlider.selectedSegmentIndex == 0 {
            let category = categoriesTable[section][row]
            cell.labelText = category.name
            cell.customText = category.type == .IAB_PURPOSE ? nil : "Custom"
            cell.isOn = section == 0 || section == 3 ? acceptedCategories.keys.contains(category._id) : nil
            cell.selectable = section != 1
        } else {
            cell.labelText = legIntCategories[indexPath.row].name
        }
        cell.onText = "On"
        cell.offText = "Off"
        cell.loadUI()
        return cell
    }

    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        indexPath.section != 1
    }

    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        switch categorySlider.selectedSegmentIndex {
        case 0:
            loadLabelText(forComponentId: "CategoriesHeader", labelText: userConsentCategories[indexPath.row].description, label: selectedCategoryTextLabel)
        case 1:
            loadLabelText(forComponentId: "CategoriesHeader", labelText: legIntCategories[indexPath.row].description, label: selectedCategoryTextLabel)
        default:
            break
        }
        return true
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        indexPath.section == 1 ? nil : indexPath
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let categoryDetailsVC = SPCategoryDetailsViewController(
            messageId: messageId,
            campaignType: campaignType,
            viewData: pmData.categoryDetailsView,
            pmData: pmData,
            delegate: nil,
            nibName: "SPCategoryDetailsViewController"
        )
        categoryDetailsVC.category = categories[indexPath.row]
        categoryDetailsVC.categoryManagerDelegate = categoryManagerDelegate
        present(categoryDetailsVC, animated: true)
    }
}
