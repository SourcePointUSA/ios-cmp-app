//
//  GDPRNativeMessageViewController.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 25.01.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

@objcMembers open class GDPRNativeMessageViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var showOptionsButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    var shouldCallUIDisappearOnDelegate = true
    
    @IBAction func onShowOptionsTap(_ sender: Any) {
        showPrivacyManager()
    }
    @IBAction func onRejectTap(_ sender: Any) {
        action(.RejectAll)
    }
    @IBAction func onAcceptTap(_ sender: Any) {
        action(.AcceptAll)
    }
    
    let message: GDPRMessage
    weak var consentDelegate: GDPRConsentDelegate?
    
    lazy var consentViewController = { return GDPRConsentViewController(
        accountId: 22,
        propertyId: 2372,
        propertyName: try! GDPRPropertyName("mobile.demo"),
        PMId: "5c0e81b7d74b3c30c6852301",
        campaignEnv: .Public,
        consentDelegate: self
    )}()
    
    public init(messageContents: GDPRMessage, delegate: GDPRConsentDelegate) {
        message = messageContents
        consentDelegate = delegate
        super.init(nibName: "GDPRNativeMessageViewController", bundle: Bundle.init(for: GDPRNativeMessageViewController.self))
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadOrHideActionButton(actionType: GDPRActionType, button: UIButton) {
        if let action =  message.actions.first(where: { message in message.choiceType == actionType }) {
            button.titleLabel?.text = action.text
            button.setTitleColor(hexStringToUIColor(hex: action.style.color), for: .normal)
            button.backgroundColor = hexStringToUIColor(hex: action.style.backgroundColor)
            button.titleLabel?.font = UIFont(
                name: action.style.fontFamily,
                size: pixelStringToCGFloat(pxString: action.style.fontSize) ?? 14
            )
        } else {
            button.isHidden = true
        }
    }
    
    private func loadTitle(forAttribute attr: MessageAttribute, label: UILabel) {
        label.text = attr.text
        label.textColor = hexStringToUIColor(hex: attr.style.color)
        label.backgroundColor = hexStringToUIColor(hex: attr.style.backgroundColor)
        label.font = UIFont(
            name: attr.style.fontFamily,
            size: pixelStringToCGFloat(pxString: attr.style.fontSize) ?? 14
        )
    }
    
    private func loadBody(forAttribute attr: MessageAttribute, textView: UITextView) {
        textView.text = attr.text
        textView.textColor = hexStringToUIColor(hex: attr.style.color)
        textView.backgroundColor = hexStringToUIColor(hex: attr.style.backgroundColor)
        textView.font = UIFont(
            name: attr.style.fontFamily,
            size: pixelStringToCGFloat(pxString: attr.style.fontSize) ?? 14
        )
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        loadTitle(forAttribute: message.title, label: titleLabel)
        loadBody(forAttribute: message.body, textView: descriptionTextView)
        loadOrHideActionButton(actionType: .AcceptAll, button: acceptButton)
        loadOrHideActionButton(actionType: .RejectAll, button: rejectButton)
        loadOrHideActionButton(actionType: .ShowPrivacyManager, button: showOptionsButton)
    }
    
    func action(_ action: GDPRActionType) {
        if let messageAction = message.actions.first(where: { message in message.choiceType == action }) {
            let action = GDPRAction(type: messageAction.choiceType, id: String(messageAction.choiceId))
            consentDelegate?.onAction?(action, consents: nil)
        }
        consentDelegate?.consentUIDidDisappear?()
    }
    
    func showPrivacyManager() {
        consentViewController.loadPrivacyManager()
    }
    
    private func pixelStringToCGFloat(pxString: String) -> CGFloat? {
        var stringWithoutPx = String(pxString)
        stringWithoutPx.removeLast(2)
        guard let double = Double(stringWithoutPx) else {
            return nil
        }
        return CGFloat(double)
    }

    /// It transforms a Hexadecimal color string to UIColor
    /// - Parameters:
    ///   - hex: `String` in the format of `#ffffff` (Hexeximal color representation)
    ///
    /// Taken from https://stackoverflow.com/a/27203691/1244883)
    private func hexStringToUIColor(hex: String) -> UIColor? {
        let colorString = String(hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased().dropFirst())
        
        if (colorString.count != 6) { return nil }

        var rgbValue: UInt64 = 0
        Scanner(string: colorString).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension GDPRNativeMessageViewController: GDPRConsentDelegate {
    public func consentUIWillShow() {
        present(consentViewController, animated: true, completion: nil)
    }
    
    public func consentUIDidDisappear() {
        dismiss(animated: true, completion: nil)
        if(shouldCallUIDisappearOnDelegate) {
            consentDelegate?.consentUIDidDisappear?()
        }
    }
    
    public func onConsentReady(gdprUUID: GDPRUUID, userConsent: GDPRUserConsent) {
        consentDelegate?.onConsentReady?(gdprUUID: gdprUUID, userConsent: userConsent)
    }
    
    public func onAction(_ action: GDPRAction, consents: PMConsents?) {
        // If the user taps on `Cancel` via PM we don't want to close the consent message.
        // We set the flag shouldCallUIDisappearOnDelegate to `true` in that case
        // and make sure we don't call consentDelegate.consentUIDidDisappear()
        shouldCallUIDisappearOnDelegate = action.type != .PMCancel
    }
}
