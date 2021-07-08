//
//  SPPartnersViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Vilas on 06/05/21.
//

import UIKit
import Foundation

class SPPartnersViewController: SPNativeScreenViewController {
    @IBOutlet weak var selectedvendorTextLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var saveAndExit: UIButton!
    @IBOutlet weak var vendorsSlider: UISegmentedControl!
    @IBOutlet weak var vendorsTableView: UITableView!
    @IBOutlet weak var header: SPPMHeader!
    @IBOutlet weak var actionsContainer: UIStackView!

    weak var vendorManagerDelegate: PMVendorManager?

    var vendors: [VendorListVendor] = []
    var userConsentVendors: [VendorListVendor] { vendors.filter { !$0.consentCategories.isEmpty } }
    var legitimateInterestVendorList: [VendorListVendor] { vendors.filter { !$0.legIntCategories.isEmpty } }
    var acceptedVendors: [String] = []

    var sections: [SPNativeText?] {
        [viewData.byId("VendorsHeader") as? SPNativeText]
    }
    let cellReuseIdentifier = "cell"

    override func setFocusGuides() {
        addFocusGuide(from: header.backButton, to: actionsContainer, direction: .bottomTop)
        addFocusGuide(from: vendorsSlider, to: vendorsTableView, direction: .bottomTop)
        addFocusGuide(from: vendorsSlider, to: header.backButton, direction: .left)
        addFocusGuide(from: actionsContainer, to: vendorsTableView, direction: .rightLeft)
    }

    func setHeader () {
        header.spBackButton = viewData.byId("BackButton") as? SPNativeButton
        header.spTitleText = viewData.byId("HeaderText") as? SPNativeText
        header.onBackButtonTapped = { [weak self] in self?.dismiss(animated: true) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setHeader()
        loadButton(forComponentId: "AcceptAllButton", button: acceptButton)
        loadButton(forComponentId: "SaveButton", button: saveAndExit)
        loadSliderButton(forComponentId: "VendorsSlider", slider: vendorsSlider)
        vendorsTableView.register(
            UINib(nibName: "LongButtonViewCell", bundle: Bundle.framework),
            forCellReuseIdentifier: cellReuseIdentifier
        )
        vendorsTableView.delegate = self
        vendorsTableView.dataSource = self
    }

    @IBAction func onBackTap(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func onVendorSliderTap(_ sender: Any) {
        vendorsTableView.reloadData()
    }

    @IBAction func onAcceptTap(_ sender: Any) {
        messageUIDelegate?.action(SPAction(type: .AcceptAll, id: nil, campaignType: campaignType), from: self)
    }

    @IBAction func onSaveAndExitTap(_ sender: Any) {
        messageUIDelegate?.action(SPAction(type: .SaveAndExit, id: nil, campaignType: campaignType), from: self)
    }
}

// MARK: UITableViewDataSource
extension SPPartnersViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        label.text = "\(sections[section]?.settings.text ?? "Partners")"
        label.font = UIFont(from: sections[section]?.settings.style?.font)
        label.textColor = UIColor(hexString: sections[section]?.settings.style?.font?.color)
        return label
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch vendorsSlider.selectedSegmentIndex {
        case 0:
            return userConsentVendors.count
        case 1:
            return legitimateInterestVendorList.count
        default:
            return 0
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = vendorsTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? LongButtonViewCell else {
            return UITableViewCell()
        }

        let vendor = vendorsSlider.selectedSegmentIndex == 0 ?
            userConsentVendors[indexPath.row] :
            legitimateInterestVendorList[indexPath.row]
        cell.labelText = vendor.name
        cell.customText = vendor.vendorType == .CUSTOM ? nil : "Custom"
        cell.isOn = acceptedVendors.contains(vendor.vendorId)
        cell.selectable = true
        cell.onText = "On"
        cell.offText = "Off"
        cell.loadUI()
        return cell
    }

    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        switch vendorsSlider.selectedSegmentIndex {
        case 0:
            loadLabelText(forComponentId: "VendorDescription", labelText: "", label: selectedvendorTextLabel)
                .attributedText = userConsentVendors[indexPath.row].description?.htmlToAttributedString
        case 1:
            loadLabelText(forComponentId: "VendorDescription", labelText: "", label: selectedvendorTextLabel)
                .attributedText = userConsentVendors[indexPath.row].description?.htmlToAttributedString
        default:
            break
        }
        return true
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vendorDetailsVC = SPVendorDetailsViewController(
            messageId: messageId,
            campaignType: campaignType,
            viewData: pmData.vendorDetailsView,
            pmData: pmData,
            delegate: nil,
            nibName: "SPVendorDetailsViewController"
        )
        vendorDetailsVC.vendor = vendors[indexPath.row]
        vendorDetailsVC.vendorManagerDelegate = self
        present(vendorDetailsVC, animated: true)
    }
}

// MARK: - PMVendorManager
extension SPPartnersViewController: PMVendorManager {
    func onVendorOn(_ vendor: VendorListVendor) {
        dismiss(animated: true)
        vendorManagerDelegate?.onVendorOn(vendor)
    }

    func onVendorOff(_ vendor: VendorListVendor) {
        dismiss(animated: true)
        vendorManagerDelegate?.onVendorOff(vendor)
    }
}
