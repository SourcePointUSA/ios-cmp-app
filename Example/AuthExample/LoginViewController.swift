//
//  LoginViewController.swift
//  AuthExample
//
//  Created by Andre Herculano on 19.06.19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import ConsentViewController

class LoginViewController: UIViewController, UITableViewDataSource {
    @IBOutlet var authIdField: UITextField!
    @IBOutlet var consentTableView: UITableView!

    let tableSections = ["cookies", "consents"]
    var cookies: [String] = []
    var consents:[Consent] = []

    func loadConsents(myPrivacyManager: Bool) {
        ConsentManager(viewController: self, myPrivacyManager: myPrivacyManager)
            .onConsentsReady({ controller in
                self.cookies = []
                self.consents = []
                self.cookies.append("consentUUID: \(controller.consentUUID)")
                self.cookies.append("euconsent: \(controller.euconsent)")
                controller.getCustomVendorConsents(completionHandler: { vendorConsents in
                    self.consents.append(contentsOf: vendorConsents)
                    self.consentTableView.reloadData()
                })
                controller.getCustomPurposeConsents(completionHandler: {
                    purposeConsents in self.consents.append(contentsOf: purposeConsents)
                    self.consentTableView.reloadData()
                })
                self.consentTableView.reloadData()
            })
            .loadConsents()
    }

    @IBAction func onSettingsPress(_ sender: Any) {
        initData()
        loadConsents(myPrivacyManager: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initData()
        loadConsents(myPrivacyManager: false)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is HomeViewController {
            let homeController = segue.destination as? HomeViewController
            guard let authId = authIdField.text else { return }
            authIdField.text = ""
            homeController?.authId = authId
        }
    }

    func initData() {
        self.cookies = [
            "consentUUID: loading...",
            "euconsent: loading..."
        ]
        consentTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return cookies.count
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
            cell.textLabel?.text = cookies[indexPath.row]
            break
        case 1:
            let consent = consents[indexPath.row]
            cell.textLabel?.adjustsFontSizeToFitWidth = false
            cell.textLabel?.font = UIFont.systemFont(ofSize: 8)
            cell.textLabel?.text = "\(type(of: consent)) \(consent.name)"
            break
        default:
            break
        }
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        return cell
    }
}

