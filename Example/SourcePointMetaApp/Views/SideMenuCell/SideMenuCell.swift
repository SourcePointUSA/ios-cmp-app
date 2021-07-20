//
//  SideMenuCell.swift
//  SourcePointMetaApp
//
//  Created by Vilas on 28/06/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        titleLabel.textColor = .white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
