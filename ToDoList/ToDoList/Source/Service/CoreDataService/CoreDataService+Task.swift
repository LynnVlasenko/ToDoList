//
//  CoreDataService+Task.swift
//  ToDoList
//
//  Created by Алина Власенко on 22.05.2024.
//

import UIKit
import CoreData

extension CoreDataService {
    // MARK: - CoreData
    
    // create Item
    func createItem(name: String) {
        
        let taskEntityDescription = NSEntityDescription.entity(forEntityName: "CDTasks", in: context)!
        guard let taskEntity = NSManagedObject(entity: taskEntityDescription, insertInto: context) as? CDTasks
        else {
            assertionFailure()
            return
        }
        taskEntity.name = name
        taskEntity.isCompleted = false
        print("createItem: \(taskEntity.name ?? "")")
        print("createItem: \(taskEntity.isCompleted)")
        save(context: context)
    }
    
    // fetch All Tasks
    func fetchAllTasks() -> [CDTasks] {
        
        let fetchRequest = CDTasks.fetchRequest()
        let fetchedResult = fetchDataFromEntity(CDTasks.self, fetchRequest: fetchRequest)
        
        print("fetchedResult: \(fetchedResult)")
        return fetchedResult
    }
    
    // delete Item
    func deleteItem(item: CDTasks) {
        context.delete(item)
        save(context: context)
    }
    
    // delete All Items
    func deleteAllItems() {
        let fetchRequest = CDTasks.fetchRequest()
        deleteRecords(CDTasks.self, fetchRequest: fetchRequest)
        save(context: context)
    }
    
    // removeAllCompletedItem
    func removeAllCompletedItem(in items: [CDTasks]) {
        for i in items {
            if i.isCompleted == true {
                context.delete(i)
            }
        }
        save(context: context)
    }
    
    // update Is Completed
    func updateIsCompleted(item: CDTasks, isCompleted: Bool, at index: Int) {
        item.isCompleted = isCompleted
        save(context: context)
    }
    
    func updateItem(item: CDTasks, newName: String) {
        item.name = newName
        save(context: context)
    }
}
    
