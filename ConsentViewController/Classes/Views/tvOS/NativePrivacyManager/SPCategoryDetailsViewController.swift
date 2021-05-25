//
//  SPCategoryDetailsViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Vilas on 11/05/21.
//

import UIKit

class SPCategoryDetailsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var subDescriptionTextLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var onButton: UIButton!
    @IBOutlet weak var offButton: UIButton!
    @IBOutlet weak var backButton: UIButton!

    @IBOutlet weak var categoryDetailsTableView: UITableView!

    let vendorList = [
        "Arcspire Limited",
        "Amobee Inc",
        "AppNexus",
        "Audiens S.r.l",
        "Bannerflow AB",
        "BeeswaxLo Corporation",
        "Beachfront Media LLC",
        "Bidstack ltd",
        "Celtra, Inc",
        "ChartBeat"
    ]
    let cellReuseIdentifier = "cell"

    let categoryDetailsView: SPPrivacyManager
    let selectedCategory: String

    public init(categoriesDetailsView: SPPrivacyManager, selectedCategory: String) {
        categoryDetailsView = categoriesDetailsView
        self.selectedCategory = selectedCategory
        super.init(nibName: "SPCategoryDetailsViewController", bundle: Bundle.framework)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadLabelText(forComponentId id: String, label: UILabel) {
        if let textDetails = categoryDetailsView.components.first(where: {component in component.id == id }) {
            label.text = self.selectedCategory
            label.textColor = UIColor(hexString: textDetails.style?.font?.color)
            if let fontFamily = textDetails.style?.font?.fontFamily, let fontsize = textDetails.style?.font?.fontSize {
                label.font = UIFont(name: fontFamily, size: fontsize)
            }
        }
    }

    func loadBody(forComponentId id: String, textView: UITextView) {
        if let categoriesDescription = categoryDetailsView.components.first(where: {component in component.id == id }) {
            textView.text = categoriesDescription.text
            textView.textColor = UIColor(hexString: categoriesDescription.style?.font?.color)
            if let fontFamily = categoriesDescription.style?.font?.fontFamily, let fontsize = categoriesDescription.style?.font?.fontSize {
                textView.font = UIFont(name: fontFamily, size: fontsize)
            }
        }
    }

    func loadActionButton(forComponentId id: String, button: UIButton) {
        if let action =  categoryDetailsView.components.first(where: { component in component.id == id }) {
            button.titleLabel?.text = action.text
            button.setTitleColor(UIColor(hexString: action.style?.onUnfocusTextColor), for: .normal)
            button.setTitleColor(UIColor(hexString: action.style?.onFocusTextColor), for: .focused)
            button.backgroundColor = UIColor(hexString: action.style?.onUnfocusBackgroundColor)
            if let fontFamily = action.style?.font?.fontFamily, let fontsize = action.style?.font?.fontSize {
                button.titleLabel?.font = UIFont(name: fontFamily, size: fontsize)
            }
        }
    }

    func loadBackButton(forComponentId id: String, button: UIButton) {
        if let action =  categoryDetailsView.components.first(where: { component in component.id == id }) {
            button.titleLabel?.text = action.text
            button.setTitleColor(UIColor(hexString: action.style?.font?.color), for: .normal)
            button.backgroundColor = UIColor(hexString: action.style?.backgroundColor)
            if let fontFamily = action.style?.font?.fontFamily, let fontsize = action.style?.font?.fontSize {
                button.titleLabel?.font = UIFont(name: fontFamily, size: fontsize)
            }
        }
    }

    func addBackgroundColor() -> UIColor? {
        return UIColor(hexString: categoryDetailsView.style.backgroundColor)
    }

    func setupHomeView() {
        self.view.backgroundColor = addBackgroundColor()
        self.view.tintColor = addBackgroundColor()
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
        self.categoryDetailsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        categoryDetailsTableView.delegate = self
        categoryDetailsTableView.dataSource = self
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
extension SPCategoryDetailsViewController: UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vendorList.count
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: UITableViewCell = (self.categoryDetailsTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        cell.textLabel?.text = vendorList[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SPCategoryDetailsViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let partnersController = SPCategoryDetailsViewController(categoriesDetailsView: categoriesView)
//        partnersController.modalPresentationStyle = .currentContext
//        present(partnersController, animated: true, completion: nil)
    }
}
