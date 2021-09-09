//
//  PropertyListViewController.swift
//  SourcepointMetaApp
//
//  Created by Vilas on 23/03/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import UIKit
import CoreData
import ConsentViewController
import WebKit

class PropertyListViewController: BaseViewController, WKNavigationDelegate, UITextViewDelegate {

    // MARK: - IBOutlet
    @IBOutlet weak var propertyTableView: SourcePointUITableView!
    @IBOutlet weak var nopropertyDataLabel: UILabel!

    // MARK: - Instance properties
    var propertyListViewModel: PropertyListViewModel = PropertyListViewModel()

    private let cellIdentifier = "propertyCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle()
        propertyTableView.tableFooterView = UIView(frame: .zero)
        let bundleId = Bundle.main.bundleIdentifier ?? ""
        let appUpdater = AppUpdateManager()
        let updateStatus = appUpdater.updateStatus(for: bundleId)
        if let appId = updateStatus.1 {
            presentUpdateAlertView(for: updateStatus.0, appId: appId)
        }
    }

    func presentUpdateAlertView(for status: AppUpdateManager.Status, appId: Int) {
        if case .optional = status {
            let alertController = UIAlertController(title: Alert.updateAppAlertTitle, message: Alert.updateAppAlertMessage, preferredStyle: .alert)
            alertController.addAction(updateAlertAction(appId: appId))
            alertController.addAction(skipAlertAction())
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func updateAlertAction(appId: Int) -> UIAlertAction {
        let action = UIAlertAction(title: Alert.updateButtonTitle, style: .default) { _ in
            UIApplication.shared.launchAppStore(for: appId)
            return
        }
        return action
    }

    func skipAlertAction() -> UIAlertAction {
        let action = UIAlertAction(title: Alert.skipButtonTitle, style: .default) { _ in
            self.dismiss(animated: true)
            return
        }
        return action
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        fetchAllpropertiesData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }

    func navTitle() {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 480, height: 44))
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18.0)
        titleLabel.textAlignment = .center
        titleLabel.textColor = #colorLiteral(red: 0, green: 0.0186597344, blue: 0.06425330752, alpha: 1)
        titleLabel.text = "Property List\n ConsentViewController v\(SPConsentManager.VERSION)"
        navigationItem.titleView = titleLabel
    }

    // This method will fetch all the properties data
    func fetchAllpropertiesData() {
        showIndicator()
        propertyListViewModel.importAllproperties(executionCompletionHandler: { [weak self] (_) in
            self?.propertyTableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                self?.propertyTableView.reloadData()
                self?.hideIndicator()
            })
        })
    }

    func setTableViewHidden() {
        propertyTableView.isHidden = !(propertyListViewModel.numberOfproperties() > 0)
        nopropertyDataLabel.isHidden = propertyListViewModel.numberOfproperties() > 0
    }

    func loadConsentDetailsViewController(atIndex index: Int, isReset: Bool) {
        if let consentDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConsentDetailsViewController") as? ConsentDetailsViewController {
            consentDetailsViewController.propertyManagedObjectID = propertyListViewModel.propertyManagedObjectID(atIndex: index)
            consentDetailsViewController.isReset = isReset
            navigationController!.pushViewController(consentDetailsViewController, animated: false)
        }
    }
}

// MARK: UITableViewDataSource
extension PropertyListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        setTableViewHidden()
        return propertyListViewModel.numberOfproperties()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PropertyCell {

            if let propertyDetails = propertyListViewModel.propertyDetails(atIndex: indexPath.row) {
                cell.propertyNameLabel.text = propertyDetails.propertyName
                cell.accountIDLabel.text = "\(SPLiteral.accountID) \(propertyDetails.accountId)"
                cell.campaignEnvLabel.text = propertyDetails.campaignEnv == Int64(0) ? "\(SPLiteral.campaignEnv) \(SPLiteral.stageEnv)" : "\(SPLiteral.campaignEnv) \(SPLiteral.publicEnv)"
                cell.messageLanguage.text = "\(SPLiteral.messageLanguage) \(propertyDetails.messageLanguage ?? "BrowserDefault")"
            }
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension PropertyListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        propertyTableView.deselectRow(at: indexPath, animated: false)
        loadConsentDetailsViewController(atIndex: indexPath.row, isReset: false)
    }

    // iOS 11 and above for right swipe gesture
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, _) in
            if let editpropertyViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddPropertyViewController") as? AddPropertyViewController {
                self?.propertyListViewModel.clearUserDefaultsData()
                editpropertyViewController.propertyManagedObjectID = self?.propertyListViewModel.propertyManagedObjectID(atIndex: indexPath.row)
                self?.navigationController!.pushViewController(editpropertyViewController, animated: false)
            }
        }
        let resetAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, handler) in
            self?.hideIndicator()
            let alertController = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)
            alertController.setValue(SPLiteral.attributedString(), forKey: "attributedTitle")
            alertController.view.accessibilityIdentifier = "alertView"
            let noAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: {(_: UIAlertAction!) in
                self?.propertyTableView.reloadData()
            })
            let yesAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
                self?.showIndicator()
                self?.propertyListViewModel.clearUserDefaultsData()
                self?.loadConsentDetailsViewController(atIndex: indexPath.row, isReset: true)
                self?.hideIndicator()
            })
            alertController.addAction(noAction)
            alertController.addAction(yesAction)
            self?.present(alertController, animated: true, completion: nil)

        }
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, _) in
            let yesHandler = { [weak self]() -> Void in
                self?.showIndicator()
                self?.propertyListViewModel.delete(atIndex: indexPath.row, completionHandler: {[weak self] (_, error) in
                    self?.hideIndicator()
                    if let _error = error {
                        let okHandler = {}
                        AlertView.sharedInstance.showAlertView(title: Alert.message, message: _error.message, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
                    } else {
                        self?.hideIndicator()
                        self?.propertyListViewModel.clearUserDefaultsData()
                        self?.fetchAllpropertiesData()
                    }
                })
            }
            let noHandler = { [weak self]() -> Void in
                self?.propertyTableView.reloadData()
            }
            self?.hideIndicator()
            AlertView.sharedInstance.showAlertView(title: Alert.alert, message: Alert.messageForDeletingPropertyData, actions: [yesHandler, noHandler], titles: [Alert.yes, Alert.no], actionStyle: UIAlertController.Style.alert)
        }
        deleteAction.backgroundColor = #colorLiteral(red: 0.2841853499, green: 0.822665453, blue: 0.653732717, alpha: 1)
        deleteAction.image = UIImage(named: "Trash")
        editAction.backgroundColor = #colorLiteral(red: 0.2841853499, green: 0.822665453, blue: 0.653732717, alpha: 1)
        editAction.image = UIImage(named: "Edit")
        resetAction.backgroundColor = #colorLiteral(red: 0.2841853499, green: 0.822665453, blue: 0.653732717, alpha: 1)
        resetAction.image = UIImage(named: "Reset")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, editAction, resetAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }

    // iOS 10 and below for right swipe gesture
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .destructive, title: "Edit") { [weak self] (_, _) in
            if let editpropertyViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddPropertyViewController") as? AddPropertyViewController {
                self?.propertyListViewModel.clearUserDefaultsData()
                editpropertyViewController.propertyManagedObjectID = self?.propertyListViewModel.propertyManagedObjectID(atIndex: indexPath.row)
                self?.navigationController!.pushViewController(editpropertyViewController, animated: false)
            }
        }

        let resetAction = UITableViewRowAction(style: .destructive, title: "Reset") { [weak self] (_, _) in
            self?.hideIndicator()
            let alertController = UIAlertController(title: "", message: "", preferredStyle: UIAlertController.Style.alert)

            alertController.setValue(SPLiteral.attributedString(), forKey: "attributedTitle")
            let noAction = UIAlertAction(title: "NO", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
                self?.propertyTableView.reloadData()
            })
            let yesAction = UIAlertAction(title: "YES", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
                self?.showIndicator()
                self?.propertyListViewModel.clearUserDefaultsData()
                self?.loadConsentDetailsViewController(atIndex: indexPath.row, isReset: true)
                self?.hideIndicator()
            })
            alertController.addAction(noAction)
            alertController.addAction(yesAction)
            self?.present(alertController, animated: true, completion: nil)
        }

        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (_, _) in
            let yesHandler = { [weak self]() -> Void in
                self?.showIndicator()
                self?.propertyListViewModel.delete(atIndex: indexPath.row, completionHandler: {[weak self] (_, error) in
                    self?.hideIndicator()
                    if let _error = error {
                        let okHandler = {}
                        AlertView.sharedInstance.showAlertView(title: Alert.message, message: _error.message, actions: [okHandler], titles: [Alert.ok], actionStyle: UIAlertController.Style.alert)
                    } else {
                        self?.hideIndicator()
                        self?.fetchAllpropertiesData()
                    }
                })
            }
            let noHandler = { [weak self]() -> Void in
                self?.propertyTableView.reloadData()
            }
            self?.hideIndicator()
            AlertView.sharedInstance.showAlertView(title: Alert.alert, message: Alert.messageForDeletingPropertyData, actions: [yesHandler, noHandler], titles: [Alert.yes, Alert.no], actionStyle: UIAlertController.Style.alert)
        }
        deleteAction.backgroundColor = #colorLiteral(red: 0.822665453, green: 0.07812128419, blue: 0.1612752695, alpha: 0.9916923415)
        editAction.backgroundColor = #colorLiteral(red: 0.2841853499, green: 0.822665453, blue: 0.653732717, alpha: 1)
        resetAction.backgroundColor = .lightGray
        return [deleteAction, editAction, resetAction]
    }
}
