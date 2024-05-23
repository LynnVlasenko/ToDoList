//
//  CDTasks+CoreDataProperties.swift
//  ToDoList
//
//  Created by Алина Власенко on 23.05.2024.
//
//

import Foundation
import CoreData


extension CDTasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTasks> {
        return NSFetchRequest<CDTasks>(entityName: "CDTasks")
    }

    @NSManaged public var name: String?
    @NSManaged public var isCompleted: Bool

}

extension CDTasks : Identifiable {

}
