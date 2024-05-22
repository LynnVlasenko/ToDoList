//
//  Task.swift
//  ToDoList
//
//  Created by Алина Власенко on 21.05.2024.
//

import Foundation

struct Task: Decodable {
    
    var name: String
    var isComplieted: Bool? = false
    
    func complited() -> Bool {
        return isComplieted ?? false
    }
}
