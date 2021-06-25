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
    var onText: String?
    var offText: String?
    var customText: String?
    var selectable: Bool = false

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var customLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var caretLabel: UILabel!

    func loadUI() {
        label.text = labelText
        if let customText = customText {
            customLabel.isHidden = false
            customLabel.text = customText
        } else {
            customLabel.isHidden = true
        }
        caretLabel.isHidden = !selectable
        if let isOn = isOn {
            stateLabel.isHidden = false
            stateLabel.text = isOn ? onText : offText
        } else {
            stateLabel.isHidden = true
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        loadUI()
    }
}
