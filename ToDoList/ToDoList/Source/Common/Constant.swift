//
//  Constant.swift
//  ToDoList
//
//  Created by Алина Власенко on 22.05.2024.
//

import Foundation

enum Constant {
    
    // Height
    static let iconHeight: CGFloat = 30.0 // completedButton
    static let lblHeight: CGFloat = 30.0 // taskNameLbl,
    static let buttonHeight: CGFloat = 44.0 // createButton, removeCompletedButton
    static let taskNameFieldHeight: CGFloat = 50.0 // taskNameField
    
    // Width
    static let iconWidth: CGFloat = 30.0 // completedButton
    
    // Multiplier
    static let buttonWidthMultiplier: CGFloat = 0.5 // createButton, removeCompletedButton
    static let tasksTableHeightMultiplier: CGFloat = 0.9 // tasksTable
    static let buttonViewHeightMultiplier: CGFloat = 0.1 // buttonView
   
    // Offsets
    static let leadingOffset: CGFloat = 16.0 // taskNameLbl
    static let trailingOffset: CGFloat = -16.0 // completedButton
    static let completedButtonLeadingOffset: CGFloat = 20.0 // completedButton
    static let taskNameFieldTopOffset: CGFloat = 20.0 // taskNameFieldTopOffset
    static let createButtonTopOffset: CGFloat = 50.0 // createButton
    static let textFieldPadding: CGFloat = 20.0 // taskNameField
    
    // Fonts
    static let standardFontSize: CGFloat = 17 // taskNameLbl, noTasksLbl
    
    // Radius
    static let buttonCornerRadius: CGFloat = 5 // removeCompletedButton, createButton
    
    // Boarder
    static let textFieldBorderWidth: CGFloat = 0.5 // taskNameLbl
}
