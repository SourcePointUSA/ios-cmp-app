//
//  SPNativeMessageViewController.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 25.01.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import Foundation

@objcMembers public class SPNativeMessageViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var showOptionsButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!

    @IBAction func onShowOptionsTap(_ sender: Any) {
        onAction(SPAction(type: .ShowPrivacyManager, campaignType: message.campaignType), from: self)
    }
    @IBAction func onRejectTap(_ sender: Any) {
        onAction(SPAction(type: .RejectAll, campaignType: message.campaignType), from: self)
    }
    @IBAction func onAcceptTap(_ sender: Any) {
        onAction(SPAction(type: .AcceptAll, campaignType: message.campaignType), from: self)
    }

    let message: SPNativeMessage
    weak var sdkDelegate: SPSDK?
    var consentManager: SPConsentManager!

    public init(
        accountId: Int,
        propertyName: SPPropertyName,
        campaigns: SPCampaigns,
        messageContents: SPNativeMessage,
        sdkDelegate: SPSDK
    ) {
        self.sdkDelegate = sdkDelegate
        message = messageContents
        super.init(nibName: "SPNativeMessageViewController", bundle: Bundle.framework)
        modalPresentationStyle = .overFullScreen
        consentManager = SPConsentManager(
            accountId: accountId,
            propertyName: propertyName,
            campaigns: campaigns,
            delegate: self
        )
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        loadTitle(forAttribute: message.title, label: titleLabel)
        loadBody(forAttribute: message.body, textView: descriptionTextView)
        loadOrHideActionButton(actionType: .AcceptAll, button: acceptButton)
        loadOrHideActionButton(actionType: .RejectAll, button: rejectButton)
        loadOrHideActionButton(actionType: .ShowPrivacyManager, button: showOptionsButton)
    }
}

extension SPNativeMessageViewController: SPDelegate {
    public func onAction(_ action: SPAction, from controller: UIViewController) {
        switch action.type {
        case .ShowPrivacyManager:
            if let action = message.actions.first(where: {$0.choiceType == action.type}),
               let id = action.pmId {
                consentManager.loadGDPRPrivacyManager(withId: id)
            } else {
                // TODO: show error message url / pm id is empty
                return
            }
        case .PMCancel, .Dismiss: break
        default: sdkDelegate?.action(action, from: self)
        }
    }

    public func onSPUIReady(_ controller: UIViewController) {
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true)
    }

    public func onSPUIFinished(_ controller: UIViewController) {
        dismiss(animated: true)
    }

    public func onError(error: SPError) {
        print(error)
    }
}

// MARK: UI Related
extension SPNativeMessageViewController {
    func loadOrHideActionButton(actionType: SPActionType, button: UIButton) {
        if let action =  message.actions.first(where: { $0.choiceType == actionType }) {
            button.setTitle(action.text, for: .normal)
            button.setTitleColor(UIColor(hexString: action.style.color), for: .normal)
            button.backgroundColor = UIColor(hexString: action.style.backgroundColor)
            button.titleLabel?.font = UIFont(
                name: action.style.fontFamily,
                size: (CGFloat)(action.style.fontSize)
            )
        } else {
            button.isHidden = true
        }
    }

    func loadTitle(forAttribute attr: SPNativeMessage.Attribute, label: UILabel) {
        label.text = attr.text
        label.textColor = UIColor(hexString: attr.style.color)
        label.backgroundColor = UIColor(hexString: attr.style.backgroundColor)
        label.font = UIFont(
            name: attr.style.fontFamily,
            size: (CGFloat)(attr.style.fontSize)
        )
    }

    func loadBody(forAttribute attr: SPNativeMessage.Attribute, textView: UITextView) {
        textView.text = attr.text
        textView.textColor = UIColor(hexString: attr.style.color)
        textView.backgroundColor = UIColor(hexString: attr.style.backgroundColor)
        textView.font = UIFont(
            name: attr.style.fontFamily,
            size: (CGFloat)(attr.style.fontSize)
        )
    }
}
