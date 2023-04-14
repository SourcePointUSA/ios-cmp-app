//
//  LoginViewController.swift
//  AuthExample
//
//  Created by Andre Herculano on 19.06.19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import ConsentViewController

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var consentTableView: UITableView!
    @IBOutlet weak var authIdLabel: UILabel!

    lazy var consentManager: SPSDK = { SPConsentManager(
        accountId: 22,
        propertyId: 16893,
        // swiftlint:disable:next force_try
        propertyName: try! SPPropertyName("mobile.multicampaign.demo"),
        campaigns: SPCampaigns(
            gdpr: SPCampaign(),
            ccpa: SPCampaign()
        ),
        delegate: self
    )}()

    /// Use a random generated `UUID` if you don't intend to share consent among different apps
    /// Otherwise use the `UIDevice().identifierForVendor` if you intend to share consent among
    /// different apps you control but don't have an id tha uniquely identifies a user such as email, username, etc.
    /// Make sure to persist the authId as it needs to be re-used everytime the `.loadMessage(forAuthId:` is called.
    var authId: String! {
        didSet {
            UserDefaults.standard.set(authId, forKey: "MyAppsAuthId")
        }
    }
    
    let tableSections = ["userData", "consents"]
    var userData: [String] = []
    var consents: [String] = []

    @IBAction func onSettingsPress(_ sender: Any) {
        initData()
        consentManager.loadGDPRPrivacyManager(withId: "488393")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        authId = UserDefaults.standard.string(forKey: "MyAppsAuthId") ?? UUID().uuidString
        initData()
        consentManager.loadMessage(forAuthId: authId)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let homeController = segue.destination as? HomeViewController
        homeController?.userData = consentManager.userData
    }
}

extension LoginViewController: SPDelegate {
    func onSPUIReady(_ controller: UIViewController) {
        present(controller, animated: true)
    }

    func onSPUIFinished(_ controller: UIViewController) {
        dismiss(animated: true)
    }

    func onConsentReady(userData: SPUserData) {
        self.userData = [
            "Consent String: \(userData.gdpr?.consents?.euconsent ?? "")"
        ]
        consentTableView.reloadData()
    }

    func onAction(_ action: ConsentViewController.SPAction, from controller: UIViewController) {
        print("Action - ", action.type)
    }

    func onError(error: SPError) {
        print(error)
    }
}

extension LoginViewController: UITableViewDataSource {
    func initData() {
        authIdLabel.text = authId
        userData = [
            "consentUUID: loading...",
            "euconsent: loading..."
        ]
        consentTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return userData.count
        case 1:
            return consents.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableSections[section]
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return tableSections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlainCell", for: indexPath)
        switch indexPath.section {
        case 0:
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            if indexPath.row == 1 {
                cell.textLabel?.numberOfLines = 5
            }
            cell.textLabel?.text = userData[indexPath.row]
            break
        case 1:
            let consent = consents[indexPath.row]
            cell.textLabel?.adjustsFontSizeToFitWidth = false
            cell.textLabel?.text = consent
            break
        default:
            break
        }
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        return cell
    }
}
