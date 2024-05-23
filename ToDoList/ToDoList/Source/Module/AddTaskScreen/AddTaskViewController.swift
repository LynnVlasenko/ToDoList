//
//  AddTaskViewController.swift
//  ToDoList
//
//  Created by Алина Власенко on 21.05.2024.
//

import UIKit

// protocol to get new created task
protocol SetTasksDelegate {
    func getTask()
}

class AddTaskViewController: UIViewController {
    
    // MARK: - delegates
    var delegateSetTasks: SetTasksDelegate?
    weak var delegateNewTask: NewTaskDelegate?
    
    var name: String?
    
    // MARK: - UI
    private let taskNameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type Name of Task"
        textField.setLeftPaddingPoints(Constant.textFieldPadding)
        textField.layer.borderWidth = Constant.textFieldBorderWidth
        textField.layer.borderColor = UIColor.lightGray.cgColor
        return textField
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create Task", for: .normal)
        button.backgroundColor = .systemGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constant.buttonCornerRadius
        button.addTarget(self, action: #selector(didTabCreateButton), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    // MARK: - override
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureNavBar()
        addSubviews()
        applyConstraints()
        setupDelegate()
        enableButton()
    }
    
    // MARK: - Add Subviews
    private func addSubviews() {
       
        [taskNameField, createButton]
            .forEach { view.addSubview($0) }
    }
    
    // MARK: - Configure Nav Bar
    private func configureNavBar() {
        title = "Add New Task"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .systemBlue
   }
    
    // MARK: - Actions
    // Create Button Action
    @objc private func didTabCreateButton() {
        
        // hide keyboard
        taskNameField.resignFirstResponder()
        
        guard let name = name  else { return }
        
        // save data to CoreData
        CoreDataService.shared.createItem(name: name)
        
        // save data to the model
        delegateSetTasks?.getTask()
        
        // go to previous screen
        navigationController?.popViewController(animated: false)
        
        debugPrint("name: \(name)")
    }
    
    // Do Enable Create Button Action
    func enableButton() {
        taskNameField.addTarget(self, action: #selector(taskNameTextDidChange(_:)), for: .editingChanged)
    }
    
    @objc func taskNameTextDidChange(_ textField: UITextField) {
        if let text = textField.text, text.isEmpty {
            createButton.isEnabled = false
            createButton.backgroundColor = .systemGray
        } else {
            createButton.isEnabled = true
            createButton.backgroundColor = .systemBlue
        }
    }
    
    // set up delegates
    private func setupDelegate() {
        taskNameField.delegate = self
        delegateNewTask = self
    }
    
    //MARK: - Apply constraints
    private func applyConstraints() {
        
        [taskNameField, createButton]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        let taskNameFieldConstraints = [
            taskNameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constant.taskNameFieldTopOffset),
            taskNameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taskNameField.widthAnchor.constraint(equalTo: view.widthAnchor),
            taskNameField.heightAnchor.constraint(equalToConstant: Constant.taskNameFieldHeight)
        ]
        
        let createButtonConstraints = [
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.topAnchor.constraint(equalTo: taskNameField.bottomAnchor, constant: Constant.createButtonTopOffset),
            createButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Constant.buttonWidthMultiplier),
            createButton.heightAnchor.constraint(equalToConstant: Constant.buttonHeight)
        ]
        
        [taskNameFieldConstraints, createButtonConstraints]
            .forEach { NSLayoutConstraint.activate($0) }
    }
}

// MARK: - Extension for NewTaskDelegate
extension AddTaskViewController: NewTaskDelegate {
    // description of saving the text from the field to an additional variable
    func didTaskNameField(with text: String) {
        name = text
    }
}

// MARK: - Extension for UITextFieldDelegate
extension AddTaskViewController: UITextFieldDelegate {
    
    // implementation of saving text from the field to an additional variable
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        delegateNewTask?.didTaskNameField(with: text)
    }
}
