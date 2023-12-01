//
//  SPCategoryDetailsViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Vilas on 11/05/21.
//

import Foundation
import UIKit

class SPGDPRCategoryDetailsViewController: SPNativeScreenViewController {
    weak var categoryManagerDelegate: GDPRPMConsentSnaptshot?

    var category: GDPRCategory?
    var categoryType: CategoryContentType?
    var displayingLegIntCategories: Bool { categoryType == .legitimate }
    var purposeToggleActive = true
    var partners: [String] {
        ((displayingLegIntCategories ?
          (category?.legIntVendors ?? []) :
            (category?.requiringConsentVendors ?? [])) + (category?.vendors ?? []) + (category?.disclosureOnlyVendors ?? [])
        )
            .map { $0.name }
            .reduce([]) { $0.contains($1) ? $0 : $0 + [$1] } // filter duplicates
    }
    var sections: [SPNativeText?] {
        [viewData.byId("VendorsHeader") as? SPNativeText]
    }
    let cellReuseIdentifier = "cell"

    @IBOutlet var header: SPPMHeader!
    @IBOutlet var descriptionTextView: SPFocusableTextView!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var onButton: SPAppleTVButton!
    @IBOutlet var offButton: SPAppleTVButton!
    @IBOutlet var actionsContainer: UIStackView!
    @IBOutlet var categoryDetailsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeader()
        loadTextView(forComponentId: "CategoryDescription", textView: descriptionTextView, text: category?.description, bounces: false)
        descriptionTextView.flashScrollIndicators()
        loadImage(forComponentId: "LogoImage", imageView: logoImageView)
        loadButton(forComponentId: "OnButton", button: onButton)
        loadButton(forComponentId: "OffButton", button: offButton)
        if !purposeToggleActive {
            hideOnOffButtons()
        }
        categoryDetailsTableView.allowsSelection = false
        categoryDetailsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        categoryDetailsTableView.delegate = self
        categoryDetailsTableView.dataSource = self
    }

    @IBAction func onBackTap(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func onOnButtonTap(_ sender: Any) {
        if let category = category {
            categoryManagerDelegate?.onCategoryOn(category: category, type: categoryType)
        }
        dismiss(animated: true)
    }

    @IBAction func onOffButtonTap(_ sender: Any) {
        if let category = category {
            categoryManagerDelegate?.onCategoryOff(category: category, type: categoryType)
        }
        dismiss(animated: true)
    }

    func hideOnOffButtons() {
        onButton.isHidden = true
        offButton.isHidden = true
        addFocusGuide(from: header.backButton, to: categoryDetailsTableView, direction: .rightLeft)
    }

    func setHeader() {
        loadButton(forComponentId: "BackButton", button: header.backButton)
        header.spTitleText = viewData.byId("Header") as? SPNativeText
        header.titleLabel.text = category?.name
        header.onBackButtonTapped = { [weak self] in self?.dismiss(animated: true) }
    }

    override func setFocusGuides() {
        addFocusGuide(from: header.backButton, to: actionsContainer, direction: .bottomTop)
        addFocusGuide(from: header.backButton, to: categoryDetailsTableView, direction: .right)
        addFocusGuide(from: actionsContainer, to: categoryDetailsTableView, direction: .rightLeft)
    }
}

// MARK: UITableViewDataSource
extension SPGDPRCategoryDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        label.text = "\(sections[section]?.settings.text ?? "Partners") (\(partners.count))"
        label.font = UIFont(from: sections[section]?.settings.style.font)
        label.textColor = UIColor(hexString: sections[section]?.settings.style.font.color)
        return label
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        partners.count
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = (categoryDetailsTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?) ?? UITableViewCell()
        cell.selectionStyle = .none
        cell.textLabel?.text = partners[indexPath.row]
        cell.textLabel?.setDefaultTextColorForDarkMode()
        return cell
    }

    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        true
    }
}
