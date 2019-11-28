//
//  TargetingparamCell.swift
//  SourcePointMetaApp
//
//  Created by Vilas on 5/23/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import UIKit

protocol TargetingParamCellDelegate: class {
    func deleteButton(sender:TargetingParamCell)
}

class TargetingParamCell: SourcePointUItablewViewCell {
    
    @IBOutlet weak var targetingParamLabel: UILabel!
    weak var delegate: TargetingParamCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func deleteTargetingparamAction(_ sender: Any) {
        delegate?.deleteButton(sender: self)
    }
}
