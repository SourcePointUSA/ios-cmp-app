//
//  SPNativeScreenViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Andre Herculano on 25.05.21.
//

import Foundation
import UIKit

extension UIFont {
    convenience init?(from spFont: SPNativeFont?) {
        let fontSize = spFont?.fontSize ?? UIFont.preferredFont(forTextStyle: .body).pointSize
        let family = spFont?.fontFamily
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
            .first { UIFont.familyNames.map { $0.lowercased() }.contains($0) }
            ?? UIFont.systemFont(ofSize: fontSize).familyName
        self.init(name: family, size: fontSize)
    }
}

@objcMembers class SPNativeScreenViewController: SPMessageViewController {
    var components: [SPNativeUI] { viewData.components }
    let viewData: SPNativeView
    let pmData: PrivacyManagerViewData

    init(messageId: Int?, campaignType: SPCampaignType, viewData: SPNativeView, pmData: PrivacyManagerViewData, delegate: SPMessageUIDelegate?, nibName: String? = nil) {
        self.viewData = viewData
        self.pmData = pmData
        super.init(
            messageId: messageId,
            campaignType: campaignType,
            delegate: delegate
        )
        modalPresentationStyle = .currentContext
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hexString: viewData.style?.backgroundColor)
        self.view.tintColor = UIColor(hexString: viewData.style?.backgroundColor)
    }

    func loadButton(forComponentId id: String, button: UIButton) {
        if let action =  components.first(where: { $0.id == id }) as? SPNativeButton {
            button.isHidden = false
            button.titleLabel?.text = action.text
            button.setTitleColor(UIColor(hexString: action.style?.onUnfocusTextColor), for: .normal)
            button.setTitleColor(UIColor(hexString: action.style?.onFocusTextColor), for: .focused)
            button.backgroundColor = UIColor(hexString: action.style?.onUnfocusBackgroundColor)
            button.titleLabel?.font = UIFont(from: action.style?.font)
        }
    }

    func loadLabelView(forComponentId id: String, label: UILabel) {
        if let textDetails = components.first(where: { $0.id == id }) as? SPNativeText {
            label.text = textDetails.text
            label.textColor = UIColor(hexString: textDetails.style?.font?.color)
            label.font = UIFont(from: textDetails.style?.font)
        }
    }

    func loadLabelText(forComponentId id: String, labelText text: String, label: UILabel) {
        if let textDetails = components.first(where: { $0.id == id }) {
            label.text = text
            label.textColor = UIColor(hexString: textDetails.style?.font?.color)
            label.font = UIFont(from: textDetails.style?.font)
        }
    }

    func loadTextView(forComponentId id: String, textView: UITextView) {
        if let textViewComponent = components.first(where: { $0.id == id }) as? SPNativeText {
            textView.text = textViewComponent.text
            textView.textColor = UIColor(hexString: textViewComponent.style?.font?.color)
            textView.isUserInteractionEnabled = true
            textView.isScrollEnabled = true
            textView.showsVerticalScrollIndicator = true
            textView.bounces = true
            textView.panGestureRecognizer.allowedTouchTypes = [
                NSNumber(value: UITouch.TouchType.indirect.rawValue)
            ]
            textView.font = UIFont(from: textViewComponent.style?.font)
        }
    }

    func loadSliderButton(forComponentId id: String, slider: UISegmentedControl) {
        if let sliderDetails =  components.first(where: { $0.id == id }) as? SPNativeSlider {
            slider.setTitle(sliderDetails.offText, forSegmentAt: 0)
            slider.setTitle(sliderDetails.onText, forSegmentAt: 1)
            slider.backgroundColor = UIColor(hexString: sliderDetails.style?.backgroundColor)
            let font =  UIFont(from: sliderDetails.style?.font)
            let attributes = [
                NSAttributedString.Key.font: font as Any,
                NSAttributedString.Key.foregroundColor: UIColor(hexString: sliderDetails.style?.font?.color) as Any
            ]
            slider.setTitleTextAttributes(attributes, for: .normal)
            slider.setTitleTextAttributes(attributes, for: .selected)
        }
    }
}
