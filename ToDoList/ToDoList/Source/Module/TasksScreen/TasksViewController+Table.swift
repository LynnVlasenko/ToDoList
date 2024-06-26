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
        
        cell.completedButtonTabComplition = { [weak self, indexPath] in
            guard let self = self else { return }
            
            let isCompleted = !(tasks[indexPath.row].isCompleted)
            updateItem(with: isCompleted, at: indexPath.row)
            CoreDataService.shared.updateIsCompleted(item: model, isCompleted: isCompleted, at: indexPath.row)
            
            if isCompleted {
                cell.completedButton.setBackgroundImage(UIImage(systemName: "checkmark.square"), for: .normal)
                cell.taskNameLbl.textColor = .systemGray
                CoreDataService.shared.updateIsCompleted(item: model, isCompleted: isCompleted, at: indexPath.row)
                self.buttonView.isHidden = false
            } else {
                cell.completedButton.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
                checkCompletedTask()
                cell.taskNameLbl.textColor = .none
                CoreDataService.shared.updateIsCompleted(item: model, isCompleted: isCompleted, at: indexPath.row)
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
            CoreDataService.shared.deleteItem(item: tasks[indexPath.row])
            removeFromTasks(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            checkCompletedTask()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let model = tasks[indexPath.row]
        
        // create alert to edit task
        let sheet = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Cansel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { [weak self] _ in
            
            let alert = UIAlertController(title: "Edit Item",
                                          message: "Edit your item",
                                          preferredStyle: .alert)
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = model.name
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
                    return
                }
                CoreDataService.shared.updateItem(item: model, newName: newName)
                self?.getAllItems()
            }))
            self?.present(alert, animated: true)
        }))
        present(sheet, animated: true)
    }
}
