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

class ConsentViewDetailsViewController: BaseViewController, WKNavigationDelegate {
    
    @IBOutlet weak var euConsentLabel: UILabel!
    @IBOutlet weak var consentUUIDLabel: UILabel!
    @IBOutlet weak var consentTableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    //// MARK: - Instance properties
    private let cellIdentifier = "ConsentCell"
    
    /** consentViewController is loaded or not
     */
    var consentViewControllerStatus : Bool?
    
    /** onInteraction method is called or not
     */
    var onInteractionCompleteStatus : Bool?
    
    // Reference to the selected website managed object ID
    var websiteManagedObjectID : NSManagedObjectID?
    
    var vendorConsents = [VendorConsent]()
    var purposeConsents = [PurposeConsent]()
    let sections = ["Vendor Consents", "Purpose Consents"]
    
    // MARK: - Initializer
    let addWebsiteViewModel: AddWebsiteViewModel = AddWebsiteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        consentTableView.tableFooterView = UIView(frame: .zero)
        self.navigationItem.hidesBackButton = true
        navigationSetup()
        setTableViewHidden()
        setconsentIDFromUserDefaults()
        
//        if let _websiteManagedObjectID = websiteManagedObjectID {
//            self.showIndicator()
//            fetchDataFromDatabase(siteManagedObjectID: _websiteManagedObjectID, completionHandler: {(siteDetail, targetingParamsArray) in
//                self.buildConsentViewController(siteDetailsObject: siteDetail, targetingParamsArray: targetingParamsArray)
//            })
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setconsentIDFromUserDefaults()
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
        consentTableView.isHidden = !(vendorConsents.count > 0 || purposeConsents.count > 0)
        noDataLabel.isHidden = vendorConsents.count > 0 || purposeConsents.count > 0
    }
    
    func setconsentIDFromUserDefaults() {
        if let consentID = UserDefaults.standard.string(forKey: ConsentViewController.CONSENT_UUID_KEY),consentID.count > 0 {
        consentUUIDLabel.text = UserDefaults.standard.string(forKey: ConsentViewController.CONSENT_UUID_KEY)
        euConsentLabel.text = UserDefaults.standard.string(forKey: ConsentViewController.EU_CONSENT_KEY)
        }else {
            consentUUIDLabel.text = SPLiteral.consentUUID
            euConsentLabel.text = SPLiteral.euConsentID
        }
    }
    
//    func fetchDataFromDatabase(siteManagedObjectID : NSManagedObjectID, completionHandler: @escaping (SiteDetailsModel, [TargetingParamModel]) -> Void)  {
//        self.addWebsiteViewModel.fetch(website: siteManagedObjectID, completionHandler: {( siteDataModel) in
//            let siteDetail = SiteDetailsModel(websiteName: siteDataModel.websiteName, accountID: siteDataModel.accountID, creationTimestamp: siteDataModel.creationTimestamp, isStaging: siteDataModel.isStaging)
//            var targetingParamsArray = [TargetingParamModel]()
//            if let targetingParams = siteDataModel.manyTargetingParams?.allObjects as! [TargetingParams]? {
//                for targetingParam in targetingParams {
//                    let targetingParamModel = TargetingParamModel(targetingParamKey: targetingParam.key, targetingParamValue: targetingParam.value)
//                    targetingParamsArray.append(targetingParamModel)
//                }
//            }
//            completionHandler(siteDetail, targetingParamsArray)
//        })
//    }
    
//    func buildConsentViewController(siteDetailsObject : WebsiteDetailsModel,targetingParamsArray: [TargetingParamModel]) {
//        addWebsiteViewModel.buildConsentViewController(websiteDetails: siteDetailsObject, targetingParams: targetingParamsArray, completionHandler: { [weak self] (error, consentViewController,onInteractionCompleteStatus,vendorConsents, purposeConsents) in
//            
//            if let _error = error {
//                self?.hideIndicator()
//                let okHandler = { () -> Void in
//                    self?.navigationController?.popViewController(animated: false)
//                }
//                AlertView.sharedInstance.showAlertView(title: Alert.message, message: _error.description, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
//            } else if let _consentViewController = consentViewController {
//                self?.hideIndicator()
//                self?.consentViewControllerStatus = true
//                if let consentSubViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConsentSubViewController") as? ConsentSubViewController {
//                    consentSubViewController.consentSubViewController = _consentViewController
//                    
//                    self?.navigationController!.pushViewController(consentSubViewController, animated: true)
//                }
//            } else if onInteractionCompleteStatus != nil {
//                self?.hideIndicator()
//                self?.onInteractionCompleteStatus = onInteractionCompleteStatus
//                if self?.consentViewControllerStatus == true {
//                    if let _vendorConsents = vendorConsents {
//                        self?.vendorConsents = _vendorConsents
//                    }
//                    if let _purposeConsents = purposeConsents {
//                        self?.purposeConsents = _purposeConsents
//                    }
//                    self?.consentTableView.reloadData()
//                    
//                } else if self?.consentViewControllerStatus == nil || self?.consentViewControllerStatus == false {
//                    let showSiteInfotHandler = {
//                        if let _vendorConsents = vendorConsents {
//                            self?.vendorConsents = _vendorConsents
//                        }
//                        if let _purposeConsents = purposeConsents {
//                            self?.purposeConsents = _purposeConsents
//                        }
//                        self?.consentTableView.reloadData()
//                    }
//                    let clearCookiesHandler = {
//                        let alertController = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
//                        
//                        alertController.setValue(SPLiteral.attributedString(), forKey: "attributedTitle")
//                        let noAction = UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in
//                            if let _vendorConsents = vendorConsents {
//                                self?.vendorConsents = _vendorConsents
//                            }
//                            if let _purposeConsents = purposeConsents {
//                                self?.purposeConsents = _purposeConsents
//                            }
//                            self?.consentTableView.reloadData()
//                        })
//                        let yesAction = UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler: {(alert: UIAlertAction!) in
//                            self?.showIndicator()
//                            self?.addWebsiteViewModel.clearUserDefaultsData()
//                            self?.clearCookies()
//                            if let _websiteManagedObjectID = self?.websiteManagedObjectID {
//                                self?.showIndicator()
//                                self?.fetchDataFromDatabase(siteManagedObjectID: _websiteManagedObjectID, completionHandler: {(siteDetail, targetingParamsArray) in
//                                    self?.buildConsentViewController(siteDetailsObject: siteDetail, targetingParamsArray: targetingParamsArray)
//                                })
//                            }
//                            self?.hideIndicator()
//                        })
//                        alertController.addAction(noAction)
//                        alertController.addAction(yesAction)
//                        self?.present(alertController, animated: true, completion: nil)
//                    }
//                    
//                    AlertView.sharedInstance.showAlertView(title: Alert.message, message: Alert.messageAlreadyShown, actions: [showSiteInfotHandler, clearCookiesHandler], titles: [Alert.showSiteInfo, Alert.clearCookies], actionStyle: UIAlertController.Style.alert)
//                }
//                self?.navigationController?.popViewController(animated: false)
//            }
//        })
//    }
    
    func clearCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in records.forEach { record in
            WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
}

//// MARK: UITableViewDataSource
extension ConsentViewDetailsViewController : UITableViewDataSource {
    
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
            return vendorConsents.count
        }else {
            return purposeConsents.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConsentTableViewCell {
            if indexPath.section == 0 {
                cell.consentIDString.text = vendorConsents[indexPath.row].id
                cell.consentNameString.text = vendorConsents[indexPath.row].name
            } else {
                cell.consentIDString.text = purposeConsents[indexPath.row].id
                cell.consentNameString.text = purposeConsents[indexPath.row].name
            }
            return cell
        }
        return UITableViewCell()
    }
}

//// MARK: - UITableViewDelegate
extension ConsentViewDetailsViewController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        consentTableView.deselectRow(at: indexPath, animated: false)
    }
}
