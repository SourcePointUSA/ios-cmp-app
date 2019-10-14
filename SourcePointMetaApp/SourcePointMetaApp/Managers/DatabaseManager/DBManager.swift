//
//  DBManager.swift
//  SourcePointMetaApp
//
//  Created by Vilas on 3/25/19.
//  Copyright © 2019 Cybage. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class DBManager: NSObject {
    
    // MARK: LifeCycle Methods
    
    fileprivate override init() {
    }
    
    // MARK: Instacne Properties
    
    // shared manager instance
    static let sharedManager = DBManager()
    
    // queue in which all DB operation will happen, which makes Database threadsafe
    let coredataQueue = DispatchQueue(label: "com.cybage.sourcepointmetaapp.coredata", attributes: [])
    
    /**
     The directory the application uses to store the Core Data store file. This code uses a directory in the application's documents Application Support directory.
     */
    lazy private var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    
    /// The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
    lazy private var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "SourcePointMetaApp", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    /// The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
    lazy private var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        let url = applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        /// For Console logs.
        Log.sharedLog.DLog(message:"documents url == \(applicationDocumentsDirectory)")
        
        
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            Log.sharedLog.DLog(message:"Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()
    
    /// It is background managed object context which deals with persistent store coordinator.
    private lazy var parentManagedObjectContext : NSManagedObjectContext = {
        let coordinator = persistentStoreCoordinator
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Instance Methods
    /// It creates child managed object.
    ///
    /// - Returns: Managed object context.
    func temporaryMOC() -> NSManagedObjectContext {
        
        let temporaryContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        temporaryContext.parent = parentManagedObjectContext
        return temporaryContext
    }
    
    /// It push changes to persistent storage made in managed object context.
    ///
    /// - Parameters:
    ///   - moc: Managed Object Context.
    ///   - completion: Completion block. first argument represents execution status and second argumenet represents "was MOC changes found".
    func save(managedObjectContext moc : NSManagedObjectContext,completion:@escaping (Bool,Bool) -> Void) {
        
        guard moc.hasChanges else {
            completion(false,false)
            return
        }
        moc.perform {
            do {
                try moc.save()
                guard self.parentManagedObjectContext.hasChanges else {
                    completion(false,false)
                    return
                }
                self.parentManagedObjectContext.perform {
                    do {
                        try self.parentManagedObjectContext.save()
                        completion(true,true)
                    } catch _ as NSError {
                        /// For Console logs.
                        let logFor = Log.sharedLog
                        logFor.DLog(message:"error in top most backgrond thread MOC ")
                        completion(false,true)
                    }
                }
                
            } catch _ as NSError {
                completion(false,true)
            }
        }
    }
    
    /// It delete the managed object (entity) synchronously.
    ///
    /// - Parameters:
    ///   - entity: Managed object.
    ///   - backgroundMOC: Managed object context.
    func deleteEntity( _ entity : NSManagedObject , usingMOC backgroundMOC : NSManagedObjectContext ) {
        let managedContext = backgroundMOC
        managedContext.performAndWait {
            managedContext.delete(entity)
        }
    }
    
    /// It pull the managed object (entity).
    ///
    /// - Parameters:
    ///   - objectID: ManagedObjectID.
    ///   - backgrounContext: Managed Object Context.
    ///   - completion: Callback.
    func fetchEntity(withManagedObjectID objectID : NSManagedObjectID , managedObjectContext backgrounContext : NSManagedObjectContext, completion:@escaping (NSManagedObject) -> Void) {
        
        backgrounContext.perform {
            let record = backgrounContext.object(with: objectID)
            completion(record)
        }
    }
    
    
    /// It fetch single managed object (entity) from the database asynchronously.
    ///
    /// - Parameters:
    ///   - entityName: Name of table/entity.
    ///   - sortDescriptors: array of sorting attributes.
    ///   - predicate: conditional block if any.
    ///   - backgrounContext: Managed object context.
    ///   - completion: Completion block.
    func fetchEntity(_ entityName : String , sortDescriptors : [NSSortDescriptor]? , predicate : NSPredicate?, managedObjectContext backgrounContext : NSManagedObjectContext, completion:@escaping (NSManagedObject?) -> Void) {
        
        backgrounContext.perform {
            
            var record : NSManagedObject?
            
            //Initialize fetch request
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            
            //Adding sortdescriptors
            fetchRequest.sortDescriptors = sortDescriptors
            
            //Adding predicate
            fetchRequest.predicate = predicate
            
            do {
                let results =
                    try backgrounContext.fetch(fetchRequest)
                record = (results as? [NSManagedObject])?.first
            } catch {
                /// For Console logs.
             Log.sharedLog.DLog(message:"error in fetching records from database")
            }
            completion(record)
        }
    }
    
    /// It fetch multiple managed objects (entities) from the database asynchronously.
    ///
    /// - Parameters:
    ///   - entityName: Name of table/entity.
    ///   - sortDescriptors: array of sorting attributes.
    ///   - predicate: conditional block if any.
    ///   - backgrounContext: Managed object context.
    ///   - completion: Completion block.
    func fetchEntities(_ entityName : String , sortDescriptors : [NSSortDescriptor]? , predicate : NSPredicate?, managedObjectContext backgrounContext : NSManagedObjectContext, completion:@escaping ([NSManagedObject]?) -> Void) {
        
        backgrounContext.perform {
            
            var records : [NSManagedObject]?
            
            //Initialize fetch request
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            
            //Adding sortdescriptors
            fetchRequest.sortDescriptors = sortDescriptors
            
            //Adding predicate
            fetchRequest.predicate = predicate
            
            do {
                let results =
                    try backgrounContext.fetch(fetchRequest)
                records = results as? [NSManagedObject]
            } catch {
                Log.sharedLog.DLog(message:"error in fetching records from database")
            }
            completion(records)
        }
    }
    
    
    
    /// It tells about the number of entities, execution goes synchronously.
    ///
    /// - Parameters:
    ///   - entityName: Name of table/entity.
    ///   - sortDescriptors: array of sorting attributes.
    ///   - predicate: conditional block if any.
    ///   - backgrounContext: Managed object context against which query is to be executed.
    /// - Returns: Count of the entities.
    func entityCount(fromEntity entityName : String , sortDescriptors : [NSSortDescriptor]? , predicate : NSPredicate?, managedObjectContext backgrounContext : NSManagedObjectContext) -> Int{
        //Initialize fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        //Adding sortdescriptors
        fetchRequest.sortDescriptors = sortDescriptors
        
        //Adding predicate
        fetchRequest.predicate = predicate
        do {
            return try backgrounContext.count(for: fetchRequest)
        } catch {
            Log.sharedLog.DLog(message:"failed to catch")
        }
        return 0
    }
    
    
    
    let dict = [String:Any]()
    
    /// It fetch all dictionary formatted records from specified table/entity synchronously.
    ///
    /// - Parameters:
    ///   - entityName: Name of table/entity.
    ///   - sortDescriptors: array of sorting attributes.
    ///   - predicate: conditional block if any.
    ///   - backgrounContext: Managed Object Context.
    ///   - propertiesToFetch: Array of properties to fetch.
    ///   - propertiesToGroupBy: Array of properties to group by.
    /// - Returns: Array of dictinory formatted records.
    func fetchDictionary(fromEntity entityName : String , sortDescriptors : [NSSortDescriptor]? , predicate : NSPredicate?, managedObjectContext backgrounContext : NSManagedObjectContext, arrayOfPropertiesToFetch propertiesToFetch : [String], arrayOfPropertiesToGroupBy propertiesToGroupBy : [String]) -> [[String:Any]]? {
        var records : [[String:Any]]?
        backgrounContext.performAndWait {
            
            //Initialize fetch request
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            
            fetchRequest.propertiesToFetch = propertiesToFetch
            
            fetchRequest.propertiesToGroupBy = propertiesToGroupBy
            
            fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType
            
            //Adding sortdescriptors
            fetchRequest.sortDescriptors = sortDescriptors
            
            //Adding predicate
            fetchRequest.predicate = predicate
            
            do {
                let results =
                    try backgrounContext.fetch(fetchRequest)
                records = results as? [[String:Any]]
            } catch {
            }
        }
        return records
    }
    
    /// It fetch all entities from specified table/entity synchronously.
    ///
    /// - Parameters:
    ///   - entityName: Name of table/entity.
    ///   - sortDescriptors: array of sorting attributes.
    ///   - predicate: conditional block if any.
    ///   - backgrounContext: Managed Object Context.
    /// - Returns: Array of managed object (entity).
    func fetch(fromEntity entityName : String , sortDescriptors : [NSSortDescriptor]? , predicate : NSPredicate?, managedObjectContext backgrounContext : NSManagedObjectContext) -> [NSManagedObject]?{
        var records : [NSManagedObject]?
        backgrounContext.performAndWait {
            
            //Initialize fetch request
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            
            //Adding sortdescriptors
            fetchRequest.sortDescriptors = sortDescriptors
            
            //Adding predicate
            fetchRequest.predicate = predicate
            
            do {
                let results =
                    try backgrounContext.fetch(fetchRequest)
                records = results as? [NSManagedObject]
            } catch {
            }
        }
        
        return records
    }
}
