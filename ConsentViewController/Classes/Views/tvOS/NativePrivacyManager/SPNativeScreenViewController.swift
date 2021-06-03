//
//  SPNativeScreenViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Andre Herculano on 25.05.21.
//

import Foundation
import UIKit

@objcMembers class SPNativeScreenViewController: SPMessageViewController {
    var components: [PMUIComponents] { viewData.components }
    let viewData: SPPrivacyManager

    init(messageId: Int?, campaignType: SPCampaignType, contents: SPPrivacyManager, delegate: SPMessageUIDelegate?, nibName: String? = nil) {
        viewData = contents
        super.init(
            messageId: messageId,
            campaignType: campaignType, timeout: 20,
            delegate: delegate
        )
        modalPresentationStyle = .currentContext
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hexString: viewData.style.backgroundColor)
        self.view.tintColor = UIColor(hexString: viewData.style.backgroundColor)
    }

    func loadButton(forComponentId id: String, button: UIButton) {
        if let action =  components.first(where: { $0.id == id }) {
            button.isHidden = false
            button.titleLabel?.text = action.text
            button.setTitleColor(UIColor(hexString: action.style?.onUnfocusTextColor), for: .normal)
            button.setTitleColor(UIColor(hexString: action.style?.onFocusTextColor), for: .focused)
            button.backgroundColor = UIColor(hexString: action.style?.onUnfocusBackgroundColor)
            if let fontFamily = action.style?.font?.fontFamily,
               let fontsize = action.style?.font?.fontSize {
                button.titleLabel?.font = UIFont(name: fontFamily, size: fontsize)
            }
        }
    }

    func loadLabelView(forComponentId id: String, label: UILabel) {
        if let textDetails = components.first(where: { $0.id == id }) {
            label.text = textDetails.text
            label.textColor = UIColor(hexString: textDetails.style?.font?.color)
            if let fontFamily = textDetails.style?.font?.fontFamily,
               let fontsize = textDetails.style?.font?.fontSize {
                label.font = UIFont(name: fontFamily, size: fontsize)
            }
        }
    }

    func loadLabelText(forComponentId id: String, labelText text: String, label: UILabel) {
        if let textDetails = components.first(where: { $0.id == id }) {
            label.text = text
            label.textColor = UIColor(hexString: textDetails.style?.font?.color)
            if let fontFamily = textDetails.style?.font?.fontFamily,
               let fontsize = textDetails.style?.font?.fontSize {
                label.font = UIFont(name: fontFamily, size: fontsize)
            }
        }
    }

    func loadTextView(forComponentId id: String, textView: UITextView) {
        if let textViewComponent = components.first(where: { $0.id == id }) {
            textView.text = textViewComponent.text
            textView.textColor = UIColor(hexString: textViewComponent.style?.font?.color)
            if let fontFamily = textViewComponent.style?.font?.fontFamily,
               let fontsize = textViewComponent.style?.font?.fontSize {
                textView.font = UIFont(name: fontFamily, size: fontsize)
            }
        }
    }

    func loadSliderButton(forComponentId id: String, slider: UISegmentedControl) {
        if let sliderDetails =  components.first(where: { $0.id == id }) {
            slider.setTitle(sliderDetails.sliderDetails?.consentText, forSegmentAt: 0)
            slider.setTitle(sliderDetails.sliderDetails?.legitInterestText, forSegmentAt: 1)
            slider.backgroundColor = UIColor(hexString: sliderDetails.style?.backgroundColor)
            if let fontFamily = sliderDetails.style?.font?.fontFamily,
               let fontsize = sliderDetails.style?.font?.fontSize {
                let font = UIFont(name: fontFamily, size: fontsize)
                slider.setTitleTextAttributes(
                    [
                        NSAttributedString.Key.font: font ?? "",
                        NSAttributedString.Key.foregroundColor: UIColor(hexString: sliderDetails.style?.font?.color) as Any
                    ], for: .normal)
                slider.setTitleTextAttributes(
                    [
                        NSAttributedString.Key.font: font ?? "",
                        NSAttributedString.Key.foregroundColor: UIColor(hexString: sliderDetails.style?.activeFont?.color) as Any
                    ], for: .selected)
            }
        }
    }
}
