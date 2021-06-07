//
//  SPPartnersViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Vilas on 06/05/21.
//

import UIKit

class SPPartnersViewController: SPNativeScreenViewController {
    @IBOutlet weak var partnerLabel: UILabel!
    @IBOutlet weak var selectedvendorTextLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var saveAndExit: UIButton!
    @IBOutlet weak var vendorsSlider: UISegmentedControl!
    @IBOutlet weak var vendorsTableView: UITableView!
    @IBOutlet weak var header: SPPMHeader!
    @IBOutlet weak var actionsContainer: UIStackView!

    let vendorList = [
        "Arcspire Limited",
        "Amobee Inc",
        "AppNexus",
        "Audiens S.r.l",
        "Bannerflow AB",
        "BeeswaxLo Corporation",
        "Beachfront Media LLC",
        "Bidstack ltd",
        "Celtra, Inc", "ChartBeat"
    ]
    let ligitimateInterestVendorList = [
        "Captify Technologs Limited",
        "Digital Control GmbH & amp CO",
        "Delta projects AB",
        "Eyeota Ptd Ltd",
        "BeeswaxLo Corporation",
        "AppNexus",
        "Celtra, Inc",
        "Amobee Inc",
        "ChartBeat"
    ]
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
        header.onBackButtonTapped = { self.dismiss(animated: true) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setHeader()
        loadLabelView(forComponentId: "VendorsHeader", label: partnerLabel)
        loadButton(forComponentId: "AcceptAllButton", button: acceptButton)
        loadButton(forComponentId: "SaveButton", button: saveAndExit)
        loadSliderButton(forComponentId: "CategoriesSlider", slider: vendorsSlider)
        vendorsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
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
    }

    @IBAction func onSaveAndExitTap(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: UITableViewDataSource
extension SPPartnersViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch vendorsSlider.selectedSegmentIndex {
        case 0:
            return vendorList.count
        case 1:
            return ligitimateInterestVendorList.count
        default:
            return 0
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = (self.vendorsTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        switch vendorsSlider.selectedSegmentIndex {
        case 0:
            cell.textLabel?.text = vendorList[indexPath.row]
        case 1:
            cell.textLabel?.text = ligitimateInterestVendorList[indexPath.row]
        default:
            break
        }
        return cell
    }

    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        switch vendorsSlider.selectedSegmentIndex {
        case 0:
            loadLabelText(forComponentId: "VendorsHeader", labelText: vendorList[indexPath.row], label: selectedvendorTextLabel)
        case 1:
            loadLabelText(forComponentId: "VendorsHeader", labelText: ligitimateInterestVendorList[indexPath.row], label: selectedvendorTextLabel)
        default:
            break
        }
        return true
    }
}

// MARK: - UITableViewDelegate
extension SPPartnersViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let partnersController = SPVendorDetailsViewController(vendorDetailsView: vendorContent, selectedVendor: self.selectedvendorTextLabel.text ?? "")
//        present(partnersController, animated: true, completion: nil)
    }
}
