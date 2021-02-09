//
//  MockSDK.swift
//  ConsentViewController_Example
//
//  Created by Andre Herculano on 08.02.21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import Foundation
import AppTrackingTransparency
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
    @objc func onConsentUIFinished()
    @objc(onGDPRConsentReady:) optional func onConsentReady(consents: SPGDPRUserConsent)
    @objc(onCCPAConsentReady:) optional func onConsentReady(consents: SPCCPAUserConsent)
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
    override var description: String { get { "Action(\(type))" } }
    let type: SPActionType

    init(type: SPActionType) {
        self.type = type
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

    func report(action: SPConsentAction, completionHandler: @escaping (Result<SPGDPRUserConsent, Error>) -> Void) {
        // send consent action
        // we will need to know what legislation that action is referring to
        // in oder to send to the right endpoint and call the appropriate consentReady delegate
        afterFakeDelay {
            completionHandler(.success(SPGDPRUserConsent.empty()))
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
    func getIdfaStatus(handler: @escaping (SPIDFAStatus) -> Void) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                handler(SPIDFAStatus(fromApple: status))
            }
        } else {
            handler(.unavailable)
        }
    }

    func onAction(_ action: SPConsentAction) {
        self.delegate?.onAction(action)
        switch action.type {
        case .AcceptAll, .RejectAll, .SaveAndExit:
            self.report(action: action) { result in
                switch result {
                case .success(let consents):
                    self.delegate?.onConsentUIFinished()
                    self.delegate?.onConsentReady?(consents: consents)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case .IDFAOk:
            getIdfaStatus { _ in
                self.delegate?.onConsentUIFinished()
                self.report(action: action) { _ in }
            }
        default:
            print("")
        }
    }
}
