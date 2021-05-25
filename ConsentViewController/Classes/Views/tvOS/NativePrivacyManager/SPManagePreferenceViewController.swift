//
//  SPManagePreferenceViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Vilas on 03/05/21.
//

import UIKit

class SPManagePreferenceViewController: UIViewController {

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
    let sections = ["Vendor Consents", "Special Purposes", "Special features"]
    let cellReuseIdentifier = "cell"

    let categoriesView: SPPrivacyManager
    let pmContent: SPPrivacyManagerResponse

    public init(pmContent: SPPrivacyManagerResponse) {
        self.categoriesView = pmContent.categoriesView
        self.pmContent = pmContent
        super.init(nibName: "SPManagePreferenceViewController", bundle: Bundle.framework)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadLabelText(forComponentId id: String, label: UILabel) {
        if let textDetails = categoriesView.components.first(where: {component in component.id == id }) {
            label.text = textDetails.text
            label.textColor = UIColor(hexString: textDetails.style?.font?.color)
            if let fontFamily = textDetails.style?.font?.fontFamily, let fontsize = textDetails.style?.font?.fontSize {
                label.font = UIFont(name: fontFamily, size: fontsize)
            }
        }
    }

    func loadLabelText(forComponentId id: String, labelText text: String, label: UILabel) {
        if let textDetails = categoriesView.components.first(where: {component in component.id == id }) {
            label.text = text
            label.textColor = UIColor(hexString: textDetails.style?.font?.color)
            if let fontFamily = textDetails.style?.font?.fontFamily, let fontsize = textDetails.style?.font?.fontSize {
                label.font = UIFont(name: fontFamily, size: fontsize)
            }
        }
    }

    func loadBody(forComponentId id: String, textView: UITextView) {
        if let categoriesDescription = categoriesView.components.first(where: {component in component.id == id }) {
            textView.text = categoriesDescription.text
            textView.textColor = UIColor(hexString: categoriesDescription.style?.font?.color)
            if let fontFamily = categoriesDescription.style?.font?.fontFamily, let fontsize = categoriesDescription.style?.font?.fontSize {
                textView.font = UIFont(name: fontFamily, size: fontsize)
            }
        }
    }

    func loadActionButton(forComponentId id: String, button: UIButton) {
        if let action =  categoriesView.components.first(where: { component in component.id == id }) {
            button.titleLabel?.text = action.text
            button.setTitleColor(UIColor(hexString: action.style?.onUnfocusTextColor), for: .normal)
            button.setTitleColor(UIColor(hexString: action.style?.onFocusTextColor), for: .focused)
            button.backgroundColor = UIColor(hexString: action.style?.onUnfocusBackgroundColor)
            if let fontFamily = action.style?.font?.fontFamily, let fontsize = action.style?.font?.fontSize {
                button.titleLabel?.font = UIFont(name: fontFamily, size: fontsize)
            }
        }
    }

    func loadSliderButton(forComponentId id: String, slider: UISegmentedControl) {
        if let sliderDetails =  categoriesView.components.first(where: { component in component.id == id }) {
            slider.setTitle(sliderDetails.sliderDetails?.consentText, forSegmentAt: 0)
            slider.setTitle(sliderDetails.sliderDetails?.legitInterestText, forSegmentAt: 1)
            slider.backgroundColor = UIColor(hexString: sliderDetails.style?.backgroundColor)
            if let fontFamily = sliderDetails.style?.font?.fontFamily, let fontsize = sliderDetails.style?.font?.fontSize {
                let font = UIFont(name: fontFamily, size: fontsize)
                slider.setTitleTextAttributes(
                    [
                        NSAttributedString.Key.font: font ?? "",
                        NSAttributedString.Key.foregroundColor:
                            UIColor(hexString: sliderDetails.style?.font?.color) as Any
                    ], for: .normal)
                slider.setTitleTextAttributes(
                    [
                        NSAttributedString.Key.font: font ?? "",
                        NSAttributedString.Key.foregroundColor: UIColor(hexString: sliderDetails.style?.activeFont?.color) as Any
                    ], for: .selected)
            }
        }
    }

    func loadBackButton(forComponentId id: String, button: UIButton) {
        if let action =  categoriesView.components.first(where: { component in component.id == id }) {
            button.titleLabel?.text = action.text
            button.setTitleColor(UIColor(hexString: action.style?.font?.color), for: .normal)
            button.backgroundColor = UIColor(hexString: action.style?.backgroundColor)
            if let fontFamily = action.style?.font?.fontFamily, let fontsize = action.style?.font?.fontSize {
                button.titleLabel?.font = UIFont(name: fontFamily, size: fontsize)
            }
        }
    }

    func addBackgroundColor() -> UIColor? {
        return UIColor(hexString: categoriesView.style.backgroundColor)
    }

    func setupHomeView() {
        self.view.backgroundColor = addBackgroundColor()
        self.view.tintColor = addBackgroundColor()
        descriptionTextView.textContainer.lineFragmentPadding = 0
        descriptionTextView.textContainerInset = .zero
        loadLabelText(forComponentId: "HeaderText", label: titleLabel)
        loadBody(forComponentId: "CategoriesHeader", textView: descriptionTextView)
        loadActionButton(forComponentId: "AcceptAllButton", button: acceptButton)
        loadActionButton(forComponentId: "SaveButton", button: saveAndExit)
        loadBackButton(forComponentId: "BackButton", button: backButton)
        loadSliderButton(forComponentId: "CategoriesSlider", slider: categorySlider)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.categoriesTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        setupHomeView()
    }

    @IBAction func onBackTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onCategorySliderTap(_ sender: Any) {
        categoriesTableView.reloadData()
    }

    @IBAction func onAcceptTap(_ sender: Any) {
    }

    @IBAction func onSaveAndExitTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: UITableViewDataSource
extension SPManagePreferenceViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
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
        return UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: UITableViewCell = (self.categoriesTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
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
            self.loadLabelText(forComponentId: "CategoriesHeader", labelText: self.categoryList[indexPath.row], label: self.selectedCategoryTextLabel)
        case 1:
            self.loadLabelText(forComponentId: "CategoriesHeader", labelText: ligitimateInterestList[indexPath.row], label: self.selectedCategoryTextLabel)
        default:
            break
        }
        return true
    }
}

// MARK: - UITableViewDelegate
extension SPManagePreferenceViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let partnersController = SPCategoryDetailsViewController(categoriesDetailsView: categoriesView, selectedCategory: self.selectedCategoryTextLabel.text ?? "")
        partnersController.modalPresentationStyle = .currentContext
        present(partnersController, animated: true, completion: nil)
    }
}
