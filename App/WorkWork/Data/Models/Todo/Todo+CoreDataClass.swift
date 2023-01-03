//
//  Todo+CoreDataClass.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-02.
//
//

import CoreData

@objc(Todo)
public class Todo: BaseEntity {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
    return NSFetchRequest<Todo>(entityName: String(describing: Todo.self))
  }
  
  @NSManaged public var isDone: Bool
  @NSManaged public var list: TodoList
}
