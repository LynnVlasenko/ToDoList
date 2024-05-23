//
//  TasksViewController.swift
//  ToDoList
//
//  Created by Алина Власенко on 21.05.2024.
//

import UIKit

// MARK: - Protocol to get a new task name fron textField
protocol NewTaskDelegate: AnyObject {
    func didTaskNameField(with text: String)
}


class TasksViewController: UIViewController {
    
    // array to save data to CoreData
    var tasks = [CDTasks]()
    
    // MARK: - UI
     let tasksTable: UITableView = {
        let table = UITableView()
        table.register(TasksTableViewCell.self, forCellReuseIdentifier: TasksTableViewCell.identifier)
        return table
    }()
    
    let noTasksLbl: UILabel = {
        let label = UILabel()
        label.text = "Please add your first task"
        label.font = UIFont.systemFont(ofSize: Constant.standardFontSize, weight: .light)
        return label
    }()
    
    let buttonView: UIView = {
        let contentView = UIView()
        contentView.backgroundColor = .systemBackground
        contentView.isHidden = true
        return contentView
    }()
    
    private lazy var removeCompletedButton: UIButton = {
        let button = UIButton()
        button.setTitle("Remove Completed", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.layer.cornerRadius = Constant.buttonCornerRadius
        button.addTarget(self, action: #selector(didTabRemoveCompletedButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = .systemBackground
        configureNavBar()
        addSubviews()
        applyConstraints()
        applyDelegates()
        // to show data from CoreData
        getAllItems()
        // to show button to delete is completed tasks
        checkCompletedTask()
    }
    
    // MARK: - Add Subviews
    private func addSubviews() {
        [noTasksLbl, tasksTable, buttonView]
            .forEach { view.addSubview($0) }
        buttonView.addSubview(removeCompletedButton)
    }
    
    // MARK: - Configure Nav Bar
    private func configureNavBar() {
        
        title = "Tasks"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemBlue
        
        // Navigation Bar Appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
        // Bar Button Items
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAdd))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Clean",
            style: .done,
            target: self,
            action: #selector(didTapClean))
        
        navigationItem.leftBarButtonItem?.tintColor = .systemRed
    }
    
    //MARK: - Actions
    // add button action
    @objc func didTapAdd() {
        
        let vc = AddTaskViewController()
        vc.delegateSetTasks = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // clear button action
    @objc func didTapClean() {
        
        CoreDataService.shared.deleteAllItems()
        removeAllTasks()
        buttonView.isHidden = true
    }
    
    // remove completed button action
    @objc private func didTabRemoveCompletedButton() {
        
        removeAllCompletedItem()
        buttonView.isHidden = true
        debugPrint(tasks)
    }
    
    private func applyDelegates() {
        
        tasksTable.delegate = self
        tasksTable.dataSource = self
    }
    
    // MARK: - Apply constraints
    private func applyConstraints() {
        
        [noTasksLbl, tasksTable, buttonView, removeCompletedButton]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
            
        let tasksTableConstraints = [
            tasksTable.heightAnchor.constraint(equalTo: view.heightAnchor, 
                                               multiplier: Constant.tasksTableHeightMultiplier),
            tasksTable.widthAnchor.constraint(equalTo: view.widthAnchor)
        ]
        
        let noTasksLblConstraints = [
            noTasksLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noTasksLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        
        let buttonViewConstraints = [
            buttonView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            buttonView.heightAnchor.constraint(equalTo: view.heightAnchor, 
                                               multiplier: Constant.buttonViewHeightMultiplier),
            buttonView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ]
        
        let removeCompletedButtonConstraints = [
            removeCompletedButton.centerXAnchor.constraint(equalTo: buttonView.centerXAnchor),
            removeCompletedButton.centerYAnchor.constraint(equalTo: buttonView.centerYAnchor),
            removeCompletedButton.widthAnchor.constraint(equalTo: buttonView.widthAnchor, 
                                                         multiplier: Constant.buttonWidthMultiplier),
            removeCompletedButton.heightAnchor.constraint(equalToConstant: Constant.buttonHeight)
        ]
        
        [tasksTableConstraints, noTasksLblConstraints, buttonViewConstraints, removeCompletedButtonConstraints]
            .forEach { NSLayoutConstraint.activate($0) }
    }
}


// MARK: - Extension for Protocol - SetContactsDelegate
extension TasksViewController: SetTasksDelegate {
       
    func getTask() {
        
        getAllItems()
    }
}
