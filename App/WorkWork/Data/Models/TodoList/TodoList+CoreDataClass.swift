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
      return NSFetchRequest<TodoList>(entityName: "TodoList")
  }

  @NSManaged public var todos: [Todo]
//  @NSManaged public var todos: NSSet?
  
  @objc var todosCount: Int {
    willAccessValue(forKey: "todos")
    let count = todos.count
    didAccessValue(forKey: "todos")
    return count
  }

}
