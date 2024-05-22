//
//  TasksViewController+Servise.swift
//  ToDoList
//
//  Created by Алина Власенко on 22.05.2024.
//

import UIKit

extension TasksViewController {
    
    // remove From Tasks Array
    func removeFromTasks(at index: Int) {
        tasks.remove(at: index)
    }
    
    // update isComplieted
    func updateItem(with isCompleted: Bool, at index: Int) {
        tasks[index].isComplieted = isCompleted
    }
    // check Complited Task to Show Remove Button
    func checkComplitedTask() {
        
        if isComplietedTasks.isEmpty {
            buttonView.isHidden = true
        } else {
            buttonView.isHidden = false
        }
    }
    
    // remove All Complited Item
    func removeAllComplitedItem() {
        
        tasks.removeAll { tasks in
            tasks.isComplieted == true
        }
        DispatchQueue.main.async {
            self.tasksTable.reloadData()
        }
    }
    
    // remove All Tasks
    func removeAllTasks() {
        
        tasks.removeAll()

        DispatchQueue.main.async {
            self.tasksTable.reloadData()
        }
    }
    
}
