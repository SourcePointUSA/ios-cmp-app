//
//  LoginViewController.swift
//  AuthExample
//
//  Created by Andre Herculano on 19.06.19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import ConsentViewController

class LoginViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate, ConsentDelegate {
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var authIdField: UITextField!
    @IBOutlet var consentTableView: UITableView!

    @IBAction func onUserNameChanged(_ sender: UITextField) {
        let userName = sender.text ?? ""
        loginButton.isEnabled = userName.trimmingCharacters(in: .whitespacesAndNewlines) != ""
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let userName = textField.text ?? ""
        if(userName.trimmingCharacters(in: .whitespacesAndNewlines) != "") {
            loginButton.sendActions(for: .touchUpInside)
            return true
        }
        return false
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func onMessageReady(controller: ConsentViewController) {
        self.present(controller, animated: false, completion: nil)
    }

    func getConsentsCompletionHandler(_ newConsents: [Consent]?, _ error: ConsentViewControllerError?) -> Void {
        guard let newConsents = newConsents else {
            onErrorOccurred(error: error!)
            return
        }
        consents.append(contentsOf: newConsents)
        self.consentTableView.reloadData()
    }

    func onConsentReady(controller: ConsentViewController) {
        self.userData = []
        self.consents = []
        self.userData.append("consentUUID: \(controller.consentUUID)")
        self.userData.append("euconsent: \(controller.euconsent)")
        controller.getCustomVendorConsents(completionHandler: getConsentsCompletionHandler)
        controller.getCustomPurposeConsents(completionHandler: getConsentsCompletionHandler)
        self.consentTableView.reloadData()
        self.dismiss(animated: false, completion: nil)
    }

    func onErrorOccurred(error: ConsentViewControllerError) {
        self.dismiss(animated: false, completion: nil)
    }

    func loadConsents(showPM: Bool) {
        let cvc = try! ConsentViewController(accountId: 22, siteId: 2372, siteName: "mobile.demo", PMId: "5c0e81b7d74b3c30c6852301", campaign: "stage", showPM: showPM, consentDelegate: self)
        cvc.loadMessage()
    }

    @IBAction func onSettingsPress(_ sender: Any) {
        initData()
        loadConsents(showPM: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initData()
        loadConsents(showPM: false)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let homeController = segue.destination as? HomeViewController
        homeController?.authId = authIdField.text!
        resetView()
    }

    func resetView() {
        authIdField.text = nil
        loginButton.isEnabled = false
    }

    // MARK: ConsentTableView related

    let tableSections = ["userData", "consents"]
    var userData: [String] = []
    var consents:[Consent] = []

    func initData() {
        self.userData = [
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
            cell.textLabel?.text = userData[indexPath.row]
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

