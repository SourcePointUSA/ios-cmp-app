//
//  TargetingparamCell.swift
//  SourcePointMetaApp
//
//  Created by Vilas on 5/23/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import UIKit

protocol CampaignListDelegate: AnyObject {
    func deleteCampaign(sender: CampaignListCell)
}

class CampaignListCell: SourcePointUItablewViewCell {

    @IBOutlet weak var campaignNameLabel: UILabel!
    @IBOutlet weak var pmIDLabel: UILabel!
    @IBOutlet weak var pmTabLabel: UILabel!
    @IBOutlet weak var targetingParamTextView: UITextView!
    @IBOutlet weak var targetingParamTopConstraint: NSLayoutConstraint!
    
    weak var delegate: CampaignListDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onTapDeleteCampaignButton(_ sender: Any) {
        delegate?.deleteCampaign(sender: self)
    }
}
