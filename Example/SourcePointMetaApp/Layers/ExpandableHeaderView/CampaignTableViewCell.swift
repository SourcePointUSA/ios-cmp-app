//
//  CampaignTableViewCell.swift
//  TableViewPOC
//
//  Created by Vilas on 13/05/21.
//

import UIKit

protocol CampaignTableViewDelegate: AnyObject {
    func addTargetingParams(sender: CampaignTableViewCell)
    func saveCampaign(sender: CampaignTableViewCell)
}

class CampaignTableViewCell: SourcePointUItablewViewCell, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

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

    var pmTabPickerView = UIPickerView()
    let addpropertyViewModel: AddPropertyViewModel = AddPropertyViewModel()
    
    weak var delegate: CampaignTableViewDelegate?

    override func awakeFromNib() {
        pmTabPickerView.delegate = self;
        pmTabPickerView.dataSource = self;
        let toolBar = UIToolbar(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: frame.width, height: CGFloat(44))))
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(selectPMTab))
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        pmTabTextField.inputAccessoryView = toolBar
        super.awakeFromNib()
        pmTabTextField.inputView = pmTabPickerView
        pmTabTextField.text = addpropertyViewModel.pmTabs[0]
    }

    @objc func selectPMTab() {
        pmTabTextField.resignFirstResponder()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func onTapAddTargetingParamButton(_ sender: Any) {
        delegate?.addTargetingParams(sender: self)
    }

    @IBAction func onTapSaveCampaignButton(_ sender: Any) {
        delegate?.saveCampaign(sender: self)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return addpropertyViewModel.pmTabs.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return addpropertyViewModel.pmTabs[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pmTabTextField.text = addpropertyViewModel.pmTabs[row]
    }
}
