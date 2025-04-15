//
//  SPCCPAPartnersViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Vilas on 06/05/21.
//

import Foundation
import UIKit

class SPCCPAPartnersViewController: SPNativeScreenViewController {
    var nativeLongButton: SPNativeLongButton?

    var consentsSnapshot = CCPAPMConsentSnaptshot()

    var vendors: [CCPAVendor] = []

    var sections: [SPNativeText?] {
        [viewData.byId("VendorsHeader") as? SPNativeText]
    }

    let cellReuseIdentifier = "cell"

    @IBOutlet var selectedVendorTextLabel: UILabel!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var acceptButton: SPAppleTVButton!
    @IBOutlet var saveAndExit: SPAppleTVButton!
    @IBOutlet var vendorsTableView: UITableView!
    @IBOutlet var header: SPPMHeader!
    @IBOutlet var actionsContainer: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setHeader()
        loadButton(forComponentId: "AcceptAllButton", button: acceptButton)
        loadButton(forComponentId: "SaveButton", button: saveAndExit)
        loadImage(forComponentId: "LogoImage", imageView: logoImageView)
        nativeLongButton = viewData.byId("VendorButton") as? SPNativeLongButton
        vendorsTableView.register(
            LongButtonViewCell.nib,
            forCellReuseIdentifier: cellReuseIdentifier
        )
        vendorsTableView.delegate = self
        vendorsTableView.dataSource = self
        consentsSnapshot.onConsentsChange = { [weak self] in
            self?.vendorsTableView.reloadData()
        }
    }

    @IBAction func onBackTap(_ sender: Any) {
        dismiss(animated: true)
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
        addFocusGuide(from: actionsContainer, to: vendorsTableView, direction: .rightLeft)
        vendorsTableView.remembersLastFocusedIndexPath = true
    }

    func setHeader () {
        loadButton(forComponentId: "BackButton", button: header.backButton)
        header.spTitleText = viewData.byId("Header") as? SPNativeText
        header.onBackButtonTapped = { [weak self] in self?.dismiss(animated: true) }
    }
}

// MARK: UITableViewDataSource
extension SPCCPAPartnersViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let sectionComponent = sections[section] else { return nil }

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        loadLabelText(forComponent: sectionComponent, label: label)
        return label
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        60
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vendors.count
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = vendorsTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? LongButtonViewCell else {
            return UITableViewCell()
        }

        let vendor = vendors[indexPath.row]
        cell.labelText = vendor.name
        switch consentsSnapshot.consentStatus {
            case .ConsentedAll, .RejectedNone: cell.isOn = true
            case .RejectedAll: cell.isOn = false
            default: cell.isOn = !consentsSnapshot.toggledVendorsIds.contains(vendor._id)
        }
        cell.selectable = true
        cell.isCustom = false
        cell.setup(from: nativeLongButton)
        cell.loadUI()
        return cell
    }

    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        true
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vendorDetailsVC = SPCCPAVendorDetailsViewController(
            messageId: messageId,
            campaignType: campaignType,
            viewData: pmData.vendorDetailsView,
            pmData: pmData,
            delegate: nil,
            nibName: "SPCCPAVendorDetailsViewController"
        )

        vendorDetailsVC.vendor = vendors[indexPath.row]
        vendorDetailsVC.vendorManagerDelegate = consentsSnapshot
        present(vendorDetailsVC, animated: true)
    }
}
