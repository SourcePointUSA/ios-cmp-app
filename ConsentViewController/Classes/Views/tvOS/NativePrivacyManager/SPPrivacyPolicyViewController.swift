//
//  SPPrivacyPolicyViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Vilas on 03/05/21.
//

import UIKit

@objcMembers class SPPrivacyPolicyViewController: SPNativeScreenViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var backButton: UIButton!

    public override func viewDidLoad() {
        super.viewDidLoad()
        loadLabelView(forComponentId: "HeaderText", label: titleLabel)
        loadTextView(forComponentId: "Body", textView: descriptionTextView)
        loadButton(forComponentId: "CloseButton", button: closeButton)
        loadButton(forComponentId: "BackButton", button: backButton)
    }

    @IBAction func onBackTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onCloseTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
