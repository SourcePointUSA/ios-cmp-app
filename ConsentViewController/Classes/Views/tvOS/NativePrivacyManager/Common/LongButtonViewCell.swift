//
//  LongButtonViewCell.swift
//  ConsentViewController-tvOS
//
//  Created by Andre Herculano on 25.06.21.
//

import UIKit

class LongButtonViewCell: UITableViewCell {
    var labelText: String?
    var isOn: Bool?
    var isCustom = false
    var onText: String?
    var offText: String?
    var customText: String?
    var selectable = false
    var identifier: String = ""
    var contentType: CategoryContentType?
    var style: SPNativeStyle?

    @IBOutlet var label: UILabel!
    @IBOutlet var customLabel: UILabel!
    @IBOutlet var stateLabel: UILabel!

//    override var isAccessibilityElement: Bool { set {} get { false }}
//    override var accessibilityElements: [Any]? { set {} get {[
//        label as Any,
//        customLabel as Any,
//        stateLabel as Any
//    ]}}

    func setup(from nativeCell: SPNativeLongButton?) {
        customText = isCustom ? nativeCell?.settings.customText : nil
        onText = nativeCell?.settings.onText ?? "On"
        offText = nativeCell?.settings.offText ?? "Off"
        style = nativeCell?.settings.style
        resetVisualState()
    }

    func loadUI() {
        label.text = labelText
        label.font = UIFont(from: style?.font)
        if let customText = customText {
            customLabel.isHidden = false
            customLabel.text = customText
            customLabel.font = UIFont(from: style?.font)
        } else {
            customLabel.isHidden = true
        }
        accessoryType = selectable ? .disclosureIndicator : .none
        if let isOn = isOn {
            stateLabel.isHidden = false
            stateLabel.text = isOn ? onText : offText
            stateLabel.font = UIFont(from: style?.font)
        } else {
            stateLabel.isHidden = true
        }
        accessibilityIdentifier = "\(labelText ?? "") \(stateLabel.text ?? "")"
        self.layer.cornerRadius = 10
        resetVisualState()
    }

    override func prepareForReuse() {
        labelText = nil
        isOn = nil
        selectable = false
        resetVisualState()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        resetVisualState()
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        self.focusStyle = .custom
        super.didUpdateFocus(in: context, with: coordinator)
        if context.nextFocusedView === self {
            coordinator.addCoordinatedAnimations({
                self.backgroundColor = UIColor(hexString: self.style?.onFocusBackgroundColor)
                self.tintColor = UIColor(hexString: self.style?.onFocusBackgroundColor)
                self.label.textColor = UIColor(hexString: self.style?.onFocusTextColor)
                self.customLabel.textColor = UIColor(hexString: self.style?.onFocusTextColor)
                self.stateLabel.textColor = UIColor(hexString: self.style?.onFocusTextColor)
            }, completion: nil)
        } else {
                self.backgroundColor = UIColor(hexString: self.style?.onUnfocusBackgroundColor)
                self.tintColor = UIColor(hexString: self.style?.onUnfocusBackgroundColor)
                self.label.textColor = UIColor(hexString: self.style?.onUnfocusTextColor)
                self.customLabel.textColor = UIColor(hexString: self.style?.onUnfocusTextColor)
                self.stateLabel.textColor = UIColor(hexString: self.style?.onUnfocusTextColor)
        }
    }
    
    func resetVisualState() {
        self.focusStyle = .custom
        self.backgroundColor = UIColor(hexString: self.style?.onUnfocusBackgroundColor)
        self.tintColor = UIColor(hexString: self.style?.onUnfocusBackgroundColor)
        self.label.textColor = UIColor(hexString: self.style?.onUnfocusTextColor)
        self.customLabel.textColor = UIColor(hexString: self.style?.onUnfocusTextColor)
        self.stateLabel.textColor = UIColor(hexString: self.style?.onUnfocusTextColor)
    }
}
