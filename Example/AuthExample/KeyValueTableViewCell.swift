//
//  KeyValueTableViewCell.swift
//  AuthExample
//
//  Created by Andre Herculano on 27.04.23.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class KeyValueTableViewCell: UITableViewCell {
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    var keyText: String? {
        didSet {
            keyLabel.text = keyText?.uppercased()
        }
    }

    var valueText: String? {
        didSet {
            valueLabel.text = valueText?.uppercased()
        }
    }
}
