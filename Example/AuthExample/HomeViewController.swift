//
//  HomeViewController.swift
//  AuthExample
//
//  Created by Andre Herculano on 19.06.19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import ConsentViewController

class HomeViewController: UIViewController, GDPRConsentDelegate {
    lazy var consentViewController: GDPRConsentViewController = { return GDPRConsentViewController(
        accountId: 22,
        propertyId: 7094,
        propertyName: try! GDPRPropertyName("tcfv2.mobile.demo"),
        PMId: "100699",
        campaignEnv: .Public,
        consentDelegate: self
    )}()

    var authId = ""

    @IBOutlet var authIdLabel: UILabel!
    @IBOutlet var consentTableView: UITableView!

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
            "gdprUUID: \(gdprUUID)",
            "consent string: \(userConsent.euconsent)"
        ]
        self.consents =
            userConsent.acceptedVendors.map({ v in return "Vendor: \(v)"}) +
            userConsent.acceptedCategories.map({ c in return "Purpose: \(c)"})
        self.consentTableView.reloadData()
    }

    func onError(error: GDPRConsentViewControllerError?) {
        print(error.debugDescription)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        authIdLabel.text = authId
        initData()
        consentViewController.loadMessage(forAuthId: authId)
    }

    @IBAction func onSettingsPress(_ sender: Any) {
        initData()
        consentViewController.loadPrivacyManager()
    }
}

extension HomeViewController: UITableViewDataSource {
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

    func initData() {
        self.userData = [
            "gdprUUID: loading...",
            "consent string: loading..."
        ]
        consentTableView.reloadData()
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
            cell.textLabel?.text = userData[indexPath.row]
            cell.textLabel?.adjustsFontSizeToFitWidth = true
            break
        case 1:
            let consent = consents[indexPath.row]
            cell.textLabel?.adjustsFontSizeToFitWidth = false
            cell.textLabel?.text = consent
            break
        default:
            break
        }
        return cell
    }
}
