//
//  ViewController.swift
//  Example
//
//  Created by Andre Herculano on 15.05.19.
//  Copyright © 2019 sourcepoint. All rights reserved.
//

import UIKit
import ConsentViewController

func afterFakeDelay (execute: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: execute)
}

@objc protocol SPConsentUIDelegate {
    @objc func onAction(_ action: SPConsentAction)
}

@objc protocol SPConsentDelegate {
    @objc func onConsentUIReady(_ viewController: SPConsentViewController)
    @objc(onGDPRConsentReady:) optional func onConsentReady(consents: SPGDPRConsents)
    @objc(onCCPAConsentReady:) optional func onConsentReady(consents: SPCCPAConsents)
    @objc optional func onError(error: GDPRConsentViewControllerError)
}

@objc protocol SPDelegate: SPConsentUIDelegate, SPConsentDelegate {}

@objc protocol SPRenderingAppDelegate {
    func loaded()
    func finished()
}

@objc protocol SPRenderingApp {
    func loadMessage(_ contents: [String: String])
}

@objc enum SPActionType: Int, Codable, CaseIterable, CustomStringConvertible {
    case SaveAndExit = 1
    case PMCancel = 2
    case AcceptAll = 11
    case ShowPrivacyManager = 12
    case RejectAll = 13
    case Dismiss = 15
    /// TODO: confirm with Mike we'll have a special action type for the IDFA
    case IDFAOk = 98
    case Unknown = 99

    public var description: String {
        switch self {
        case .AcceptAll: return "AcceptAll"
        case .RejectAll: return "RejectAll"
        case .ShowPrivacyManager: return "ShowPrivacyManager"
        case .SaveAndExit: return "SaveAndExit"
        case .Dismiss: return "Dismiss"
        case .PMCancel: return "PMCancel"
        default: return "Unknown"
        }
    }
}

//@objc enum SPLegislation: Int, Codable, CaseIterable, CustomStringConvertible {
//    case GDPR, CCPA, Unknown
//
//    public var description: String {
//        switch self {
//        case .GDPR: return "GDPR"
//        case .CCPA: return "CCPA"
//        default: return "Unknown Legislation"
//        }
//    }
//}

@objcMembers class SPConsentAction: NSObject {
    let type: SPActionType

    init(type: SPActionType) {
        self.type = type
    }
}

@objcMembers class SPGDPRConsents: NSObject {
    override var description: String { "SPGDPRConsents()" }
}
@objcMembers class SPCCPAConsents: NSObject {
    override var description: String { "SPCCPAConsents()" }
}

@objcMembers class SPConsentViewController: UIViewController, SPRenderingApp {
    weak var consentUIDelegate: (SPConsentUIDelegate & SPRenderingAppDelegate)?
    var contents: [String: String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        let title = UILabel(frame: CGRect(x: 0, y: 50, width: view.frame.width, height: 60))
        title.font = UIFont(name: "Arial", size: 60.0)
        title.text = contents["Title"]
        title.adjustsFontSizeToFitWidth = true
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        button.center = view.center
        button.backgroundColor = .systemBlue
        button.setTitle(contents["AcceptAllLabel"], for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        view.backgroundColor = .white
        view.addSubview(title)
        view.addSubview(button)
    }

    @objc func buttonAction(sender: UIButton!) {
        onEvent(["action": "AcceptAll"])
    }

    func loadMessage(_ contents: [String : String]) {
        self.contents = contents
        consentUIDelegate?.loaded()
    }

    func onEvent(_ payload: [String: String]) {
        if payload["action"] == "AcceptAll" {
            consentUIDelegate?.onAction(SPConsentAction(type: .AcceptAll))
        }
    }
}

/// TODO: understand if the different types of Campaigns can be generalised into the same data structure
/// E.g. do they all have the same attributes?
@objcMembers class SPCampaign {
    let accountId, propertyId: Int
    let propertyName: String
    let environment: GDPRCampaignEnv
    let targetingParams: TargetingParams
//    var legislation: SPLegislation { .Unknown }

    init(
        accountId: Int,
        propertyId: Int,
        propertyName: String,
        environment: GDPRCampaignEnv = .Public,
        targetingParams: TargetingParams = [:]
    ) {
        self.accountId = accountId
        self.propertyId = propertyId
        self.propertyName = propertyName
        self.environment = environment
        self.targetingParams = targetingParams
    }
}
//
//@objcMembers class SPGDPRCampaign: SPCampaign {
//    override var legislation: SPLegislation { .GDPR }
//}
//
//@objcMembers class SPCCPACampaign: SPCampaign {
//    override var legislation: SPLegislation { .CCPA }
//}

@objcMembers class SPCampaigns {
    let gdpr, ccpa: SPCampaign?

    init(gdpr: SPCampaign? = nil, ccpa: SPCampaign? = nil) {
        self.gdpr = gdpr
        self.ccpa = ccpa
    }
}

@objcMembers class SPConsentManager {
    weak var delegate: (SPDelegate)?
    let campaigns: SPCampaigns
    var consentUI: SPConsentViewController!

    init(campaigns: SPCampaigns, delegate: SPDelegate) {
        self.delegate = delegate
        self.campaigns = campaigns
    }

    func loadMessage(forAuthId: String? = nil) {
        // 1. call the API
        // 2a. if there's a message
        afterFakeDelay { [weak self] in
            // pass a bunch of data to the view controller
            self?.consentUI = SPConsentViewController()
            self?.consentUI.consentUIDelegate = self
            self?.consentUI.loadMessage([
                                    "Title": "Fake Message",
                                    "AcceptAllLabel": "Accept All"
            ])
        }
        // 2b. otherwise call onConsentReady
        // 3. store data
    }

    func loadPrivacyManager() {
        afterFakeDelay { [weak self] in
            self?.consentUI = SPConsentViewController()
            self?.consentUI.consentUIDelegate = self
            self?.consentUI.loadMessage([
                "Title": "Fake Privacy Manager",
                "AcceptAllLabel": "Save & Exit"
            ])
        }
    }

    func report(action: SPConsentAction) {
        // send consent action
        // we will need to know what legislation that action is referring to
        // in oder to send to the right endpoint and call the appropriate consentReady delegate
        afterFakeDelay { [weak self] in
            // on result store
            // 1. store consent data in the user storage
            // 2. call onConsentReady
            self?.delegate?.onConsentReady?(consents: SPGDPRConsents())
        }
    }
}

extension SPConsentManager: SPRenderingAppDelegate {
    func loaded() {
        print("message ready")
        delegate?.onConsentUIReady(consentUI)
    }

    func finished() {

    }
}

extension SPConsentManager: SPConsentUIDelegate {
    func onAction(_ action: SPConsentAction) {
        print("onAction(\(action.type))")
        self.delegate?.onAction(action)
        self.report(action: action)
    }
}

class ViewController: UIViewController, SPDelegate {
    @IBOutlet weak var vendorXStatusLabel: UILabel!
    @IBAction func onClearConsentTap(_ sender: Any) {}
    @IBAction func onPrivacySettingsTap(_ sender: Any) {
        consentManager.loadPrivacyManager()
    }
    @IBAction func onAcceptVendorXTap(_ sender: Any) {}

    lazy var consentManager: SPConsentManager = { SPConsentManager(
        campaigns: SPCampaigns(gdpr: SPCampaign(
            accountId: 22,
            propertyId: 123,
            propertyName: "test"
        )),
        delegate: self
    )}()

    override func viewDidLoad() {
        super.viewDidLoad()
        consentManager.loadMessage()
    }

    func onConsentUIReady(_ viewController: SPConsentViewController) {
        present(viewController, animated: true)
    }

    func onAction(_ action: SPConsentAction) {
        dismiss(animated: true)
    }

    func onConsentReady(consents: SPGDPRConsents) {
        print("GDPR onConsentReady")
    }

    func onConsentReady(consents: SPCCPAConsents) {
        print("CCPA onConsentReady")
    }

    func onError(error: GDPRConsentViewControllerError) {
        print("Something went wrong: ", error)
    }
}
