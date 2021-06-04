//
//  SPManagePreferenceViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Vilas on 03/05/21.
//

import UIKit
import Foundation

class SPManagePreferenceViewController: SPNativeScreenViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var selectedCategoryTextLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var saveAndExit: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var categorySlider: UISegmentedControl!
    @IBOutlet weak var categoriesTableView: UITableView!

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
    let ligitimateInterestList = [
        "Ad selection, delivery, reporting",
        "Select personalized content",
        "Personalized ads, ad meansurement and audience insights",
        "Develop and improve products",
        "Use precise geolocation data",
        "Store and/or access information on a device",
        "Project developement",
        "Information storage and access",
        "Measure ad performance"
    ]
    let sections = [
        "Vendor Consents",
        "Special Purposes",
        "Special features"
    ]
    let cellReuseIdentifier = "cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.textContainer.lineFragmentPadding = 0
        descriptionTextView.textContainerInset = .zero
        loadLabelView(forComponentId: "HeaderText", label: titleLabel)
        loadTextView(forComponentId: "CategoriesHeader", textView: descriptionTextView)
        loadButton(forComponentId: "AcceptAllButton", button: acceptButton)
        loadButton(forComponentId: "SaveButton", button: saveAndExit)
        loadButton(forComponentId: "BackButton", button: backButton)
        loadSliderButton(forComponentId: "CategoriesSlider", slider: categorySlider)
        categoriesTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
    }

    @IBAction func onBackTap(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func onCategorySliderTap(_ sender: Any) {
        categoriesTableView.reloadData()
    }

    @IBAction func onAcceptTap(_ sender: Any) {
    }

    @IBAction func onSaveAndExitTap(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: UITableViewDataSource
extension SPManagePreferenceViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section]
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch categorySlider.selectedSegmentIndex {
        case 0:
            if section == 0 {
                return 3
            } else if section == 1 {
                return 5
            } else {
                return 8
            }
        case 1:
            if section == 0 {
                return 2
            } else if section == 1 {
                return 4
            } else {
                return 8
            }
        default:
            break
        }
        return 0
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = (categoriesTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        switch categorySlider.selectedSegmentIndex {
        case 0:
            cell.textLabel?.text = categoryList[indexPath.row]
        case 1:
            cell.textLabel?.text = ligitimateInterestList[indexPath.row]
        default:
            break
        }
        return cell
    }

    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        switch categorySlider.selectedSegmentIndex {
        case 0:
            self.loadLabelText(forComponentId: "CategoriesHeader", labelText: categoryList[indexPath.row], label: selectedCategoryTextLabel)
        case 1:
            self.loadLabelText(forComponentId: "CategoriesHeader", labelText: ligitimateInterestList[indexPath.row], label: selectedCategoryTextLabel)
        default:
            break
        }
        return true
    }
}

// MARK: - UITableViewDelegate
extension SPManagePreferenceViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        present(SPCategoryDetailsViewController(
            messageId: messageId,
            campaignType: campaignType,
            contents: viewData,
            delegate: nil,
            nibName: "SPCategoryDetailsViewController"
        ), animated: true)
    }
}
