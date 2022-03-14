//
//  SPPrivacyPolicyViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Vilas on 03/05/21.
//

import UIKit
import Foundation

@objcMembers class SPPrivacyPolicyViewController: SPNativeScreenViewController {
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var closeButton: SPAppleTVButton
    !
    @IBOutlet weak var header: SPPMHeader!

    func setHeader () {
        header.spBackButton = viewData.byId("BackButton") as? SPNativeButton
        header.spTitleText = viewData.byId("Header") as? SPNativeText
        header.onBackButtonTapped = { [weak self] in self?.dismiss(animated: true) }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setHeader()
        loadTextView(forComponentId: "Body", textView: descriptionTextView)
        loadButton(forComponentId: "CloseButton", button: closeButton)
        loadImage(forComponentId: "LogoImage", imageView: logoImageView)
    }

    @IBAction func onCloseTap(_ sender: Any) {
        dismiss(animated: true)
    }
}
