//
//  SPVendorDetailsViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Vilas on 11/05/21.
//

import UIKit
import Foundation

class SPVendorDetailsViewController: SPNativeScreenViewController {
    @IBOutlet weak var headerView: SPPMHeader!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var barcodeLabel: UILabel!
    @IBOutlet weak var barcodeImageView: UIImageView!
    @IBOutlet weak var onButton: UIButton!
    @IBOutlet weak var offButton: UIButton!
    @IBOutlet weak var vendorDetailsTableView: UITableView!
    @IBOutlet weak var actionsContainer: UIStackView!

    let sections = [
        "Vendor Consents",
        "Special Purposes",
        "Special features"
    ]
    let cellReuseIdentifier = "cell"
    var vendor: VendorListVendor?
    var consentCategories: [String] { vendor?.consentCategories.map { $0.name } ?? [] }
    var specialPurposes: [String] { vendor?.iabSpecialPurposes ?? [] }
    var specialFeatures: [String] { vendor?.iabSpecialFeatures ?? [] }

    func setHeader () {
        headerView.spBackButton = viewData.byId("BackButton") as? SPNativeButton
        headerView.spTitleText = viewData.byId("HeaderText") as? SPNativeText
        headerView.titleLabel.text = vendor?.name
        headerView.onBackButtonTapped = { [weak self] in self?.dismiss(animated: true) }
    }

    override func setFocusGuides() {
        addFocusGuide(from: headerView.backButton, to: actionsContainer, direction: .bottomTop)
        addFocusGuide(from: headerView.backButton, to: vendorDetailsTableView, direction: .right)
        addFocusGuide(from: actionsContainer, to: vendorDetailsTableView, direction: .rightLeft)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setHeader()
        loadTextView(forComponentId: "CategoriesHeader", textView: descriptionTextView)
        loadButton(forComponentId: "AcceptAllButton", button: onButton)
        loadButton(forComponentId: "SaveButton", button: offButton)
        vendorDetailsTableView.allowsSelection = false
        vendorDetailsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        vendorDetailsTableView.delegate = self
        vendorDetailsTableView.dataSource = self
    }

    @IBAction func onOnButtonTap(_ sender: Any) {

    }

    @IBAction func onOffButtonTap(_ sender: Any) {

    }
}

// MARK: UITableViewDataSource
extension SPVendorDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section]
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return consentCategories.count
        } else if section == 1 {
            return specialPurposes.count
        } else if section == 2 {
            return specialFeatures.count
        } else {
            return 0
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = (vendorDetailsTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        var cellText = ""
        let section = indexPath.section
        let row = indexPath.row
        if section == 0 {
            cellText = consentCategories[row]
        } else if section == 1 {
            cellText = specialPurposes[row]
        } else if section == 2 {
            cellText = specialFeatures[row]
        }
        cell.textLabel?.text = cellText
        return cell
    }

    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        true
    }
}
