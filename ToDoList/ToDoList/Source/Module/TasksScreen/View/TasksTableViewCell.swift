//
//  TasksTableViewCell.swift
//  ToDoList
//
//  Created by Алина Власенко on 21.05.2024.
//

import UIKit

class TasksTableViewCell: UITableViewCell {
    
    var completedButtonTabComplition: (() -> ())?
    
    //MARK: - Identifier
    static let identifier = "TasksTableViewCell"
    
    //MARK: - UI
    let taskNameLbl: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: Constant.standardFontSize, weight: .light)
        return label
    }()
    
    lazy var completedButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(didTabCompletedButton), for: .touchUpInside)
        return button
    }()

    //MARK: - override
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .systemBackground
        
        addSubviews()
        applyConstraints()
    }
    
    
    //MARK: - Required Init
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    // MARK: - Add subviews
    private func addSubviews() {
        
        [taskNameLbl, completedButton]
            .forEach { self.addSubview($0) }
    }
    
    // MARK: - Actions
    @objc private func didTabCompletedButton() {
        
        completedButtonTabComplition?()
        debugPrint("didTabCompletedButton")
    }
    
    // MARK: - Apply constraints
    private func applyConstraints() {
        
        [taskNameLbl, completedButton]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        let taskNameLblConstraints = [
            taskNameLbl.centerYAnchor.constraint(equalTo: centerYAnchor),
            taskNameLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constant.leadingOffset),
            taskNameLbl.heightAnchor.constraint(equalToConstant: Constant.lblHeight)
        ]
        
        let completedButtonConstraints = [
            completedButton.leadingAnchor.constraint(equalTo: taskNameLbl.trailingAnchor, constant: Constant.completedButtonLeadingOffset),
            completedButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Constant.trailingOffset),
            completedButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            completedButton.heightAnchor.constraint(equalToConstant: Constant.iconHeight),
            completedButton.widthAnchor.constraint(equalToConstant: Constant.iconWidth)
        ]
        
        [taskNameLblConstraints, completedButtonConstraints]
            .forEach { NSLayoutConstraint.activate($0) }
    }
}

// MARK: - Configure with model function
extension TasksTableViewCell {
   
    public func configure(with model: CDTasks) {
        
        taskNameLbl.text = model.name
        
        if model.isCompleted {
            completedButton.setBackgroundImage(UIImage(systemName: "checkmark.square"), for: .normal)
            taskNameLbl.textColor = .systemGray
        } else {
            completedButton.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
            taskNameLbl.textColor = .none
        }
    }
}
