//
//  TasksTableViewCell.swift
//  ToDoList
//
//  Created by Алина Власенко on 21.05.2024.
//

import UIKit

class TasksTableViewCell: UITableViewCell {
    
    var complitedButtonTabComplition: (() -> ())?
    
    //MARK: - Identifier
    static let identifier = "TasksTableViewCell"
    
    //MARK: - UI
    let taskNameLbl: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 17, weight: .light)
        return label
    }()
    
    lazy var complitedButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
        button.tintColor = .systemBlue
        button.addTarget(self, action: #selector(didTabComplitedButton), for: .touchUpInside)
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
        
        [taskNameLbl, complitedButton]
            .forEach { self.addSubview($0) }
    }
    
    // MARK: - Actions
    @objc private func didTabComplitedButton() {
        
        complitedButtonTabComplition?()
        debugPrint("didTabComplitedButton")
    }
    
    // MARK: - Apply constraints
    private func applyConstraints() {
        
        [taskNameLbl, complitedButton]
            .forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        let taskNameLblConstraints = [
            taskNameLbl.centerYAnchor.constraint(equalTo: centerYAnchor),
            taskNameLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            taskNameLbl.heightAnchor.constraint(equalToConstant: 30)
        ]
        
        let favoriteButtonConstraints = [
            complitedButton.leadingAnchor.constraint(equalTo: taskNameLbl.trailingAnchor, constant: 20),
            complitedButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            complitedButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            complitedButton.heightAnchor.constraint(equalToConstant: 30),
            complitedButton.widthAnchor.constraint(equalToConstant: 30)
        ]
        
        [taskNameLblConstraints, favoriteButtonConstraints]
            .forEach { NSLayoutConstraint.activate($0) }
    }
}

// MARK: - Configure with model function
extension TasksTableViewCell {
   
    public func configure(with model: Task) {
        
        taskNameLbl.text = model.name
        
        model.isComplieted ?? false
        ? complitedButton.setBackgroundImage(UIImage(systemName: "checkmark.square"), for: .normal)
        : complitedButton.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
    }
}
