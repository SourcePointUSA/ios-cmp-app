//
//  SPNativeMessageViewController.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 25.01.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

@objcMembers open class SPNativeMessageViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var showOptionsButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!

    var shouldCallUIDisappearOnDelegate = true // swiftlint:disable:this weak_delegate

    @IBAction func onShowOptionsTap(_ sender: Any) {
        showPrivacyManager()
        action(.ShowPrivacyManager)
    }
    @IBAction func onRejectTap(_ sender: Any) {
        action(.RejectAll)
    }
    @IBAction func onAcceptTap(_ sender: Any) {
        action(.AcceptAll)
    }

    let message: GDPRMessage
    let consentViewController: GDPRMessageUIDelegate

    public init(messageContents: GDPRMessage, consentViewController: GDPRMessageUIDelegate) {
        message = messageContents
        self.consentViewController = consentViewController
        super.init(nibName: "SPNativeMessageViewController", bundle: Bundle.framework)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func loadOrHideActionButton(actionType: SPActionType, button: UIButton) {
        if let action =  message.actions.first(where: { message in message.choiceType == actionType }) {
            button.titleLabel?.text = action.text
            button.setTitleColor(hexStringToUIColor(hex: action.style.color), for: .normal)
            button.backgroundColor = hexStringToUIColor(hex: action.style.backgroundColor)
            button.titleLabel?.font = UIFont(
                name: action.style.fontFamily,
                size: (CGFloat)(action.style.fontSize)
            )
        } else {
            button.isHidden = true
        }
    }

    func loadTitle(forAttribute attr: MessageAttribute, label: UILabel) {
        label.text = attr.text
        label.textColor = hexStringToUIColor(hex: attr.style.color)
        label.backgroundColor = hexStringToUIColor(hex: attr.style.backgroundColor)
        label.font = UIFont(
            name: attr.style.fontFamily,
            size: (CGFloat)(attr.style.fontSize)
        )
    }

    func loadBody(forAttribute attr: MessageAttribute, textView: UITextView) {
        textView.text = attr.text
        textView.textColor = hexStringToUIColor(hex: attr.style.color)
        textView.backgroundColor = hexStringToUIColor(hex: attr.style.backgroundColor)
        textView.font = UIFont(
            name: attr.style.fontFamily,
            size: (CGFloat)(attr.style.fontSize)
        )
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        loadTitle(forAttribute: message.title, label: titleLabel)
        loadBody(forAttribute: message.body, textView: descriptionTextView)
        loadOrHideActionButton(actionType: .AcceptAll, button: acceptButton)
        loadOrHideActionButton(actionType: .RejectAll, button: rejectButton)
        loadOrHideActionButton(actionType: .ShowPrivacyManager, button: showOptionsButton)
    }

    func action(_ action: SPActionType) {
        if let messageAction = message.actions.first(where: { message in message.choiceType == action }) {
            let action = SPAction(type: messageAction.choiceType, id: String(messageAction.choiceId), consentLanguage: Locale.preferredLanguages[0].uppercased())
            consentViewController.spDelegate?.onAction(action)
        }
    }

    func showPrivacyManager() {
        consentViewController.loadPrivacyManager()
    }

    /// It transforms a Hexadecimal color string to UIColor
    /// - Parameters:
    ///   - hex: `String` in the format of `#ffffff` (Hexeximal color representation)
    ///
    /// Taken from https://stackoverflow.com/a/27203691/1244883)
    func hexStringToUIColor(hex: String) -> UIColor? {
        let colorString = String(hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased().dropFirst())

        if colorString.count != 6 { return nil }

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
