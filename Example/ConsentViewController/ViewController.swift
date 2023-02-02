//
//  ViewController.swift
//  Example
//
//  Created by Andre Herculano on 15.05.19.
//  Copyright © 2019 sourcepoint. All rights reserved.
//

import UIKit
import ConsentViewController

class ViewController: UIViewController {
    var sdkStatus: SDKStatus = .notStarted
    var idfaStatus: SPIDFAStatus { SPIDFAStatus.current() }
    var myVendorAccepted: VendorStatus = .Unknown
    let myVendorId = "5ff4d000a228633ac048be41"
    let myPurposesId = ["608bad95d08d3112188e0e36", "608bad95d08d3112188e0e2f"]

    @IBOutlet weak var sdkStatusLabel: UILabel!
    @IBOutlet weak var idfaStatusLabel: UILabel!
    @IBOutlet weak var myVendorAcceptedLabel: UILabel!
    @IBOutlet weak var acceptMyVendorButton: UIButton!
    @IBOutlet weak var deleteMyVendorButton: UIButton!
    @IBOutlet weak var gdprPMButton: UIButton!
    @IBOutlet weak var ccpaPMButton: UIButton!

    @IBAction func onNetworkCallsTap(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "wormholy_fire"), object: nil)
    }

    @IBAction func onClearConsentTap(_ sender: Any) {
        SPConsentManager.clearAllData()
        myVendorAccepted = .Unknown
        updateUI()
    }

    @IBAction func onGDPRPrivacyManagerTap(_ sender: Any) {
        consentManager.loadGDPRPrivacyManager(withId: "488393")
    }

    @IBAction func onCCPAPrivacyManagerTap(_ sender: Any) {
        consentManager.loadCCPAPrivacyManager(withId: "509688")
    }

    @IBAction func onAcceptMyVendorTap(_ sender: Any) {
        consentManager.customConsentGDPR(
            vendors: [myVendorId],
            categories: myPurposesId,
            legIntCategories: []) { [weak self] consents in
                self?.myVendorAccepted = VendorStatus(fromBool: consents.vendorGrants[self?.myVendorId ?? ""]?.granted)
                self?.updateUI()
        }
    }

    @IBAction func onDeleteMyVendorTap(_ sender: Any) {
        consentManager.deleteCustomConsentGDPR(
            vendors: [myVendorId],
            categories: myPurposesId,
            legIntCategories: []) { [weak self] consents in
                self?.myVendorAccepted = VendorStatus(fromBool: consents.vendorGrants[self?.myVendorId ?? ""]?.granted)
                self?.updateUI()
        }
    }

    lazy var consentManager: SPSDK = {
        let config = Config(storedWithDefaults: Config(
            accountId: 22,
            propertyId: 16893,
            propertyName: "mobile.multicampaign.demo",
            gdpr: true,
            ccpa: true,
            att: true,
            language: .BrowserDefault)
        )
        let manager = SPConsentManager(
            accountId: config.accountId,
            propertyId: config.propertyId,
            propertyName: try! SPPropertyName(config.propertyName),
            campaigns: SPCampaigns(
                gdpr: config.gdpr ? SPCampaign() : nil,
                ccpa: config.ccpa ? SPCampaign() : nil,
                ios14: config.att ? SPCampaign() : nil
            ),
            delegate: self
        )
        manager.messageLanguage = config.language
        return manager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        sdkStatus = .running
        sdkStatusLabel.accessibilityIdentifier = "sdkStatusLabel"
        myVendorAcceptedLabel.accessibilityIdentifier = "customVendorLabel"
        consentManager.loadMessage(forAuthId: nil, publisherData: ["foo": "load message"])
        updateUI()
    }
}

// MARK: - SPDelegate implementation
extension ViewController: SPDelegate {
    func onSPUIReady(_ controller: UIViewController) {
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true)
    }

    func onAction(_ action: SPAction, from controller: UIViewController) {
        action.publisherData = ["foo": "action"]
    }

    func onSPUIFinished(_ controller: UIViewController) {
        updateUI()
        dismiss(animated: true)
    }

    func onConsentReady(userData: SPUserData) {
        print("onConsentReady:", userData)
        myVendorAccepted = VendorStatus(
            fromBool: userData.gdpr?.consents?.vendorGrants[myVendorId]?.granted
        )
        updateUI()
    }

    func onSPFinished(userData: SPUserData) {
        print("SDK DONE")
        sdkStatus = .finished
        updateUI()
    }

    func onError(error: SPError) {
        print("Something went wrong: ", error)
        sdkStatus = .errored
        updateUI()
    }
}

// MARK: - UI methods
extension ViewController {
    func updateUI() {
        updateIDFAStatusLabel()
        updateMyVendorUI()
        updatePMButtons(ccpaApplies: consentManager.ccpaApplies, gdprApplies: consentManager.gdprApplies)
        updateSDKStatusLabel()
    }

    func updateIDFAStatusLabel() {
        idfaStatusLabel.text = idfaStatus.description
        switch idfaStatus {
        case .unknown: idfaStatusLabel.textColor = .systemYellow
        case .accepted: idfaStatusLabel.textColor = .systemGreen
        case .denied: idfaStatusLabel.textColor = .systemRed
        case .unavailable: idfaStatusLabel.textColor = .systemGray
        @unknown default: break
        }
    }

    func updateMyVendorUI() {
        myVendorAcceptedLabel.text = myVendorAccepted.rawValue
        switch myVendorAccepted {
            case .Unknown:
                myVendorAcceptedLabel.textColor = .systemGray
                acceptMyVendorButton.isEnabled = false
                deleteMyVendorButton.isEnabled = false
            case .Accepted:
                myVendorAcceptedLabel.textColor = .systemGreen
                acceptMyVendorButton.isEnabled = false
                deleteMyVendorButton.isEnabled = true
            case .Rejected:
                myVendorAcceptedLabel.textColor = .systemRed
                acceptMyVendorButton.isEnabled = true
                deleteMyVendorButton.isEnabled = false
        }
    }

    func updatePMButtons(ccpaApplies: Bool, gdprApplies: Bool) {
        gdprPMButton.isEnabled = gdprApplies
        ccpaPMButton.isEnabled = ccpaApplies
    }

    func updateSDKStatusLabel() {
        sdkStatusLabel.text = sdkStatus.rawValue
    }
}

enum VendorStatus: String {
    case Accepted
    case Rejected
    case Unknown

    init(fromBool bool: Bool?) {
        if bool == nil {
            self = .Unknown
        } else if bool == false {
            self = .Rejected
        } else {
            self = .Accepted
        }
    }
}

enum SDKStatus: String {
    case notStarted = "Not Started"
    case running = "Running"
    case finished = "Finished"
    case errored = "Errored"
}

struct Config: Codable {
    let accountId, propertyId: Int
    let propertyName: String
    let gdpr, ccpa, att: Bool
    let language: SPMessageLanguage

    enum Keys: String, CaseIterable {
        case accountId, propertyId, propertyName, gdpr, ccpa, att, language
    }
}

extension Config {
    init(storedWithDefaults defaults: Config) {
        let values = UserDefaults.standard.dictionaryRepresentation()
        accountId = (values["accountId"] as? NSString)?.integerValue ?? defaults.accountId
        propertyId = (values["propertyId"] as? NSString)?.integerValue ?? defaults.propertyId
        propertyName = values["propertyName"] as? String ?? defaults.propertyName
        gdpr = (values["gdpr"] as? NSString)?.boolValue ?? defaults.gdpr
        ccpa = (values["ccpa"] as? NSString)?.boolValue ?? defaults.ccpa
        att = (values["att"] as? NSString)?.boolValue ?? defaults.att
        language = SPMessageLanguage(rawValue: values["language"] as? String ?? "xx") ?? defaults.language
    }
}

