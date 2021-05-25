//
//  SPVendorDetailsViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Vilas on 11/05/21.
//

import UIKit

class SPVendorDetailsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var barcodeLabel: UILabel!
    @IBOutlet weak var barcodeImageView: UIImageView!
    @IBOutlet weak var onButton: UIButton!
    @IBOutlet weak var offButton: UIButton!
    @IBOutlet weak var backButton: UIButton!

    @IBOutlet weak var vendorDetailsTableView: UITableView!

    let categoryList: [String] = [
        "Store and/or access information on a device",
        "Select personalized content",
        "Personalized ads,ad meansurement and audience insights",
        "Project developement",
        "Information storage and access",
        "Ad selection,delivery,reporting",
        "Measure ad performance",
        "Develop and improve products",
        "Use precise geolocation data"
    ]
    let sections = ["Vendor Consents", "Special Purposes", "Special features"]
    let cellReuseIdentifier = "cell"

    let vendorDetailsView: SPPrivacyManager
    let selectedVendor: String

    public init(vendorDetailsView: SPPrivacyManager, selectedVendor: String) {
        self.vendorDetailsView = vendorDetailsView
        self.selectedVendor = selectedVendor
        super.init(nibName: "SPVendorDetailsViewController", bundle: Bundle.framework)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadLabelText(forComponentId id: String, label: UILabel) {
        if let textDetails = vendorDetailsView.components.first(where: {component in component.id == id }) {
            label.text = self.selectedVendor
            label.textColor = UIColor(hexString: textDetails.style?.font?.color)
            if let fontFamily = textDetails.style?.font?.fontFamily,
               let fontsize = textDetails.style?.font?.fontSize {
                label.font = UIFont(name: fontFamily, size: fontsize)
            }
        }
    }

    func loadBody(forComponentId id: String, textView: UITextView) {
        if let categoriesDescription = vendorDetailsView.components.first(where: {component in component.id == id }) {
            textView.text = categoriesDescription.text
            textView.textColor = UIColor(hexString: categoriesDescription.style?.font?.color)
            if let fontFamily = categoriesDescription.style?.font?.fontFamily,
               let fontsize = categoriesDescription.style?.font?.fontSize {
                textView.font = UIFont(name: fontFamily, size: fontsize)
            }
        }
    }

    func loadActionButton(forComponentId id: String, button: UIButton) {
        if let action =  vendorDetailsView.components.first(where: { component in component.id == id }) {
            button.titleLabel?.text = action.text
            button.setTitleColor(UIColor(hexString: action.style?.onUnfocusTextColor), for: .normal)
            button.setTitleColor(UIColor(hexString: action.style?.onFocusTextColor), for: .focused)
            button.backgroundColor = UIColor(hexString: action.style?.onUnfocusBackgroundColor)
            if let fontFamily = action.style?.font?.fontFamily,
               let fontsize = action.style?.font?.fontSize {
                button.titleLabel?.font = UIFont(name: fontFamily, size: fontsize)
            }
        }
    }

    func loadBackButton(forComponentId id: String, button: UIButton) {
        if let action =  vendorDetailsView.components.first(where: { component in component.id == id }) {
            button.titleLabel?.text = action.text
            button.setTitleColor(UIColor(hexString: action.style?.font?.color), for: .normal)
            button.backgroundColor = UIColor(hexString: action.style?.backgroundColor)
            if let fontFamily = action.style?.font?.fontFamily, let fontsize = action.style?.font?.fontSize {
                button.titleLabel?.font = UIFont(name: fontFamily, size: fontsize)
            }
        }
    }

    func setupHomeView() {
        self.view.backgroundColor = UIColor(hexString: vendorDetailsView.style.backgroundColor)
        self.view.tintColor = UIColor(hexString: vendorDetailsView.style.backgroundColor)
        descriptionTextView.textContainer.lineFragmentPadding = 0
        descriptionTextView.textContainerInset = .zero
        loadLabelText(forComponentId: "HeaderText", label: titleLabel)
        loadBody(forComponentId: "CategoriesHeader", textView: descriptionTextView)
        loadActionButton(forComponentId: "AcceptAllButton", button: onButton)
        loadActionButton(forComponentId: "SaveButton", button: offButton)
        loadBackButton(forComponentId: "BackButton", button: backButton)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.vendorDetailsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        vendorDetailsTableView.delegate = self
        vendorDetailsTableView.dataSource = self
        setupHomeView()
    }

    @IBAction func onBackTap(_ sender: Any) {

    }

    @IBAction func onOnButtonTap(_ sender: Any) {

    }

    @IBAction func onOffButtonTap(_ sender: Any) {

    }
}

// MARK: UITableViewDataSource
extension SPVendorDetailsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else if section == 1 {
            return 5
        } else {
            return 4
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: UITableViewCell = (self.vendorDetailsTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        cell.textLabel?.text = categoryList[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SPVendorDetailsViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let partnersController = SPCategoryDetailsViewController(categoriesDetailsView: categoriesView)
//        partnersController.modalPresentationStyle = .currentContext
//        present(partnersController, animated: true, completion: nil)
    }
}
