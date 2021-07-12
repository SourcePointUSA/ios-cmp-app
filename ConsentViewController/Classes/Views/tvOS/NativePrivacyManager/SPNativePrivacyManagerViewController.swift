//
//  SPNativePrivacyManagerViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Vilas on 01/04/21.
//

import UIKit
import Foundation

protocol PMCategoryManager: AnyObject {
    var categories: Set<VendorListCategory> { get set }
    var specialPurposes: Set<VendorListCategory> { get set }
    var features: Set<VendorListCategory> { get set }
    var specialFeatures: Set<VendorListCategory> { get set }
    var acceptedCategoriesIds: Set<String> { get set }
    func onCategoryOn(_ category: VendorListCategory)
    func onCategoryOff(_ category: VendorListCategory)
}

protocol PMVendorManager: AnyObject {
    var vendors: Set<VendorListVendor> { get set }
    var acceptedVendorsIds: Set<String> { get set }
    func onVendorOn(_ vendor: VendorListVendor)
    func onVendorOff(_ vendor: VendorListVendor)
}

class PMConsentSnaptshot: NSObject, PMVendorManager, PMCategoryManager {
    var grants: SPGDPRVendorGrants
    var vendors: Set<VendorListVendor>
    var acceptedVendorsIds: Set<String>
    var categories, specialPurposes, features, specialFeatures: Set<VendorListCategory>
    var acceptedCategoriesIds: Set<String>

    var vendorsWhosePurposesAreOff: [String] {
        acceptedVendorsIds
            .compactMap { id in vendors.first { $0.vendorId == id } }
            .filter { vendor in
                let vendorCategoriesIds = (grants[vendor.vendorId] ?? SPGDPRVendorGrant()).purposeGrants.keys
                return acceptedCategoriesIds.intersection(vendorCategoriesIds).isEmpty
            }
            .map { $0.vendorId }
    }

    init(
        grants: SPGDPRVendorGrants,
        vendors: Set<VendorListVendor>,
        categories: Set<VendorListCategory>,
        specialPurposes: Set<VendorListCategory>,
        features: Set<VendorListCategory>,
        specialFeatures: Set<VendorListCategory>
    ) {
        self.grants = grants
        self.vendors = vendors
        self.categories = categories
        self.specialPurposes = specialPurposes
        self.features = features
        self.specialFeatures = specialFeatures
        acceptedVendorsIds = Set<String>(
            grants.filter { $0.value.softGranted }.map{ $0.key }
        )
        acceptedCategoriesIds = Set<String>(
            grants.flatMap{ vendors in vendors.value.purposeGrants.filter{$0.value}.keys }
        )
    }

    func onCategoryOn(_ category: VendorListCategory) {
        acceptedCategoriesIds.insert(category._id)
        acceptedVendorsIds.formUnion(category.uniqueVendorIds)

        print("""
        On Purpose: {
          "_id": "\(category._id)",
          "type": "\(category.type?.rawValue ?? "")",
          "iabId": \(category.iabId ?? 99),
          "consent": true,
          "legInt": false
        }
        """
        )
    }

    func onCategoryOff(_ category: VendorListCategory) {
        acceptedCategoriesIds.remove(category._id)
        acceptedVendorsIds.subtract(vendorsWhosePurposesAreOff)

        print("""
        Off Purpose: {
          "_id": "\(category._id)",
          "type": "\(category.type?.rawValue ?? "")",
          "iabId": \(category.iabId ?? 99),
          "consent": false,
          "legInt": false
        }
        """
        )
    }

    func onVendorOn(_ vendor: VendorListVendor) {
        acceptedVendorsIds.insert(vendor.vendorId)

        print("""
        On Vendor: {
          "_id": "\(vendor.vendorId)",
          "vendorType": "\(vendor.vendorType.rawValue)",
          "iabId": \(vendor.iabId ?? 99),
          "consent": true,
          "legInt": false
        }
        """
        )
    }

    func onVendorOff(_ vendor: VendorListVendor) {
        acceptedVendorsIds.remove(vendor.vendorId)

        print("""
        Off Vendor: {
          "_id": "\(vendor.vendorId)",
          "vendorType": "\(vendor.vendorType.rawValue)",
          "iabId": \(vendor.iabId ?? 99),
          "consent": false,
          "legInt": false
        }
        """
        )
    }
}

@objcMembers class SPNativePrivacyManagerViewController: SPNativeScreenViewController {
    weak var delegate: SPNativePMDelegate?

    @IBOutlet weak var categoriesExplainerLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var selectedCategoryTextLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var ourPartners: UIButton!
    @IBOutlet weak var managePreferenceButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    @IBOutlet weak var categoryTableView: UITableView!

    @IBOutlet weak var header: SPPMHeader!

    var categories: [VendorListCategory] { pmData.categories }
    var vendorGrants: SPGDPRVendorGrants?
    let cellReuseIdentifier = "cell"

    var pmConsentsManager: PMConsentSnaptshot?

    override var preferredFocusedView: UIView? { acceptButton }

    func setHeader () {
        header.spBackButton = viewData.byId("BackButton") as? SPNativeButton
        header.spTitleText = viewData.byId("HeaderText") as? SPNativeText
        header.onBackButtonTapped = { [weak self] in
            if let this = self {
                self?.messageUIDelegate?.action(SPAction(type: .Dismiss), from: this)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setHeader()
        loadLabelView(forComponentId: "CategoriesHeader", label: categoriesExplainerLabel)
        loadTextView(forComponentId: "PublisherDescription", textView: descriptionTextView)
        loadButton(forComponentId: "AcceptAllButton", button: acceptButton)
        loadButton(forComponentId: "NavCategoriesButton", button: managePreferenceButton)
        loadButton(forComponentId: "NavVendorsButton", button: ourPartners)
        loadButton(forComponentId: "NavPrivacyPolicyButton", button: privacyPolicyButton)
        categoryTableView.allowsSelection = false
        categoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    }

    @IBAction func onAcceptTap(_ sender: Any) {
        action(
            SPAction(type: .AcceptAll, id: nil, campaignType: campaignType),
            from: self
        )
    }

    @IBAction func onManagePreferenceTap(_ sender: Any) {
        delegate?.on2ndLayerNavigating(messageId: messageId) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.onError(error)
            case .success(let data):
                if let strongSelf = self {
                    let controller = SPManagePreferenceViewController(
                        messageId: self?.messageId,
                        campaignType: strongSelf.campaignType,
                        viewData: strongSelf.pmData.categoriesView,
                        pmData: strongSelf.pmData,
                        delegate: self,
                        nibName: "SPManagePreferenceViewController"
                    )
                    if self?.pmConsentsManager == nil {
                        self?.pmConsentsManager = PMConsentSnaptshot (
                            grants: data.vendorGrants ?? SPGDPRVendorGrants(),
                            vendors: Set<VendorListVendor>(data.vendors),
                            categories: Set<VendorListCategory>(data.categories),
                            specialPurposes: Set<VendorListCategory>(data.specialPurposes),
                            features: Set<VendorListCategory>(data.features),
                            specialFeatures: Set<VendorListCategory>(data.specialFeatures)
                        )
                    }
                    controller.categories = data.categories
                    controller.specialPurposes = data.specialPurposes
                    controller.features = data.features
                    controller.specialFeatures = data.specialFeatures
                    controller.categoryManagerDelegate = self?.pmConsentsManager
                    self?.present(controller, animated: true)
                }
            }
        }
    }

    @IBAction func onPartnersTap(_ sender: Any) {
        delegate?.on2ndLayerNavigating(messageId: messageId) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.onError(error)
            case .success(let data):
                if let strongSelf = self {
                    if self?.pmConsentsManager == nil {
                        self?.pmConsentsManager = PMConsentSnaptshot (
                            grants: data.vendorGrants ?? SPGDPRVendorGrants(),
                            vendors: Set<VendorListVendor>(data.vendors),
                            categories: Set<VendorListCategory>(data.categories),
                            specialPurposes: Set<VendorListCategory>(data.specialPurposes),
                            features: Set<VendorListCategory>(data.features),
                            specialFeatures: Set<VendorListCategory>(data.specialFeatures)
                        )
                    }
                    let controller = SPPartnersViewController(
                        messageId: self?.messageId,
                        campaignType: strongSelf.campaignType,
                        viewData: strongSelf.pmData.vendorsView,
                        pmData: strongSelf.pmData,
                        delegate: self,
                        nibName: "SPPartnersViewController"
                    )
                    controller.vendors = data.vendors
                    controller.vendorManagerDelegate = self?.pmConsentsManager
                    self?.present(controller, animated: true)
                }
            }
        }
    }

    @IBAction func onPrivacyPolicyTap(_ sender: Any) {
        guard let privacyPolicyView = pmData.privacyPolicyView else {
            onError(UnableToFindView(withId: "PrivacyPolicyView"))
            return
        }
        present(SPPrivacyPolicyViewController(
            messageId: messageId,
            campaignType: campaignType,
            viewData: privacyPolicyView,
            pmData: pmData,
            delegate: self,
            nibName: "SPPrivacyPolicyViewController"
        ), animated: true)
    }
}

extension SPNativePrivacyManagerViewController: SPMessageUIDelegate {
    func loaded(_ controller: SPMessageViewController) {
        messageUIDelegate?.loaded(self)
    }

    func action(_ action: SPAction, from controller: SPMessageViewController) {
        if action.type == .SaveAndExit, let pmPayload = try? SPJson(["foo": "bar"]) {
            action.pmPayload = pmPayload
        }

        dismiss(animated: false) {
            self.messageUIDelegate?.action(action, from: controller)
        }
    }

    func onError(_ error: SPError) {
        messageUIDelegate?.onError(error)
    }

    func finished(_ vcFinished: SPMessageViewController) {}
}

// MARK: UITableViewDataSource
extension SPNativePrivacyManagerViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SPNativePrivacyManagerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        loadLabelText(
            forComponentId: "CategoriesDescriptionText",
            labelText: categories[indexPath.row].description,
            label: selectedCategoryTextLabel
        )
        return true
    }

    func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
        if context.nextFocusedIndexPath == nil {
            loadLabelText(
                forComponentId: "CategoriesDescriptionText",
                labelText: "",
                label: selectedCategoryTextLabel
            )
        }
        return true
    }
}
