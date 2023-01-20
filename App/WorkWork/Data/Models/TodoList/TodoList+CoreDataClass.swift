//
//  TodoList+CoreDataClass.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-04.
//
//

import Foundation
import CoreData

@objc(TodoList)
public class TodoList: MoveableEntity {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoList> {
    return NSFetchRequest<TodoList>(entityName: String(String(describing: TodoList.self)))
  }

  @NSManaged public var systemImage: String
  @NSManaged public var completedTodosCount: Int16
  @NSManaged public var todos: [Todo]
  
  @objc var todosCount: Int {
    willAccessValue(forKey: "todos")
    let count = todos.count
    didAccessValue(forKey: "todos")
    return count
  }
}
