//
//  CoreDataService.swift
//  ToDoList
//
//  Created by Алина Власенко on 22.05.2024.
//

import UIKit
import CoreData


class CoreDataService: NSObject {
    
    static let shared = CoreDataService()

    var objectStoreFileName : String

    init(baseFileName : String = "ToDoListTest") {
        self.objectStoreFileName = baseFileName
    }
    
    // Container
    lazy var persistentContainer: NSPersistentContainer = {
        
        guard let mom = NSManagedObjectModel.mergedModel(from: [Bundle.main]) else {
            fatalError("Could not get Managed Object Model");
        }

        let container = NSPersistentContainer(name: objectStoreFileName, managedObjectModel: mom)

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("This error data storage from being initialized: \(error), \(error.userInfo)")
            }
        })
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        return container
    }()
    
    // context
    lazy var context: NSManagedObjectContext = {
        
        let taskContext = self.persistentContainer.viewContext
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let taskContext = self.persistentContainer.newBackgroundContext()
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return taskContext
    }()
    
    // save context
    func save(context: NSManagedObjectContext) {
        
        context.performAndWait {
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    debugPrint("CoreDataService could not save due to error: \(error)")
                }
            }
        }
    }
}

extension CoreDataService {
    
    // fetch Data From Entity
    func fetchDataFromEntity<T>(_ type: T.Type,
                                context: NSManagedObjectContext? = nil,
                                fetchRequest: NSFetchRequest<T>,
                                sort: [NSSortDescriptor]? = nil,
                                wantFault: Bool? = true) -> [T] where T: NSManagedObject {
        
        if let sortDescriptor = sort {
            fetchRequest.sortDescriptors = sortDescriptor
        }
        
        if wantFault == false {
            fetchRequest.returnsObjectsAsFaults = false
        }
        
        var results: [Any] = []
        if let context = context {
            context.performAndWait {
                do {
                    results = try context.fetch(fetchRequest)
                } catch let error {
                    debugPrint(error)
                }
            }
        } else {
            self.context.performAndWait {
                do {
                    results = try self.context.fetch(fetchRequest)
                } catch let error {
                    debugPrint(error)
                }
            }
        }
        return results as? [T] ?? []
    }
    
    
    // delete data
    func deleteRecords<T>(_ type: T.Type,
                          context: NSManagedObjectContext? = nil,
                          fetchRequest: NSFetchRequest<T>)  where T: NSManagedObject {
        if let context = context {
            let resultsToDelete = fetchDataFromEntity(T.self,
                                                      context: context,
                                                      fetchRequest: fetchRequest,
                                                      sort: nil,
                                                      wantFault: false)
            if !resultsToDelete.isEmpty {
                self.deleteRecords(resultsToDelete, context: context)
            }
        } else {
            backgroundContext.performAndWait {
                let resultsToDelete = self.fetchDataFromEntity(
                    T.self,
                    context: backgroundContext,
                    fetchRequest: fetchRequest,
                    sort: nil,
                    wantFault: false)
                
                if !resultsToDelete.isEmpty {
                    self.deleteRecords(resultsToDelete, context: backgroundContext)
                }
            }
        }
    }
    
    func deleteRecords<T>(_ records: [T], context: NSManagedObjectContext) where T: NSManagedObject {
        if !records.isEmpty {
            for record in records {
                context.delete(record)
            }
            self.save(context: context)
        }
    }
}
