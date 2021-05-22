//
//  SPNativePrivacyManagerViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Vilas on 01/04/21.
//

import UIKit

@objcMembers class SPNativePrivacyManagerViewController: SPMessageViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var subDescriptionTextLabel: UILabel!
    @IBOutlet weak var selectedCategoryTextLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var ourPartners: UIButton!
    @IBOutlet weak var managePreferenceButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var categoryTableView: UITableView!
    
    let homeView: SPPrivacyManager
    var privacyPolicyView: SPPrivacyManager?
    let contents: SPPrivacyManagerResponse
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
    let cellReuseIdentifier = "cell"

    init(messageId: Int?, contents: SPPrivacyManagerResponse, campaignType: SPCampaignType, delegate: SPMessageUIDelegate?) {
        self.contents = contents
        homeView = contents.homeView
        privacyPolicyView = contents.privacyPolicyView
        super.init(
            messageId: messageId,
            campaignType: campaignType,
            delegate: delegate,
            nibName: "SPNativePrivacyManagerViewController",
            bundle: Bundle.framework
        )
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadLabelText(forComponentId id: String, label: UILabel) {
        if let textDetails = homeView.components.first(where: { $0.id == id }) {
            label.text = textDetails.text
            label.textColor = SDKUtils.hexStringToUIColor(hex: textDetails.style?.font?.color ?? "")
            if let fontFamily = textDetails.style?.font?.fontFamily,
               let fontsize = textDetails.style?.font?.fontSize {
                label.font = UIFont(name: fontFamily, size: fontsize)
            }
        }
    }

    func loadLabelText(forComponentId id: String, labelText text: String, label: UILabel) {
        if let textDetails = homeView.components.first(where: { $0.id == id }) {
            label.text = text
            label.textColor = SDKUtils.hexStringToUIColor(hex: textDetails.style?.font?.color ?? "")
            if let fontFamily = textDetails.style?.font?.fontFamily,
               let fontsize = textDetails.style?.font?.fontSize {
                label.font = UIFont(name: fontFamily, size: fontsize)
            }
        }
    }

    func loadBody(forComponentId id: String, textView: UITextView) {
        if let categoriesDescription = homeView.components.first(where: { $0.id == id }) {
            textView.text = categoriesDescription.text
            textView.textColor = SDKUtils.hexStringToUIColor(hex: categoriesDescription.style?.font?.color ?? "")
            if let fontFamily = categoriesDescription.style?.font?.fontFamily,
               let fontsize = categoriesDescription.style?.font?.fontSize {
                textView.font = UIFont(name: fontFamily, size: fontsize)
            }
        }
    }

    func loadActionButton(forComponentId id: String, button: UIButton) {
        if let action =  homeView.components.first(where: { $0.id == id }) {
            button.titleLabel?.text = action.text
            button.setTitleColor(SDKUtils.hexStringToUIColor(hex: action.style?.onUnfocusTextColor ?? ""), for: .normal)
            button.setTitleColor(SDKUtils.hexStringToUIColor(hex: action.style?.onFocusTextColor ?? ""), for: .focused)
            button.backgroundColor = SDKUtils.hexStringToUIColor(hex: action.style?.onUnfocusBackgroundColor ?? "")
            if let fontFamily = action.style?.font?.fontFamily, let fontsize = action.style?.font?.fontSize {
                button.titleLabel?.font = UIFont(name: fontFamily, size: fontsize)
            }
        }
    }

    func loadBackButton(forComponentId id: String, button: UIButton) {
        if let action =  homeView.components.first(where: { $0.id == id }) {
            button.titleLabel?.text = action.text
            button.setTitleColor(SDKUtils.hexStringToUIColor(hex: action.style?.font?.color ?? ""), for: .normal)
            button.backgroundColor = SDKUtils.hexStringToUIColor(hex: action.style?.backgroundColor ?? "")
            if let fontFamily = action.style?.font?.fontFamily, let fontsize = action.style?.font?.fontSize {
                button.titleLabel?.font = UIFont(name: fontFamily, size: fontsize)
            }
        }
    }

    func showPrivacyPolicy() -> Bool {
        homeView.showPrivacyPolicyBtn ?? false
    }

    func addBackgroundColor() -> UIColor? {
        SDKUtils.hexStringToUIColor(hex: homeView.style.backgroundColor ?? "")
    }

    func setupHomeView() {
        view.backgroundColor = addBackgroundColor()
        view.tintColor = addBackgroundColor()
        privacyPolicyButton.isHidden = showPrivacyPolicy()
        descriptionTextView.textContainer.lineFragmentPadding = 0
        descriptionTextView.textContainerInset = .zero
        loadLabelText(forComponentId: "HeaderText", label: titleLabel)
        loadLabelText(forComponentId: "CategoriesSubDescriptionText", label: subDescriptionTextLabel)
        loadBody(forComponentId: "CategoriesDescriptionText", textView: descriptionTextView)
        loadActionButton(forComponentId: "AcceptAllButton", button: acceptButton)
        loadActionButton(forComponentId: "NavCategoriesButton", button: managePreferenceButton)
        loadActionButton(forComponentId: "NavVendorsButton", button: ourPartners)
        loadActionButton(forComponentId: "NavPrivacyPolicyButton", button: privacyPolicyButton)
        loadBackButton(forComponentId: "BackButton", button: backButton)
        categoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        setupHomeView()
    }

    @IBAction func onBackButtonTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onAcceptTap(_ sender: Any) {

    }

    @IBAction func onManagePreferenceTap(_ sender: Any) {
        let managePreferenceController = SPManagePreferenceViewController(pmContent: contents)
        managePreferenceController.modalPresentationStyle = .currentContext
        present(managePreferenceController, animated: true, completion: nil)
    }

    @IBAction func onPartnersTap(_ sender: Any) {
        let partnersController = SPPartnersViewController(pmContent: contents)
        partnersController.modalPresentationStyle = .currentContext
        present(partnersController, animated: true, completion: nil)
    }

    @IBAction func onPrivacyPolicyTap(_ sender: Any) {
        let privacyPolicyController = SPPrivacyPolicyViewController(privacyPolicyContent: privacyPolicyView!)
        privacyPolicyController.modalPresentationStyle = .currentContext
        present(privacyPolicyController, animated: true, completion: nil)
    }
}

// MARK: UITableViewDataSource
extension SPNativePrivacyManagerViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryList.count
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = categoryTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)! as UITableViewCell
        cell.textLabel?.text = categoryList[indexPath.row]
        return cell
    }

    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        loadLabelText(
            forComponentId: "CategoriesDescriptionText",
            labelText: categoryList[indexPath.row],
            label: selectedCategoryTextLabel
        )
        return true
    }
}

// MARK: - UITableViewDelegate
extension SPNativePrivacyManagerViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
