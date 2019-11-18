//
//  HomeViewController.swift
//  AuthExample
//
//  Created by Andre Herculano on 19.06.19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import ConsentViewController

class HomeViewController: UIViewController, UITableViewDataSource, ConsentDelegate {
    var authId = ""
    var consentUUID: String?

    @IBOutlet var authIdLabel: UILabel!
    @IBOutlet var consentTableView: UITableView!
    
    let tableSections = ["userData", "consents"]
    var userData: [String] = []
    var consents:[Consent] = []

    func loadConsents(forAuthId authId: String, showPM: Bool) {
        let cvc = try! ConsentViewController(accountId: 22, propertyId: 2372, property: "mobile.demo", PMId: "5c0e81b7d74b3c30c6852301", campaign: "stage", showPM: showPM, consentDelegate: self)
        cvc.loadMessage(forAuthId: authId)
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
        print(error)
        self.dismiss(animated: false, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        authIdLabel.text = authId
        initData()
        loadConsents(forAuthId: authId, showPM: false)
    }

    @IBAction func onSettingsPress(_ sender: Any) {
        initData()
        loadConsents(forAuthId: authId, showPM: true)
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

    func initData() {
        self.userData = [
            "consentUUID: loading...",
            "euconsent: loading..."
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
            cell.textLabel?.font = UIFont.systemFont(ofSize: 10)
            cell.textLabel?.text = "\(type(of: consent)) \(consent.name)"
            break
        default:
            break
        }
        return cell
    }
}

