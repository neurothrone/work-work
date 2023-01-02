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
public class TodoList: NSManagedObject {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoList> {
    return NSFetchRequest<TodoList>(entityName: String(describing: TodoList.self))
  }
  
  @NSManaged public var name: String
  @NSManaged public var order: Int16
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

extension TodoList : Identifiable {}
