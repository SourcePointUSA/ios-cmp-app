//
//  LoginViewController.swift
//  AuthExample
//
//  Created by Andre Herculano on 19.06.19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import ConsentViewController

// swiftlint:disable force_try

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var sdkStatusLabel: UILabel!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var consentTableView: UITableView!

    var sdkStatus: SDKStatus = .notStarted

    var campaigns: SPCampaigns { SPCampaigns(
        gdpr: SPCampaign(),
        ccpa: SPCampaign()
    )}

    lazy var consentManager: SPSDK = { SPConsentManager(
        accountId: 22,
        propertyId: 16893,
        propertyName: try! SPPropertyName("mobile.multicampaign.demo"),
        campaigns: campaigns,
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
    
    let tableSections = ["SDK Data"]
    var sdkData: [String: String?] = [:]

    @IBAction func onSettingsPress(_ sender: Any) {
        let ac = UIAlertController(title: "Settings", message: nil, preferredStyle: .actionSheet)
        if campaigns.gdpr != nil {
            ac.addAction(UIAlertAction(title: "GDPR PM", style: .default, handler: { _ in
                self.sdkLoading()
                self.consentManager.loadGDPRPrivacyManager(withId: "488393")
            }))
        }
        if campaigns.ccpa != nil {
            ac.addAction(UIAlertAction(title: "CCPA PM", style: .default, handler: { _ in
                self.sdkLoading()
                self.consentManager.loadCCPAPrivacyManager(withId: "509688")
            }))
        }
        ac.addAction(UIAlertAction(title: "Network Calls", style: .default, handler: { _ in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "wormholy_fire"), object: nil)
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        authId = UserDefaults.standard.string(forKey: "MyAppsAuthId") ?? UUID().uuidString
        initData()
        sdkLoading()
        consentManager.loadMessage(forAuthId: authId)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let homeController = segue.destination as? HomeViewController
        homeController?.userData = consentManager.userData
    }

    func sdkLoading() {
        sdkStatus = .running
        sdkStatusLabel.text = sdkStatus.rawValue
        consentTableView.alpha = 0.3
    }

    func sdkDone(failed: Bool = false) {
        sdkStatus = failed ? .errored : .finished
        sdkStatusLabel.text = sdkStatus.rawValue
        consentTableView.reloadData()
        consentTableView.alpha = 1.0
    }
}

extension LoginViewController: SPDelegate {
    func onSPUIReady(_ controller: UIViewController) {
        present(controller, animated: true)
    }

    func onSPUIFinished(_ controller: UIViewController) {
        dismiss(animated: true)
    }

    func onAction(_ action: ConsentViewController.SPAction, from controller: UIViewController) {
        print("Action - ", action.type)
    }

    func onSPFinished(userData: SPUserData) {
        sdkData["gdpr uuid"] = userData.gdpr?.consents?.uuid
        sdkData["ccpa uuid"] = userData.ccpa?.consents?.uuid
        sdkDone()
    }

    func onError(error: SPError) {
        print(error)
        sdkDone(failed: true)
    }
}

extension LoginViewController: UITableViewDataSource {
    func initData() {
        sdkData = [
            "authId": authId
        ]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return sdkData.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        tableSections[section]
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        tableSections.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "KeyValueTableViewCell", for: indexPath) as! KeyValueTableViewCell
        switch indexPath.section {
            case 0:
                let key = sdkData.keys.sorted()[indexPath.row]
                cell.keyText = key
                cell.valueText = sdkData[key] ?? nil
                break
            default:
                break
        }
        return cell
    }
}
