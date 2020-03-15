//
//  ConsentViewDetailsViewController.swift
//  SourcePointMetaApp
//
//  Created by Vilas on 6/11/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import UIKit
import ConsentViewController
import CoreData
import WebKit

class ConsentDetailsViewController: BaseViewController, WKNavigationDelegate, GDPRConsentDelegate{
    
    @IBOutlet weak var euConsentLabel: UILabel!
    @IBOutlet weak var consentUUIDLabel: UILabel!
    @IBOutlet weak var consentTableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    //// MARK: - Instance properties
    private let cellIdentifier = "ConsentCell"
    
    // Reference to the selected property managed object ID
    var propertyManagedObjectID : NSManagedObjectID?
    
    /** PM is loaded or not
     */
    var pmloadedStatus = false
    var userConsents: GDPRUserConsent?
    var gdprUUID: String = ""
    let sections = ["Vendor Consents", "Purpose Consents"]
    
    // MARK: - Initializer
    let addpropertyViewModel: AddPropertyViewModel = AddPropertyViewModel()
    var consentViewController: GDPRConsentViewController?
    var propertyDetails: PropertyDetailsModel?
    var targetingParams = [TargetingParamModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        consentTableView.tableFooterView = UIView(frame: .zero)
        self.navigationItem.hidesBackButton = true
        navigationSetup()
        setTableViewHidden()
        setconsentUUID()
        
        if let _propertyManagedObjectID = propertyManagedObjectID {
            self.showIndicator()
            fetchDataFromDatabase(propertyManagedObjectID: _propertyManagedObjectID, completionHandler: {(propertyDetails, targetingParams) in
                self.propertyDetails = propertyDetails
                self.targetingParams = targetingParams
                self.loadConsentManager(propertyDetails: propertyDetails, targetingParams: targetingParams)
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setconsentUUID()
    }
    
    func navigationSetup() {
        
        let backIcon = UIButton(frame: CGRect.zero)
        backIcon.setImage(UIImage(named: "Back"), for: UIControl.State())
        backIcon.addTarget(self, action: #selector(back), for: UIControl.Event.touchUpInside)
        let backIconBarButton : UIBarButtonItem = UIBarButtonItem(customView: backIcon)
        backIcon.sizeToFit()
        self.navigationItem.leftBarButtonItem = backIconBarButton
    }
    
    @objc func back() {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func setTableViewHidden() {
        consentTableView.isHidden = !(userConsents?.acceptedVendors.count ?? 0 > 0 || userConsents?.acceptedCategories.count ?? 0 > 0)
        noDataLabel.isHidden = userConsents?.acceptedVendors.count ?? 0 > 0 || userConsents?.acceptedCategories.count ?? 0 > 0
    }
    
    func setconsentUUID() {
        if gdprUUID.count > 0 {
            consentUUIDLabel.text = gdprUUID
            euConsentLabel.text = userConsents?.euconsent.consentString
        }else {
            consentUUIDLabel.text = SPLiteral.consentUUID
            euConsentLabel.text = SPLiteral.euConsentID
        }
    }
    
    func fetchDataFromDatabase(propertyManagedObjectID : NSManagedObjectID, completionHandler: @escaping (PropertyDetailsModel, [TargetingParamModel]) -> Void)  {
        self.addpropertyViewModel.fetch(property: propertyManagedObjectID, completionHandler: {( propertyDataModel) in
            let propertyDetail = PropertyDetailsModel(accountId: propertyDataModel.accountId, propertyId: propertyDataModel.propertyId, propertyName: propertyDataModel.propertyName, campaign: propertyDataModel.campaign, privacyManagerId: propertyDataModel.privacyManagerId,creationTimestamp: propertyDataModel.creationTimestamp! ,authId: propertyDataModel.authId)
            var targetingParamsArray = [TargetingParamModel]()
            if let targetingParams = propertyDataModel.manyTargetingParams?.allObjects as! [TargetingParams]? {
                for targetingParam in targetingParams {
                    let targetingParamModel = TargetingParamModel(targetingParamKey: targetingParam.key, targetingParamValue: targetingParam.value)
                    targetingParamsArray.append(targetingParamModel)
                }
            }
            completionHandler(propertyDetail, targetingParamsArray)
        })
    }
    
    func loadConsentManager(propertyDetails : PropertyDetailsModel, targetingParams:[TargetingParamModel]) {
        let campaign: GDPRCampaignEnv = propertyDetails.campaign == 0 ? .Stage : .Public
        // optional, set custom targeting parameters supports Strings and Integers
        var targetingParameters = [String:String]()
        for targetingParam in targetingParams {
            targetingParameters[targetingParam.targetingKey!] = targetingParam.targetingValue
        }
        consentViewController = GDPRConsentViewController (accountId: Int(propertyDetails.accountId), propertyId: Int(propertyDetails.propertyId), propertyName: try! GDPRPropertyName(propertyDetails.propertyName!), PMId: propertyDetails.privacyManagerId!, campaignEnv: campaign,targetingParams: targetingParameters, consentDelegate: self)
        if let authId = propertyDetails.authId {
            consentViewController?.loadMessage(forAuthId: authId)
        }else {
            consentViewController?.loadMessage()
        }
    }
    
    func consentUIWillShow() {
           hideIndicator()
           present(self.consentViewController!, animated: true, completion: nil)
       }
       
       func consentUIDidDisappear() {
           dismiss(animated: true, completion: nil)
       }
       
    func onConsentReady(gdprUUID: GDPRUUID, userConsent: GDPRUserConsent) {
        self.showIndicator()
        self.userConsents = userConsent
        self.gdprUUID = gdprUUID
        setconsentUUID()
        consentTableView.reloadData()
        self.hideIndicator()
    }
       
    func onError(error: GDPRConsentViewControllerError?) {
        let okHandler = {
            self.hideIndicator()
            self.dismiss(animated: false, completion: nil)
        }
        AlertView.sharedInstance.showAlertView(title: Alert.message, message: error?.description ?? "Something Went Wrong", actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
    }
    
    @IBAction func showPMAction(_ sender: Any) {
           self.showIndicator()
           let campaign: GDPRCampaignEnv = self.propertyDetails?.campaign == 0 ? .Stage : .Public
           // optional, set custom targeting parameters supports Strings and Integers
           var targetingParameters = [String:String]()
           for targetingParam in targetingParams {
               targetingParameters[targetingParam.targetingKey!] = targetingParam.targetingValue
           }
           consentViewController =  GDPRConsentViewController(accountId: Int(propertyDetails!.accountId), propertyId: Int(propertyDetails!.propertyId), propertyName: try! GDPRPropertyName((propertyDetails?.propertyName)!), PMId: (propertyDetails?.privacyManagerId)!, campaignEnv: campaign,targetingParams: targetingParameters, consentDelegate: self)
           consentViewController?.loadPrivacyManager()
       }
}

//// MARK: UITableViewDataSource
extension ConsentDetailsViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = #colorLiteral(red: 0.2841853499, green: 0.822665453, blue: 0.653732717, alpha: 1)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        setTableViewHidden()
        if section == 0 {
            return userConsents?.acceptedVendors.count ?? 0
        }else {
            return userConsents?.acceptedCategories.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConsentTableViewCell {
            if indexPath.section == 0 {
                cell.consentIDString.text = userConsents?.acceptedVendors[indexPath.row]
            } else {
                cell.consentIDString.text = userConsents?.acceptedCategories[indexPath.row]
            }
            return cell
        }
        return UITableViewCell()
    }
}

//// MARK: - UITableViewDelegate
extension ConsentDetailsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        consentTableView.deselectRow(at: indexPath, animated: false)
    }
}
