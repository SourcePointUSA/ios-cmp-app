//
//  SPMockMessageViewController.swift
//  ConsentViewController
//
//  Created by Andre Herculano on 18.02.21.
//

import Foundation

@objcMembers class SPConsentViewController: SPMessageViewController {
    class ActionButton: UIButton {
        var action: SPActionType!
        var actionId: String = ""
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let title = UILabel(frame: CGRect(x: 0, y: 50, width: view.frame.width, height: 60))
        title.font = UIFont(name: "Arial", size: 60.0)
        title.text = contents["Title"]?.stringValue
        title.adjustsFontSizeToFitWidth = true
        view.addSubview(title)

        if contents["ButtonLabel"] != nil {
            let button = ActionButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
            button.center = view.center
            button.backgroundColor = .systemBlue
            button.setTitle(contents["ButtonLabel"]?.stringValue!, for: .normal)
            button.action = SPActionType(rawValue: (contents["ChoiceType"]?.intValue!)!)
            button.actionId = String((contents["ChoiceId"]?.intValue!)!)
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            view.addSubview(button)
        }
    }

    func buttonAction(sender: UIButton!) {
        let action = (sender as? ActionButton)?.action ?? .Unknown
        let id = (sender as? ActionButton)?.actionId ?? ""
        onEvent([
            "action": String(action.rawValue),
            "id": id
        ])
    }

    override func loadMessage() {
        messageUIDelegate?.loaded(self)
    }

    override func loadMessage(_ jsonMessage: SPJson) {
        contents = jsonMessage
        messageUIDelegate?.loaded(self)
    }

    func onEvent(_ payload: [String: String]) {
        let action = SPActionType.init(rawValue: Int(payload["action"]!) ?? 0) ?? .Unknown
        let id = payload["id"]
        messageUIDelegate?.action(SPAction(type: action, id: id))
    }
}
