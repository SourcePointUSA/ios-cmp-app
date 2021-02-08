//
//  ViewController.swift
//  Example
//
//  Created by Andre Herculano on 15.05.19.
//  Copyright © 2019 sourcepoint. All rights reserved.
//

import UIKit
import AppTrackingTransparency
import AdSupport
import ConsentViewController

func afterFakeDelay (execute: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: execute)
}

@objc protocol SPCCPA {
    @objc func loadCCPAPrivacyManager()
    @objc func ccpaApplies() -> Bool
}

@objc protocol SPGDPR {
    @objc func loadGDPRPrivacyManager()
    @objc func gdprApplies() -> Bool
}

@objc protocol SPSDK: SPGDPR, SPCCPA {
    @objc func loadMessage(forAuthId authId: String?)
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

@objc protocol SPConsents {
    var uuid: UUID { get }
    var meta: String { get }
    var idfaStatus: SPIDFAStatus { get }
}

/// TODO: Don't forget to set the NSUserTrackingUsageDescription on the apps Info.plist otherwise we can't request access to IDFA
@objc enum SPIDFAStatus: Int, Codable, CaseIterable, CustomStringConvertible {
    case unknown = 0
    case accepted = 1
    case denied = 2
    case unavailable = 3

    public var description: String {
        switch self {
        case .unknown: return "unknown"
        case .accepted: return "accepted"
        case .denied: return "denied"
        case .unavailable: return "unavailable"
        }
    }

    @available(iOS 14, *)
    init(fromApple status: ATTrackingManager.AuthorizationStatus) {
        switch status {
        case .authorized:
            self = .accepted
        case .denied, .restricted:
            self = .denied
        case .notDetermined:
            self = .unknown
        @unknown default:
            self = .unknown
        }
    }
}

@objc enum SPActionType: Int, Codable, CaseIterable, CustomStringConvertible {
    case SaveAndExit = 1
    case PMCancel = 2
    case AcceptAll = 11
    case ShowPrivacyManager = 12
    case RejectAll = 13
    case Dismiss = 15
    /// TODO: confirm with Mike we'll have a special action type for the IDFA
    /// TODO: will the rendering app support preloading IDFA message?
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
        case .IDFAOk: return "IDFAOk"
        default: return "Unknown"
        }
    }
}

@objcMembers class SPConsentAction: NSObject {
    let type: SPActionType

    init(type: SPActionType) {
        self.type = type
    }
}

@objcMembers class SPGDPRConsents: NSObject, SPConsents {
    let uuid: UUID
    let meta: String
    let idfaStatus: SPIDFAStatus

    init(uuid: UUID, meta: String, idfaStatus: SPIDFAStatus) {
        self.uuid = uuid
        self.meta = meta
        self.idfaStatus = idfaStatus
    }
}

@objcMembers class SPCCPAConsents: NSObject, SPConsents {
    let uuid: UUID
    let meta: String
    let idfaStatus: SPIDFAStatus

    init(uuid: UUID, meta: String, idfaStatus: SPIDFAStatus) {
        self.uuid = uuid
        self.meta = meta
        self.idfaStatus = idfaStatus
    }
}

@objcMembers class SPConsentViewController: UIViewController, SPRenderingApp {
    class ActionButton: UIButton {
        var action: SPActionType!
    }
    weak var consentUIDelegate: (SPConsentUIDelegate & SPRenderingAppDelegate)?
    var contents: [String: String] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let title = UILabel(frame: CGRect(x: 0, y: 50, width: view.frame.width, height: 60))
        title.font = UIFont(name: "Arial", size: 60.0)
        title.text = contents["Title"]
        title.adjustsFontSizeToFitWidth = true
        view.addSubview(title)

        if contents["AcceptAllLabel"] != nil {
            let button = ActionButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
            button.center = view.center
            button.backgroundColor = .systemBlue
            button.setTitle(contents["AcceptAllLabel"], for: .normal)
            button.action = .AcceptAll
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            view.addSubview(button)
        }

        if contents["IDFAOkLabel"] != nil {
            let button = ActionButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
            button.center = view.center
            button.backgroundColor = .systemBlue
            button.setTitle(contents["IDFAOkLabel"], for: .normal)
            button.action = .IDFAOk
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            view.addSubview(button)
        }
    }

    @objc func buttonAction(sender: UIButton!) {
        let action = (sender as? ActionButton)?.action
        onEvent(["action": String(action?.rawValue ?? 0)])
    }

    func loadMessage(_ contents: [String : String]) {
        self.contents = contents
        consentUIDelegate?.loaded()
    }

    func onEvent(_ payload: [String: String]) {
        let action  = SPActionType.init(rawValue: Int(payload["action"]!) ?? 0) ?? .Unknown
        consentUIDelegate?.onAction(SPConsentAction(type: action))
    }
}

/// TODO: understand if the different types of Campaigns can be generalised into the same data structure
/// E.g. do they all have the same attributes?
@objcMembers class SPCampaign {
    let accountId, propertyId: Int
    let propertyName: String
    let environment: SPCampaignEnv
    let targetingParams: SPTargetingParams

    init(
        accountId: Int,
        propertyId: Int,
        propertyName: String,
        environment: SPCampaignEnv = .Public,
        targetingParams: SPTargetingParams = [:]
    ) {
        self.accountId = accountId
        self.propertyId = propertyId
        self.propertyName = propertyName
        self.environment = environment
        self.targetingParams = targetingParams
    }
}

@objcMembers class SPCampaigns {
    let gdpr, ccpa: SPCampaign?
//    let adblock, idfaPrompt: SPCampaign?

    init(gdpr: SPCampaign? = nil, ccpa: SPCampaign? = nil) {
        self.gdpr = gdpr
        self.ccpa = ccpa
    }
}

@objcMembers class SPConsentManager: SPSDK {
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
                                    "Title": "Fake IDFA Message",
                                    "IDFAOkLabel": "That's Ok"
            ])
        }
        // 2b. otherwise call onConsentReady
        // 3. store data
    }

    func loadGDPRPrivacyManager() {
        loadPrivacyManager()
    }

    func loadCCPAPrivacyManager() {
        loadPrivacyManager()
    }

    func gdprApplies() -> Bool{
        false
    }

    func ccpaApplies() -> Bool{
        false
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

    func report(action: SPConsentAction, completionHandler: @escaping (Result<SPGDPRConsents, Error>) -> Void) {
        // send consent action
        // we will need to know what legislation that action is referring to
        // in oder to send to the right endpoint and call the appropriate consentReady delegate
        afterFakeDelay {
            completionHandler(.success(SPGDPRConsents(
                uuid: UUID(),
                meta: "{}",
                idfaStatus: .accepted
            )))
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

/// TODO: What happens if the developers decide to call `AcceptAll` regardless of user action?
extension SPConsentManager: SPConsentUIDelegate {
    func onAction(_ action: SPConsentAction) {
        print("onAction(\(action.type))")
        self.delegate?.onAction(action)
        switch action.type {
        case .AcceptAll, .RejectAll, .SaveAndExit:
            self.report(action: action) { result in
                switch result {
                case .success(let consents):
                    self.delegate?.onConsentReady?(consents: consents)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case .IDFAOk:
            var idfaStatus: SPIDFAStatus = .unavailable
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    idfaStatus = SPIDFAStatus(fromApple: status)
                }
            }
            print(idfaStatus)

            self.report(action: action) { result in
                switch result {
                case .success(let consents):
                    /// TODO: load consent message after IDFA action response ?????
                    self.delegate?.onConsentReady?(consents: consents)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        default:
            print("")
        }
    }
}

class ViewController: UIViewController, SPDelegate {
    @IBOutlet weak var vendorXStatusLabel: UILabel!
    @IBAction func onClearConsentTap(_ sender: Any) {}

    @IBAction func onCCPASettingsTap(_ sender: Any) {
        consentManager.loadCCPAPrivacyManager()
    }

    @IBAction func onGDPRSettingsTap(_ sender: Any) {
        consentManager.loadGDPRPrivacyManager()
    }

    @IBAction func onAcceptVendorXTap(_ sender: Any) {}

    lazy var consentManager: SPConsentManager = { SPConsentManager(campaigns: SPCampaigns(
        gdpr: SPCampaign(
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
