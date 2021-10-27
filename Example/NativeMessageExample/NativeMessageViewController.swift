//
//  NativeMessageViewController.swift
//  NativeMessageExample
//
//  Created by Andre Herculano on 25.01.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import Foundation
import ConsentViewController

@objcMembers public class NativeMessageViewController: UIViewController {
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

    /// Holds the contents of the message. Title, body, actions, etc.
    let message: SPNativeMessage

    /// Used exclusively so we can delegate the `onAction` calls back to the host application
    /// (the ViewController presenting the Native Message Controller)
    weak var sdkDelegate: SPSDK?

    /// Even though the native message only uses native components, the Privacy Manager is only available in a web form
    /// That's why we need to use the `SPConsentManager`, so we can display the PM whenever necessary
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
        super.init(nibName: "NativeMessageViewController", bundle: Bundle.main)
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

/// We made the ViewController displaying a `SPNativeMessage` implement the same `SPDelegate` as a Web message would
/// This makes it easier for the app to handle the same callback methods.
extension NativeMessageViewController: SPDelegate {
    /// This method is called whenever the user takes an action either on the NativeMessage or on the web Privacy Manager
    /// If the action.type is of `.ShowPrivacyManager` we call the appropriate load Privacy Manager method depending on
    /// the campaign type.
    /// If the action.type is of `.PMCancel` or `.Dismiss` we don't call the sdkDelegate so we can handle the action on this
    /// ViewController (by closing the PM when the `onSPUIFinished` callback is called.
    /// For all other action types we simply pass it along to the `sdkDelegate` (the View Controller presenting this one).
    public func onAction(_ action: SPAction, from controller: UIViewController) {
        switch action.type {
        case .ShowPrivacyManager:
            if let messageAction = message.actions.first(where: {$0.choiceType == action.type}),
               let id = messageAction.pmId {
                switch message.campaignType {
                    case .gdpr: consentManager.loadGDPRPrivacyManager(withId: id)
                    case .ccpa: consentManager.loadCCPAPrivacyManager(withId: id)
                    default: break
                }
            } else {
                // TODO: show error message url / pm id is empty
                return
            }
        case .PMCancel, .Dismiss: break
        default: sdkDelegate?.action(action, from: self)
        }
    }

    /// This method is called when the Privacy Manager (web) is ready to be displayed
    public func onSPUIReady(_ controller: UIViewController) {
        controller.modalPresentationStyle = .overFullScreen
        present(controller, animated: true)
    }

    /// This method is called when the Privacy Manager (web) is ready to be dismissed
    public func onSPUIFinished(_ controller: UIViewController) {
        dismiss(animated: true)
    }

    /// This method is called when something goes wrong within the `SPConsentManager`
    public func onError(error: SPError) {
        print(error)
    }
}

// MARK: UI Related
extension NativeMessageViewController {
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
