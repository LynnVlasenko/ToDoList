//
//  AddTaskViewController.swift
//  ToDoList
//
//  Created by Алина Власенко on 21.05.2024.
//

import UIKit

// protocol to get new created task
protocol SetTasksDelegate {
    func getTask(task: Task)
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
        textField.setLeftPaddingPoints(20)
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create Task", for: .normal)
        button.backgroundColor = .systemGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(didTabCreateButton), for: .touchUpInside)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
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
        view.addSubview(taskNameField)
        view.addSubview(createButton)
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
        
        // save data to the model
        let model = Task(name: name)
        delegateSetTasks?.getTask(task: model)

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
        let taskNameFieldConstraints = [
            taskNameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            taskNameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            taskNameField.widthAnchor.constraint(equalTo: view.widthAnchor),
            taskNameField.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let createButtonConstraints = [
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.topAnchor.constraint(equalTo: taskNameField.bottomAnchor, constant: 50),
            createButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            createButton.heightAnchor.constraint(equalToConstant: 44)
        ]
        
        NSLayoutConstraint.activate(taskNameFieldConstraints)
        NSLayoutConstraint.activate(createButtonConstraints)
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
