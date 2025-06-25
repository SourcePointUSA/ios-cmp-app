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
        self.contentView.layer.cornerRadius = 10
    }

    override func prepareForReuse() {
        labelText = nil
        isOn = nil
        selectable = false
        loadUI()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        loadUI()
        selectionStyle = .none
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let focused = self.isFocused
        if focused {
            self.contentView.backgroundColor = UIColor(hexString: style?.onFocusBackgroundColor)
            label.textColor = UIColor(hexString: style?.onFocusTextColor)
            customLabel.textColor = UIColor(hexString: style?.onFocusTextColor)
            stateLabel.textColor = UIColor(hexString: style?.onFocusTextColor)
        } else {
            self.contentView.backgroundColor = UIColor(hexString: style?.onUnfocusBackgroundColor)
            label.textColor = UIColor(hexString: style?.onUnfocusTextColor)
            customLabel.textColor = UIColor(hexString: style?.onUnfocusTextColor)
            stateLabel.textColor = UIColor(hexString: style?.onUnfocusTextColor)
        }
     }
}
