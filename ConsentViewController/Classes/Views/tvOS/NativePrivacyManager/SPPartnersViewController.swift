//
//  SPPartnersViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Vilas on 06/05/21.
//

import UIKit

class SPPartnersViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var partnerLabel: UILabel!
    @IBOutlet weak var selectedvendorTextLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var saveAndExit: UIButton!
    @IBOutlet weak var backButton: UIButton!

    @IBOutlet weak var vednorsSlider: UISegmentedControl!
    @IBOutlet weak var vendorsTableView: UITableView!

    let vendorList: [String] = [
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
    let ligitimateInterestVendorList: [String] = [
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

    var vendorContent: SPPrivacyManager
    let pmContent: SPPrivacyManagerResponse

    public init(pmContent: SPPrivacyManagerResponse) {
        self.vendorContent = pmContent.vendorsView
        self.pmContent = pmContent
        super.init(nibName: "SPPartnersViewController", bundle: Bundle.framework)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadLabelText(forComponentId id: String, label: UILabel) {
        if let textDetails = vendorContent.components.first(where: {component in component.id == id }) {
            label.text = textDetails.text
            label.textColor = SDKUtils.hexStringToUIColor(hex: textDetails.style?.font?.color ?? "")
            if let fontFamily = textDetails.style?.font?.fontFamily, let fontsize = textDetails.style?.font?.fontSize {
                label.font = UIFont(name: fontFamily, size: fontsize)
            }
        }
    }

    func loadLabelText(forComponentId id: String, labelText text: String, label: UILabel) {
        if let textDetails = vendorContent.components.first(where: {component in component.id == id }) {
            label.text = text
            label.textColor = SDKUtils.hexStringToUIColor(hex: textDetails.style?.font?.color ?? "")
            if let fontFamily = textDetails.style?.font?.fontFamily, let fontsize = textDetails.style?.font?.fontSize {
                label.font = UIFont(name: fontFamily, size: fontsize)
            }
        }
    }

    func loadActionButton(forComponentId id: String, button: UIButton) {
        if let action =  vendorContent.components.first(where: { component in component.id == id }) {
            button.titleLabel?.text = action.text
            button.setTitleColor(SDKUtils.hexStringToUIColor(hex: action.style?.onUnfocusTextColor ?? ""), for: .normal)
            button.setTitleColor(SDKUtils.hexStringToUIColor(hex: action.style?.onFocusTextColor ?? ""), for: .focused)
            button.backgroundColor = SDKUtils.hexStringToUIColor(hex: action.style?.onUnfocusBackgroundColor ?? "")
            if let fontFamily = action.style?.font?.fontFamily, let fontsize = action.style?.font?.fontSize {
                button.titleLabel?.font = UIFont(name: fontFamily, size: fontsize)
            }
        }
    }

    func loadSliderButton(forComponentId id: String, slider: UISegmentedControl) {
        if let sliderDetails =  vendorContent.components.first(where: { component in component.id == id }) {
            slider.setTitle(sliderDetails.sliderDetails?.consentText, forSegmentAt: 0)
            slider.setTitle(sliderDetails.sliderDetails?.legitInterestText, forSegmentAt: 1)
            slider.backgroundColor = SDKUtils.hexStringToUIColor(hex: sliderDetails.style?.backgroundColor ?? "")
            if let fontFamily = sliderDetails.style?.font?.fontFamily, let fontsize = sliderDetails.style?.font?.fontSize {
                let font = UIFont(name: fontFamily, size: fontsize)
                slider.setTitleTextAttributes(
                    [
                        NSAttributedString.Key.font: font ?? "",
                        NSAttributedString.Key.foregroundColor: SDKUtils.hexStringToUIColor(hex: sliderDetails.style?.font?.color ?? "") as Any
                    ], for: .normal)
                slider.setTitleTextAttributes(
                    [
                        NSAttributedString.Key.font: font ?? "",
                        NSAttributedString.Key.foregroundColor: SDKUtils.hexStringToUIColor(hex: sliderDetails.style?.activeFont?.color ?? "") as Any
                    ], for: .selected)
            }
        }
    }

    func loadBackButton(forComponentId id: String, button: UIButton) {
        if let action =  vendorContent.components.first(where: { component in component.id == id }) {
            button.titleLabel?.text = action.text
            button.setTitleColor(SDKUtils.hexStringToUIColor(hex: action.style?.font?.color ?? ""), for: .normal)
            button.backgroundColor = SDKUtils.hexStringToUIColor(hex: action.style?.backgroundColor ?? "")
            if let fontFamily = action.style?.font?.fontFamily, let fontsize = action.style?.font?.fontSize {
                button.titleLabel?.font = UIFont(name: fontFamily, size: fontsize)
            }
        }
    }

    func addBackgroundColor() -> UIColor? {
        return SDKUtils.hexStringToUIColor(hex: vendorContent.style.backgroundColor ?? "")
    }

    func setupHomeView() {
        self.view.backgroundColor = addBackgroundColor()
        self.view.tintColor = addBackgroundColor()
        loadLabelText(forComponentId: "HeaderText", label: titleLabel)
        loadLabelText(forComponentId: "VendorsHeader", label: partnerLabel)
        loadActionButton(forComponentId: "AcceptAllButton", button: acceptButton)
        loadActionButton(forComponentId: "SaveButton", button: saveAndExit)
        loadBackButton(forComponentId: "BackButton", button: backButton)
        loadSliderButton(forComponentId: "CategoriesSlider", slider: vednorsSlider)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.vendorsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        vendorsTableView.delegate = self
        vendorsTableView.dataSource = self
        setupHomeView()
    }

    @IBAction func onBackTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onVendorSliderTap(_ sender: Any) {
        vendorsTableView.reloadData()
    }

    @IBAction func onAcceptTap(_ sender: Any) {
    }

    @IBAction func onSaveAndExitTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: UITableViewDataSource
extension SPPartnersViewController: UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch vednorsSlider.selectedSegmentIndex {
        case 0:
            return vendorList.count
        case 1:
            return ligitimateInterestVendorList.count

        default:
            break
        }
        return 0
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: UITableViewCell = (self.vendorsTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        switch vednorsSlider.selectedSegmentIndex {
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
        switch vednorsSlider.selectedSegmentIndex {
        case 0:
            self.loadLabelText(forComponentId: "VendorsHeader", labelText: vendorList[indexPath.row], label: self.selectedvendorTextLabel)
        case 1:
            self.loadLabelText(forComponentId: "VendorsHeader", labelText: ligitimateInterestVendorList[indexPath.row], label: self.selectedvendorTextLabel)
        default:
            break
        }
        return true
    }
}

// MARK: - UITableViewDelegate
extension SPPartnersViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let partnersController = SPVendorDetailsViewController(vendorDetailsView: vendorContent, selectedVendor: self.selectedvendorTextLabel.text ?? "")
        partnersController.modalPresentationStyle = .currentContext
        present(partnersController, animated: true, completion: nil)
    }
}
