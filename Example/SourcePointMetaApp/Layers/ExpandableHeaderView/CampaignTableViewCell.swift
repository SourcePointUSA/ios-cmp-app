//
//  CampaignTableViewCell.swift
//  TableViewPOC
//
//  Created by Vilas on 13/05/21.
//

import UIKit

protocol CampaignTableViewCellDelegate: AnyObject {
    func updateCampaign(sender: CampaignTableViewCell)
    func addCampaignDetails(sender: CampaignTableViewCell)
}

class CampaignTableViewCell: SourcePointUItablewViewCell {

    @IBOutlet weak var campaignSwitchOutlet: UISwitch!

    @IBOutlet weak var pmIDLabel: UILabel!
    
    @IBOutlet weak var pmTabLabel: UILabel!

    @IBOutlet weak var targetingParamKeyTextfield: UITextField!

    @IBOutlet weak var targetingParamValueTextField: UITextField!

    /** UITextField outlet for GDPR Privacy Manager textField.
        */
    @IBOutlet weak var privacyManagerTextField: UITextField!

    @IBOutlet weak var pmTabTextField: UITextField!

    @IBOutlet weak var pmTabButton: UIButton!
    @IBOutlet weak var targetingParamTopConstraint: NSLayoutConstraint!
    
    weak var delegate: CampaignTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    @IBAction func onTapCampaignSwitch(_ sender: Any) {
        delegate?.updateCampaign(sender: self)
    }
    
    @IBAction func onTapAddButton(_ sender: Any) {
        delegate?.addCampaignDetails(sender: self)
    }
}
