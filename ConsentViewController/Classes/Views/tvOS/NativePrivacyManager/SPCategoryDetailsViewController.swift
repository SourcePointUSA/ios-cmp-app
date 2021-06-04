//
//  SPCategoryDetailsViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Vilas on 11/05/21.
//

import UIKit
import Foundation

class SPCategoryDetailsViewController: SPNativeScreenViewController {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.textContainer.lineFragmentPadding = 0
        descriptionTextView.textContainerInset = .zero
        loadLabelView(forComponentId: "HeaderText", label: titleLabel)
        loadTextView(forComponentId: "CategoriesHeader", textView: descriptionTextView)
        loadButton(forComponentId: "AcceptAllButton", button: onButton)
        loadButton(forComponentId: "SaveButton", button: offButton)
        loadButton(forComponentId: "BackButton", button: backButton)
        categoryDetailsTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        categoryDetailsTableView.delegate = self
        categoryDetailsTableView.dataSource = self
    }

    @IBAction func onBackTap(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func onOnButtonTap(_ sender: Any) {

    }

    @IBAction func onOffButtonTap(_ sender: Any) {

    }
}

// MARK: UITableViewDataSource
extension SPCategoryDetailsViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vendorList.count
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = (categoryDetailsTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
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
