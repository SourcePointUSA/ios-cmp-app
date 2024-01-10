//
//  SPPrivacyPolicyViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Vilas on 03/05/21.
//

import Foundation
import UIKit

@objcMembers class SPCustomViewController: SPNativeScreenViewController {
    @IBOutlet var descriptionTextView: SPFocusableTextView!
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var closeButton: SPAppleTVButton!
    @IBOutlet var header: SPPMHeader!

    override public func viewDidLoad() {
        super.viewDidLoad()
        setHeader()
        loadTextView(forComponentId: "Body", textView: descriptionTextView, bounces: false)
        descriptionTextView.flashScrollIndicators()
        loadButton(forComponentId: "CloseButton", button: closeButton)
        loadImage(forComponentId: "LogoImage", imageView: logoImageView)
        addFocusGuide(from: header, to: descriptionTextView, direction: .rightLeft)
    }

    @IBAction func onCloseTap(_ sender: Any) {
        dismiss(animated: true)
    }

    func setHeader () {
        loadButton(forComponentId: "BackButton", button: header.backButton)
        header.spTitleText = viewData.byId("Header") as? SPNativeText
        header.onBackButtonTapped = { [weak self] in self?.dismiss(animated: true) }
    }
}
