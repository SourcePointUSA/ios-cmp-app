//
//  SPNativeScreenViewController.swift
//  ConsentViewController-tvOS
//
//  Created by Andre Herculano on 25.05.21.
//

import UIKit

#if SPM
@_implementationOnly import Down
#else
import Down
#endif

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.alpha = 0
                        self?.image = image
                        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
                            self?.alpha = 1.0
                        })
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
        let fontSize = spFont?.fontSize != nil ? // swiftlint:disable:next force_unwrapping
            spFont!.fontSize * magicScalingFactor :
            UIFont.preferredFont(forTextStyle: .body).pointSize
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
            let destinations = maybeDestinations.compactMap { $0 }
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
        nil
    }
}

@objcMembers class SPNativeScreenViewController: SPMessageViewController {
    var components: [SPNativeUI] { viewData.children }
    let viewData: SPNativeView
    let pmData: PrivacyManagerViewData

    init(messageId: String, campaignType: SPCampaignType, viewData: SPNativeView, pmData: PrivacyManagerViewData, delegate: SPMessageUIDelegate?, nibName: String? = nil) {
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

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: viewData.settings.style.backgroundColor)
        view.tintColor = UIColor(hexString: viewData.settings.style.backgroundColor)
        setFocusGuides()
    }

    func setFocusGuides() { }

    @discardableResult
    func loadImage(forComponentId id: String, imageView: UIImageView) -> UIImageView {
        if let image = components.first(where: { $0.id == id }) as? SPNativeImage,
           let url = image.settings.src {
            imageView.image = getImageWithColor(color: .clear)
            imageView.isHidden = false
            imageView.load(url: url)
        } else {
            imageView.isHidden = true
        }
        return imageView
    }

    @nonobjc
    @discardableResult
    func loadButton(forComponentId id: String, button: SPAppleTVButton) -> UIButton {
        if let action = components.first(where: { $0.id == id }) as? SPNativeButton {
            let style = action.settings.style
            button.isHidden = false
            button.setTitle(action.settings.text, for: .normal)
            button.setTitleColor(UIColor(hexString: style.onUnfocusTextColor), for: .normal)
            button.setTitleColor(UIColor(hexString: style.onFocusTextColor), for: .focused)
            button.backgroundColor = UIColor(hexString: style.onUnfocusBackgroundColor)
            button.onUnfocusBackgroundColor = button.backgroundColor
            button.onFocusBackgroundColor = UIColor(hexString: style.onFocusBackgroundColor)
            button.titleLabel?.font = UIFont(from: style.font)
            button.layer.cornerRadius = 12
        } else {
            button.isHidden = true
        }
        return button
    }

    @discardableResult
    func loadLabelText(forComponent component: SPNativeText, addTextForComponent addComponent: SPNativeText? = nil, labelText text: String? = nil, label: UILabel) -> UILabel {
        let style = component.settings.style
        label.text = ""
        if let text = text {
            label.attributedText = text.htmlToAttributedString
        } else {
            let addText = addComponent?.settings.text != nil ? (addComponent?.settings.text)! : ""
            label.attributedText = (component.settings.text + addText).htmlToAttributedString
        }
        label.textColor = UIColor(hexString: style.font.color)
        label.font = UIFont(from: style.font)
        return label
    }

    @discardableResult
    func loadLabelText(forComponentId id: String, labelText text: String? = nil, label: UILabel) -> UILabel {
        if let textDetails = components.first(where: { $0.id == id }) as? SPNativeText {
            loadLabelText(forComponent: textDetails, labelText: text, label: label)
        }
        return label
    }

    func parseText(_ rawText: String) -> NSAttributedString? {
        guard let markdownText = try? Down(markdownString: rawText).toAttributedString(),
              markdownText.length != 0 else {
            return rawText.htmlToAttributedString
        }
        return markdownText
    }

    @discardableResult
    func loadTextView(forComponentId id: String, textView: UITextView, text: String? = nil, bounces: Bool = true) -> UITextView {
        if let textViewComponent = components.first(where: { $0.id == id }) as? SPNativeText {
            let style = textViewComponent.settings.style
            textView.attributedText = parseText(text != nil ?
                text! : // swiftlint:disable:this force_unwrapping
                textViewComponent.settings.text
            )
            textView.textColor = UIColor(hexString: style.font.color)
            textView.isUserInteractionEnabled = true
            textView.isScrollEnabled = true
            textView.showsVerticalScrollIndicator = true
            textView.bounces = bounces
            textView.panGestureRecognizer.allowedTouchTypes = [
                NSNumber(value: UITouch.TouchType.indirect.rawValue)
            ]
            textView.font = UIFont(from: style.font)
        }
        return textView
    }

    @discardableResult
    func loadSliderButtonFromNativeTexts(firstSegmentForComponentId firstId: String, secondSegmentForComponentId secondId: String, slider: UISegmentedControl) -> UISegmentedControl {
        if let sliderDetails = components.first(where: { $0.id == firstId }) as? SPNativeText {
            slider.setTitle(sliderDetails.settings.text, forSegmentAt: 0)
            let style = sliderDetails.settings.style
            if #available(tvOS 14.0, *) {
                backgroundForV14(slider: slider, backgroundHex: style.backgroundColor, activeBackground: style.activeBackgroundColor)
            }
            loadSliderSegmentFont(style: style, slider: slider)
        }
        if let sliderDetails = components.first(where: { $0.id == secondId }) as? SPNativeText {
            slider.setTitle(sliderDetails.settings.text, forSegmentAt: 1)
        }
        return slider
    }

    @discardableResult
    func loadSliderButton(forComponentId id: String, slider: UISegmentedControl) -> UISegmentedControl {
        if let sliderDetails = components.first(where: { $0.id == id }) as? SPNativeSlider {
            slider.setTitle(sliderDetails.settings.leftText, forSegmentAt: 0)
            slider.setTitle(sliderDetails.settings.rightText, forSegmentAt: 1)
            let style = sliderDetails.settings.style
            if #available(tvOS 14.0, *) {
                backgroundForV14(slider: slider, backgroundHex: style.backgroundColor, activeBackground: style.activeBackgroundColor)
            }
            loadSliderSegmentFont(style: style, slider: slider)
        }
        return slider
    }

    func loadSliderSegmentFont(style: SPNativeStyle, slider: UISegmentedControl) {
            if let font = UIFont(from: style.font) {
                let fontColor = style.font.color
                slider.setTitleTextAttributes([
                    NSAttributedString.Key.font: font as Any,
                    NSAttributedString.Key.foregroundColor: UIColor(hexString: fontColor) as Any
                ], for: .normal)
            }
            if let activeFont = UIFont(from: style.activeFont) {
                let activeFontColor = style.activeFont.color
                slider.setTitleTextAttributes([
                    NSAttributedString.Key.font: activeFont as Any,
                    NSAttributedString.Key.foregroundColor: UIColor(hexString: activeFontColor) as Any
                ], for: .selected)
            }
        }

    func removeSliderButtonSegment(slider: UISegmentedControl, removeSegmentNum: Int) {
        slider.removeSegment(at: removeSegmentNum, animated: false)
        slider.selectedSegmentIndex = 0
    }
}

extension UILabel {
    func setDefaultTextColorForDarkMode() {
        if #available(tvOS 13.0, *) {
            if UITraitCollection.current.userInterfaceStyle == .dark {
                self.textColor = Constants.UI.DarkMode.defaultFallbackTextColorForDarkMode
            }
        }
    }
}

func getImageWithColor(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
    let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    color.setFill()
    UIRectFill(rect)
    let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
}

func backgroundForV14(slider: UISegmentedControl, backgroundHex: String?, activeBackground: String?) {
    let backgroundColor = getImageWithColor(color: UIColor(hexString: backgroundHex ?? Constants.UI.StandartStyle().backgroundColor) ?? .gray)
    let activeBackgroundColor = getImageWithColor(color: UIColor(hexString: activeBackground ?? Constants.UI.StandartStyle().activeBackgroundColor) ?? .white)
    slider.setBackgroundImage(backgroundColor, for: .normal, barMetrics: .default)
    slider.setBackgroundImage(activeBackgroundColor, for: .selected, barMetrics: .default)
    slider.layer.cornerRadius = 12
    slider.layer.masksToBounds = true
}
