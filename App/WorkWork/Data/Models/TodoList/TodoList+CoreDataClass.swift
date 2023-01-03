//
//  TodoList+CoreDataClass.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-02.
//
//

import CoreData
import Foundation

@objc(TodoList)
public class TodoList: MoveableEntity {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoList> {
    return NSFetchRequest<TodoList>(entityName: String(describing: TodoList.self))
  }
  
  @objc var todosCount: Int {
    willAccessValue(forKey: "todos")
    let count = todos.count
    didAccessValue(forKey: "todos")
    return count
  }
  
  @NSManaged public var todos: [Todo]
}

// MARK: Generated accessors for todos
extension TodoList {
  
  @objc(addTodosObject:)
  @NSManaged public func addToTodos(_ value: Todo)
  
  @objc(removeTodosObject:)
  @NSManaged public func removeFromTodos(_ value: Todo)
  
  @objc(addTodos:)
  @NSManaged public func addToTodos(_ values: NSSet)
  
  @objc(removeTodos:)
  @NSManaged public func removeFromTodos(_ values: NSSet)
  
}
