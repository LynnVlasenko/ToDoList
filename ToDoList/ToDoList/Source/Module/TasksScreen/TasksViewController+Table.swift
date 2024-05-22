//
//  TasksViewController+Table.swift
//  ToDoList
//
//  Created by Алина Власенко on 21.05.2024.
//

import UIKit

// MARK: - Extension for Table
extension TasksViewController: UITableViewDataSource, UITableViewDelegate {
    
    // numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // changing the appearance of the screen if we don't have tasks
        if tasks.count == 0 {
            tasksTable.isHidden = true
            noTasksLbl.isHidden = false
        } else {
            tasksTable.isHidden = false
            noTasksLbl.isHidden = true
        }
        
        return tasks.count
    }
    
    // cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TasksTableViewCell.identifier, 
                                                       for: indexPath) as? TasksTableViewCell
        else {
            assertionFailure()
            return UITableViewCell()
        }
        
        let model = tasks[indexPath.row]
        cell.configure(with: model)
        
        cell.complitedButtonTabComplition = { [weak self, indexPath] in
            guard let self = self else { return }
            
            let isCompleted = !tasks[indexPath.row].complited()
            updateItem(with: isCompleted, at: indexPath.row)
            
            if isCompleted {
                cell.complitedButton.setBackgroundImage(UIImage(systemName: "checkmark.square"), for: .normal)
                self.buttonView.isHidden = false
                isComplietedTasks.append(1)
                print(isComplietedTasks)
            } else {
                cell.complitedButton.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
                isComplietedTasks.removeLast()
                print(isComplietedTasks)
                checkComplitedTask()
            }
        }
        return cell
    }
        
    // heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    // to delete row
    func tableView(_ tableView: UITableView, 
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            removeFromTasks(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
