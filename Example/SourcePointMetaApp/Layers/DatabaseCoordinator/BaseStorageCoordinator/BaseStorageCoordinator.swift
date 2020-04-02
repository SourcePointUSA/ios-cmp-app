//
//  BaseStorageCoordinator.swift
//  SourcepointMetaApp
//
//  Created by Vilas on 3/22/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import Foundation
import CoreData

class BaseStorageCoordinator {

    // MARK: - Instance Properties

    /// Reference to block which gets triggered on updation in managed object's. it carry all updated managed objects to the interested context.
    var managedObjectsUpdatedEventHandler: (([NSManagedObject]?) -> Void)?

    /// Reference to block which gets triggered on new managed object's insertion. it carry all new managed objects to the interested context.
    var managedObjectsInsertedEventHandler: (([NSManagedObject]?) -> Void)?

    /// Reference to block which gets triggered on deletion of some managed objects. it carry all deleted managed objects to the interested context.
    var managedObjectsDeletedEventHandler: (([NSManagedObject]?) -> Void)?

    /// Managed object context which interacts with database for JOB creation.
    lazy var managedObjectContext: NSManagedObjectContext = {
        let dbManager = DBManager.sharedManager
        return dbManager.temporaryMOC()
    }()

    // MARK: - Initializers

    /// Initializer
    init() {
        _ = managedObjectContext
        NotificationCenter.default.addObserver(self, selector: #selector(handleContextDidSaveEvent(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: managedObjectContext)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAnotherMOCChangeEvent(notification:)), name: NSNotification.Name(rawValue: SourcepointNotificationIdentifier.managedObjectsContextDidChangeNotificationIdentiifer), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Instance Methods

    /// Sub-class should not override it, doing it may create standstill situation for you.
    /// - Parameter notification: Notification
    @objc func handleContextDidSaveEvent(notification: Notification) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: SourcepointNotificationIdentifier.managedObjectsContextDidChangeNotificationIdentiifer), object: notification)
    }

    /// Sub-class can override this behavior to provide implementation to respond another MOC change event notification.
    /// - Parameter notification: Notification
    @objc func handleAnotherMOCChangeEvent(notification: Notification) {}

    /// It refresh managed object context and sync with persistent storage.
    func refreshContext(completionHandler handler : @escaping () -> Void) {
        let _managedObjectContext = managedObjectContext
        _managedObjectContext.performAndWait {
            if #available(iOS 8.3, *) {
                managedObjectContext.refreshAllObjects()
            } else {
                // Fallback on earlier versions
            }
            handler()
        }
    }

    /// It refresh specified managed object only not entire managed object context.
    func refreshContext(forManagedObject managedObject: NSManagedObject, completionHandler handler : @escaping () -> Void) {
        let _managedObjectContext = managedObjectContext
        _managedObjectContext.performAndWait {
            managedObjectContext.refresh(managedObject, mergeChanges: true)
            handler()
        }
    }
}
