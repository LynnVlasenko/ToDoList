//
//  UITextFieldExtansion.swift
//  ToDoList
//
//  Created by Алина Власенко on 21.05.2024.
//

import UIKit

extension UITextField {

    func setLeftPaddingPoints(_ amount:CGFloat){
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
        }
}
