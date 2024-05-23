//
//  TasksViewController+Servise.swift
//  ToDoList
//
//  Created by Алина Власенко on 22.05.2024.
//

import UIKit

extension TasksViewController {
    
    // get all items
    func getAllItems() {
        let storeData = CoreDataService.shared.fetchAllTasks()
        tasks = storeData
        print("\n\n getAllItems: \(tasks)")
        updateUI()
    }
    
    // remove from Tasks Array
    func removeFromTasks(at index: Int) {
        tasks.remove(at: index)
    }
    
    // update isCompleted
    func updateItem(with isCompleted: Bool, at index: Int) {
        tasks[index].isCompleted = isCompleted
    }
    // check Completed Task to Show Remove Button
    func checkCompletedTask() {
        var isCompletedTasks = [Bool]()
        let storeData = CoreDataService.shared.fetchAllTasks()
        for i in storeData{
            if i.isCompleted == true {
                isCompletedTasks.append(i.isCompleted)
            }
        }
        if isCompletedTasks.isEmpty {
            buttonView.isHidden = true
        } else {
            buttonView.isHidden = false
        }
    }
    
    // remove All Completed Item
    func removeAllCompletedItem() {
        
        CoreDataService.shared.removeAllCompletedItem(in: tasks)
        getAllItems()
    }
    
    // remove All Tasks
    func removeAllTasks() {
        tasks.removeAll()
        updateUI()
    }
    
    // reload Data
    func updateUI() {
        DispatchQueue.main.async {
            self.tasksTable.reloadData()
        }
    }
}
