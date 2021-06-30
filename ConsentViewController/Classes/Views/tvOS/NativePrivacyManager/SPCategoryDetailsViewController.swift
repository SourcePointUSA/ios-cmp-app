//
//  SPCategoryDetailsViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Vilas on 11/05/21.
//

import UIKit
import Foundation

class SPCategoryDetailsViewController: SPNativeScreenViewController {
    @IBOutlet weak var header: SPPMHeader!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var onButton: UIButton!
    @IBOutlet weak var offButton: UIButton!
    @IBOutlet weak var actionsContainer: UIStackView!
    @IBOutlet weak var categoryDetailsTableView: UITableView!

    var category: VendorListCategory?
    var partners: [String] {
        ((category?.requiringConsentVendors ?? []) + (category?.legIntVendors ?? []))
            .map { $0.name }
            .reduce([]) { $0.contains($1) ? $0 : $0 + [$1] } // filter duplicates
    }
    let cellReuseIdentifier = "cell"

    func setHeader() {
        header.spBackButton = viewData.byId("BackButton") as? SPNativeButton
        header.spTitleText = viewData.byId("Header") as? SPNativeText
        header.titleLabel.text = category?.name
        header.onBackButtonTapped = { [weak self] in self?.dismiss(animated: true) }
    }

    override func setFocusGuides() {
        addFocusGuide(from: header.backButton, to: actionsContainer, direction: .bottomTop)
        addFocusGuide(from: header.backButton, to: categoryDetailsTableView, direction: .right)
        addFocusGuide(from: actionsContainer, to: categoryDetailsTableView, direction: .rightLeft)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setHeader()
        loadTextView(forComponentId: "CategoryDescription", textView: descriptionTextView).text = category?.description
        loadButton(forComponentId: "AcceptAllButton", button: onButton)
        loadButton(forComponentId: "SaveButton", button: offButton)
        categoryDetailsTableView.allowsSelection = false
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
extension SPCategoryDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        partners.count
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = (categoryDetailsTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell?)!
        cell.selectionStyle = .none
        cell.textLabel?.text = partners[indexPath.row]
        return cell
    }

    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        true
    }
}
