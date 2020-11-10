//
//  LoginViewController.swift
//  AuthExample
//
//  Created by Andre Herculano on 19.06.19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import ConsentViewController

class LoginViewController: UIViewController, UITextFieldDelegate, GDPRConsentDelegate {
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var consentTableView: UITableView!
    @IBOutlet weak var authIdLabel: UILabel!

    lazy var consentViewController: GDPRConsentViewController = { return GDPRConsentViewController(
        accountId: 22,
        propertyId: 7639,
        propertyName: try! GDPRPropertyName("tcfv2.mobile.webview"),
        PMId: "122058",
        campaignEnv: .Public,
        consentDelegate: self 
    )}()

    let authId = UIDevice.current.identifierForVendor?.uuidString
    
    let tableSections = ["userData", "consents"]
    var userData: [String] = []
    var consents: [String] = []

    func gdprConsentUIWillShow() {
        self.present(consentViewController, animated: true, completion: nil)
    }

    func consentUIDidDisappear() {
        self.dismiss(animated: true, completion: nil)
    }

    func onConsentReady(gdprUUID: GDPRUUID, userConsent: GDPRUserConsent) {
        self.userData = [
            "ConsentUUID: \(gdprUUID)",
            "Consent String: \(userConsent.euconsent)"
        ]
        self.consents =
            userConsent.acceptedVendors.map({ v in return "Vendor: \(v)"}) +
            userConsent.acceptedCategories.map({ c in return "Purpose: \(c)"})
        self.consentTableView.reloadData()
    }

    func onError(error: GDPRConsentViewControllerError?) {
        print(error.debugDescription)
    }

    @IBAction func onSettingsPress(_ sender: Any) {
        initData()
        consentViewController.loadPrivacyManager()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        consentViewController.loadMessage(forAuthId: authId)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let homeController = segue.destination as? HomeViewController
        homeController?.authId = authId
    }
}

extension LoginViewController: UITableViewDataSource {
    func initData() {
        loginButton.isEnabled = true
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
