//
//  PropertyCell.swift
//  SourcePointMetaApp
//
//  Created by Vilas on 3/25/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import UIKit

class PropertyCell: SourcePointUItablewViewCell {

    @IBOutlet weak var propertyLabel: UILabel!
    @IBOutlet weak var targetingParamTextView: UITextView!
    @IBOutlet weak var campaignLabel: UILabel!
    @IBOutlet weak var accountIDLabel: UILabel!
    // MARK: - Instance Properties.

    /// Index of vendro item.
    var itemIndex: Int?

    // MARK: - UIView Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        //vendorLabel.text = nil
    }
}
