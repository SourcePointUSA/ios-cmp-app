//
//  SPGDPRVendorDetailsViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Vilas on 11/05/21.
//

import Foundation
import UIKit

class SPGDPRVendorDetailsViewController: SPNativeScreenViewController {
    struct Content: Decodable {
        let name: String
        let retention: String?
    }
    struct Section {
        let header: SPNativeText?
        var content: [Content]
        var hasAdditionalContent: Bool=false

        init? (header: SPNativeText?, content: [String]?, additionalContent: [GDPRVendor.Category]?=nil) {
            if content == nil || content?.isEmpty == true { return nil }
            self.header = header
            self.content=[]
            if additionalContent?.compactMap({ $0.retention }).isNotEmpty() ?? false { self.hasAdditionalContent=true }
            content?.forEach { name in
                if additionalContent?.isNotEmpty() ?? false {
                    let retention = additionalContent?.first(where: { $0.name == name })?.retention
                    self.content.append(Content(name: name, retention: retention))
                } else {
                    self.content.append(Content(name: name, retention: nil))
                }
            }
        }
    }

    var nativeLongButton: SPNativeLongButton?

    weak var vendorManagerDelegate: GDPRPMConsentSnaptshot?
    var displayingPurposes: Bool { categorySlider.selectedSegmentIndex == 0 }

    let cellReuseIdentifier = "cell"
    var vendor: GDPRVendor?
    var displayingLegIntVendors = false
    var sections: [Section] {[
        Section(header: viewData.byId("PurposesText") as? SPNativeText, content: vendor?.consentCategories.map { $0.name }, additionalContent: vendor?.consentCategories),
        Section(header: viewData.byId("SpecialPurposesText") as? SPNativeText, content: vendor?.iabSpecialPurposes, additionalContent: vendor?.iabSpecialPurposesObjs),
        Section(header: viewData.byId("FeaturesText") as? SPNativeText, content: vendor?.iabFeatures),
        Section(header: viewData.byId("SpecialFeaturesText") as? SPNativeText, content: vendor?.iabSpecialFeatures)
    ].compactMap { $0 }}

    @IBOutlet var headerView: SPPMHeader!
    @IBOutlet var PolicyQrCodeImageView: UIImageView!
    @IBOutlet var LegIntQrCodeImageView: UIImageView!
    @IBOutlet var PolicyQrCodeLabel: UILabel!
    @IBOutlet var LegIntQrCodeLabel: UILabel!
    @IBOutlet var ToScanLabel: UILabel!
    @IBOutlet var NoteLabel: UILabel!
    @IBOutlet var descriptionTextView: SPFocusableTextView!
    @IBOutlet var onButton: SPAppleTVButton!
    @IBOutlet var offButton: SPAppleTVButton!
    @IBOutlet var vendorDetailsTableView: UITableView!
    @IBOutlet weak var vendorDetailsTextView: UITextView!
    @IBOutlet var actionsContainer: UIStackView!
    @IBOutlet var categorySlider: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        setHeader()
        loadTextView(forComponentId: "VendorDescription", textView: descriptionTextView, text: vendor?.description, bounces: false)
        if vendor?.description==nil {
            descriptionTextView.isHidden=true
        }
        loadTextView(forComponentId: "VendorDescription", textView: vendorDetailsTextView)
        loadLabelText(forComponentId: "QrInstructions", label: ToScanLabel)
        descriptionTextView.flashScrollIndicators()
        loadButton(forComponentId: "OnButton", button: onButton)
        loadButton(forComponentId: "OffButton", button: offButton)
        if vendor?.disclosureOnlyCategories.isNotEmpty() ?? false {
            hideOnOffButtons()
        }
        loadQrCodes()
        nativeLongButton = viewData.byId("CategoryButtons") as? SPNativeLongButton
        vendorDetailsTableView.allowsSelection = false
        vendorDetailsTableView.register(
            UINib(nibName: "LongButtonViewCell", bundle: Bundle.framework),
            forCellReuseIdentifier: cellReuseIdentifier
        )
        vendorDetailsTableView.delegate = self
        vendorDetailsTableView.dataSource = self

        loadVendorDataText()
        vendorDetailsTableView.isHidden=false
        vendorDetailsTextView.isHidden=true
    }

    @IBAction func onCategorySliderTap(_ sender: Any) {
        if displayingPurposes {
            vendorDetailsTableView.isHidden=false
            vendorDetailsTableView.reloadData()
            vendorDetailsTextView.isHidden=true
        } else {
            vendorDetailsTableView.isHidden=true
            vendorDetailsTextView.isHidden=false
        }
    }

    @IBAction func onOnButtonTap(_ sender: Any) {
        if let vendor = vendor {
            vendorManagerDelegate?.onVendorOn(vendor: vendor, legInt: displayingLegIntVendors)
        }
        dismiss(animated: true)
    }

    @IBAction func onOffButtonTap(_ sender: Any) {
        if let vendor = vendor {
            vendorManagerDelegate?.onVendorOff(vendor: vendor, legInt: displayingLegIntVendors)
        }
        dismiss(animated: true)
    }

    func loadVendorDataText() {
        if vendor?.iabDataCategories?.isEmpty ?? true {
            categorySlider.removeSegment(at: 1, animated: false)
            categorySlider.selectedSegmentIndex = 0
            return
        }
        var labels = [String()]
        var text = ""
        vendor?.iabDataCategories?.forEach { data in
            text+=data.name+"\r\n"
            labels.append(data.name)
            text+=data.description+"\r\n\r\n"
        }
        let attributedText = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 26)]) // swiftlint:disable:this line_length
        labels.forEach { label in
            let labelRange = (text as NSString).range(of: label)
            attributedText.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 26), range: labelRange)
        }
        vendorDetailsTextView.attributedText = attributedText
    }

    func loadQrCodes() {
        if let vendorPolicyUrl = vendor?.policyUrl?.absoluteString {
            PolicyQrCodeImageView.image = QRCode(from: vendorPolicyUrl)
            PolicyQrCodeImageView.isHidden = PolicyQrCodeImageView.image == nil
            PolicyQrCodeLabel.isHidden = PolicyQrCodeImageView.image == nil
        }
        if let vendorLegIntUrl = vendor?.legIntUrl?.absoluteString {
            LegIntQrCodeImageView.image = QRCode(from: vendorLegIntUrl)
            LegIntQrCodeImageView.isHidden = LegIntQrCodeImageView.image == nil
            LegIntQrCodeLabel.isHidden = LegIntQrCodeImageView.image == nil
        }
        PolicyQrCodeLabel.setDefaultTextColorForDarkMode()
        LegIntQrCodeLabel.setDefaultTextColorForDarkMode()
        ToScanLabel.setDefaultTextColorForDarkMode()
        ToScanLabel.isHidden = PolicyQrCodeImageView.image == nil && LegIntQrCodeImageView.image == nil
        NoteLabel.isHidden = PolicyQrCodeImageView.image == nil && LegIntQrCodeImageView.image == nil
    }

    func hideOnOffButtons() {
        onButton.isHidden = true
        offButton.isHidden = true
        addFocusGuide(from: headerView.backButton, to: vendorDetailsTableView, direction: .rightLeft)
    }

    func setHeader () {
        loadButton(forComponentId: "BackButton", button: headerView.backButton)
        headerView.spTitleText = viewData.byId("Header") as? SPNativeText
        headerView.titleLabel.text = vendor?.name
        headerView.onBackButtonTapped = { [weak self] in self?.dismiss(animated: true) }
    }

    override func setFocusGuides() {
        addFocusGuide(from: headerView.backButton, to: actionsContainer, direction: .bottomTop)
        addFocusGuide(from: headerView.backButton, to: categorySlider, direction: .right)
        addFocusGuide(from: actionsContainer, to: vendorDetailsTableView, direction: .rightLeft)
        addFocusGuide(from: actionsContainer, to: vendorDetailsTextView, direction: .rightLeft)
        addFocusGuide(from: categorySlider, to: headerView.backButton, direction: .left)
        addFocusGuide(from: categorySlider, to: vendorDetailsTableView, direction: .bottomTop)
        addFocusGuide(from: categorySlider, to: vendorDetailsTextView, direction: .bottomTop)
    }
}

// MARK: UITableViewDataSource
extension SPGDPRVendorDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
        label.text = sections[section].header?.settings.text
        label.font = UIFont(from: sections[section].header?.settings.style.font)
        label.textColor = UIColor(hexString: sections[section].header?.settings.style.font.color)
        headerView.addSubview(label)
        if sections[section].hasAdditionalContent {
            let retentionlabel = UILabel(frame: CGRect(x: tableView.frame.width-110, y: 0, width: 100, height: 50))
            retentionlabel.text = "Retention"
            retentionlabel.font = UIFont(from: sections[section].header?.settings.style.font)
            retentionlabel.textColor = UIColor(hexString: sections[section].header?.settings.style.font.color)
            headerView.addSubview(retentionlabel)
        }
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].content.count
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? LongButtonViewCell else {
            return UITableViewCell()
        }
        cell.labelText = sections[indexPath.section].content[indexPath.row].name
        cell.customText=sections[indexPath.section].content[indexPath.row].retention
        cell.loadUI()
        return cell
    }

    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        true
    }
}
