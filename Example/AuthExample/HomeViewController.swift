//
//  HomeViewController.swift
//  AuthExample
//
//  Created by Andre Herculano on 19.06.19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import ConsentViewController

class HomeViewController: UIViewController, ConsentDelegate {
    lazy var consentViewController = {
        return ConsentViewController(accountId: 22, propertyId: 2372, property: "mobile.demo", PMId: "5c0e81b7d74b3c30c6852301", campaign: "stage", consentDelegate: self)
    }()

    var authId = ""
    var consentUUID: String?

    @IBOutlet var authIdLabel: UILabel!
    @IBOutlet var consentTableView: UITableView!
    
    let tableSections = ["userData", "consents"]
    var userData: [String] = []
    var consents:[Consent] = []

    
    func consentUIWillShow() {
        self.present(consentViewController, animated: true, completion: nil)
    }
    
    func consentUIDidDisappear() {
        self.dismiss(animated: true, completion: nil)
    }

    func onConsentReady(consentUUID: UUID, consents: [Consent], consentString: ConsentString?) {
        self.userData = [
            "consentUUID: \(consentUUID.uuidString)",
            "euconsent: \(consentString?.consentString ?? "<unknown>")"
        ]
        self.consents = consents
        self.consentTableView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }

    func onErrorOccurred(error: ConsentViewControllerError) {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        authIdLabel.text = authId
        initData()
        consentViewController.loadMessage() // TODO: implement authID
    }

    @IBAction func onSettingsPress(_ sender: Any) {
        initData()
        consentViewController.loadPrivacyManager() // TODO: implement authID
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

