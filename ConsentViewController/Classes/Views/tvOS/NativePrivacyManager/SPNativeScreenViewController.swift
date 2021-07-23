//
//  SPNativeScreenViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Andre Herculano on 25.05.21.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

enum SPUIRectEdge {
    case bottomTop, rightLeft, topBottom, leftRight, left, right, top, bottom, all

    init(from edge: UIRectEdge) {
        switch edge {
        case .all: self = .all
        case .top: self = .top
        case .bottom: self = .bottom
        case .left: self = .left
        case .right: self = .right
        default:
            self = .all
        }
    }
}

extension UIFont {
    convenience init?(from spFont: SPNativeFont?) {
        let magicScalingFactor = CGFloat(1.8)
        let fontSize = spFont?.fontSize != nil ? spFont!.fontSize * magicScalingFactor : UIFont.preferredFont(forTextStyle: .body).pointSize
        let family = spFont?.fontFamily
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
            .first { UIFont.familyNames.map { $0.lowercased() }.contains($0) }
            ?? UIFont.systemFont(ofSize: fontSize).familyName
        self.init(name: family, size: fontSize)
    }
}

extension UIViewController {
    @discardableResult
    func addFocusGuide(from origin: UIView?, to destination: UIView?, direction: SPUIRectEdge, debug: Bool = false) -> [UIFocusGuide?] {
        switch direction {
        case .bottomTop:
            return [
                addFocusGuide(from: origin, to: [destination], direction: .bottom, debug: debug),
                addFocusGuide(from: destination, to: [origin], direction: .top, debug: debug)
            ]
        case .topBottom: return addFocusGuide(from: destination, to: origin, direction: .bottomTop, debug: debug)
        case .rightLeft:
            return [
                addFocusGuide(from: origin, to: [destination], direction: .right, debug: debug),
                addFocusGuide(from: destination, to: [origin], direction: .left, debug: debug)
            ]
        case .leftRight: return addFocusGuide(from: destination, to: origin, direction: .rightLeft, debug: debug)
        default:
            return [addFocusGuide(from: origin, to: [destination], direction: direction, debug: debug)]
        }
    }

    @discardableResult
    func addFocusGuide(from origin: UIView?, to maybeDestinations: [UIView?], direction: SPUIRectEdge, debug: Bool = false) -> UIFocusGuide? {
        if let origin = origin {
            let destinations = maybeDestinations.filter { $0 != nil }.map { $0! }
            let focusGuide = UIFocusGuide()
            view.addLayoutGuide(focusGuide)
            focusGuide.preferredFocusEnvironments = destinations
            focusGuide.widthAnchor.constraint(equalTo: origin.widthAnchor).isActive = true
            focusGuide.heightAnchor.constraint(equalTo: origin.heightAnchor).isActive = true

            switch direction {
            case .bottom:
                focusGuide.topAnchor.constraint(equalTo: origin.bottomAnchor).isActive = true
                focusGuide.leftAnchor.constraint(equalTo: origin.leftAnchor).isActive = true
            case .top:
                focusGuide.bottomAnchor.constraint(equalTo: origin.topAnchor).isActive = true
                focusGuide.leftAnchor.constraint(equalTo: origin.leftAnchor).isActive = true
            case .left:
                focusGuide.topAnchor.constraint(equalTo: origin.topAnchor).isActive = true
                focusGuide.rightAnchor.constraint(equalTo: origin.leftAnchor).isActive = true
            case .right:
                focusGuide.topAnchor.constraint(equalTo: origin.topAnchor).isActive = true
                focusGuide.leftAnchor.constraint(equalTo: origin.rightAnchor).isActive = true
            default:
                // Not supported :(
                break
            }

            if debug {
                view.addSubview(FocusGuideDebugView(focusGuide: focusGuide))
            }

            return focusGuide
        }
        return nil
    }
}

class FocusGuideDebugView: UIView {
    init(focusGuide: UIFocusGuide) {
        super.init(frame: focusGuide.layoutFrame)
        backgroundColor = UIColor.green.withAlphaComponent(0.15)
        layer.borderColor = UIColor.green.withAlphaComponent(0.3).cgColor
        layer.borderWidth = 1
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}

@objcMembers class SPNativeScreenViewController: SPMessageViewController {
    var components: [SPNativeUI] { viewData.children }
    let viewData: SPNativeView
    let pmData: PrivacyManagerViewData

    func setFocusGuides() { }

    init(messageId: Int?, campaignType: SPCampaignType, viewData: SPNativeView, pmData: PrivacyManagerViewData, delegate: SPMessageUIDelegate?, nibName: String? = nil) {
        self.viewData = viewData
        self.pmData = pmData
        super.init(
            messageId: messageId,
            campaignType: campaignType,
            timeout: 10,
            delegate: delegate
        )
        modalPresentationStyle = .currentContext
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: viewData.settings.style?.backgroundColor)
        view.tintColor = UIColor(hexString: viewData.settings.style?.backgroundColor)
        setFocusGuides()
    }

    @discardableResult
    func loadImage(forComponentId id: String, imageView: UIImageView) -> UIImageView {
        if let image = components.first(where: { $0.id == id }) as? SPNativeImage,
           let url = URL(string: image.settings.src) {
            imageView.isHidden = false
            imageView.load(url: url)
        } else {
            imageView.isHidden = true
        }
        return imageView
    }

    @discardableResult
    func loadButton(forComponentId id: String, button: UIButton) -> UIButton {
        if let action = components.first(where: { $0.id == id }) as? SPNativeButton {
            button.isHidden = false
            button.titleLabel?.text = action.settings.text
            button.setTitleColor(UIColor(hexString: action.settings.style?.onUnfocusTextColor), for: .normal)
            button.setTitleColor(UIColor(hexString: action.settings.style?.onFocusTextColor), for: .focused)
            button.backgroundColor = UIColor(hexString: action.settings.style?.onUnfocusBackgroundColor)
            button.titleLabel?.font = UIFont(from: action.settings.style?.font)
        } else {
            button.isHidden = true
        }
        return button
    }

    @discardableResult
    func loadLabelView(forComponentId id: String, label: UILabel) -> UILabel {
        if let textDetails = components.first(where: { $0.id == id }) as? SPNativeText {
            label.text = ""
            label.attributedText = textDetails.settings.text.htmlToAttributedString
            label.textColor = UIColor(hexString: textDetails.settings.style?.font?.color)
            label.font = UIFont(from: textDetails.settings.style?.font)
        }
        return label
    }

    @discardableResult
    func loadLabelText(forComponentId id: String, labelText text: String, label: UILabel) -> UILabel {
        if let textDetails = components.first(where: { $0.id == id }) as? SPNativeText {
            label.text = ""
            label.attributedText = text.htmlToAttributedString
            label.textColor = UIColor(hexString: textDetails.settings.style?.font?.color)
            label.font = UIFont(from: textDetails.settings.style?.font)
        }
        return label
    }

    @discardableResult
    func loadTextView(forComponentId id: String, textView: UITextView, text: String? = nil) -> UITextView {
        if let textViewComponent = components.first(where: { $0.id == id }) as? SPNativeText {
            if let text = text {
                textView.attributedText = text.htmlToAttributedString
            } else {
                textView.text = textViewComponent.settings.text
            }
            textView.textColor = UIColor(hexString: textViewComponent.settings.style?.font?.color)
            textView.isUserInteractionEnabled = true
            textView.isScrollEnabled = true
            textView.showsVerticalScrollIndicator = true
            textView.bounces = true
            textView.panGestureRecognizer.allowedTouchTypes = [
                NSNumber(value: UITouch.TouchType.indirect.rawValue)
            ]
            textView.font = UIFont(from: textViewComponent.settings.style?.font)
        }
        return textView
    }

    @discardableResult
    func loadSliderButton(forComponentId id: String, slider: UISegmentedControl) -> UISegmentedControl {
        if let sliderDetails = components.first(where: { $0.id == id }) as? SPNativeSlider {
            slider.setTitle(sliderDetails.settings.leftText, forSegmentAt: 0)
            slider.setTitle(sliderDetails.settings.rightText, forSegmentAt: 1)
            if let font = UIFont(from: sliderDetails.settings.style?.font),
               let fontColor = sliderDetails.settings.style?.font?.color {
                slider.setTitleTextAttributes([
                    NSAttributedString.Key.font: font as Any,
                    NSAttributedString.Key.foregroundColor: UIColor(hexString: fontColor) as Any
                ], for: .normal)
            }
            if let activeFont = UIFont(from: sliderDetails.settings.style?.activeFont),
               let activeFontColor = sliderDetails.settings.style?.activeFont?.color {
                slider.setTitleTextAttributes([
                    NSAttributedString.Key.font: activeFont as Any,
                    NSAttributedString.Key.foregroundColor: UIColor(hexString: activeFontColor) as Any
                ], for: .selected)
            }
        }

        return slider
    }
}
