//
//  TodoList+Extensions.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import CoreData

extension TodoList {
  static func createWith(
    _ title: String,
    using context: NSManagedObjectContext
  ) -> TodoList {
    let todoList = TodoList(context: context)
    todoList.title = title
    todoList.order = TodoList.nextOrder(for: self)
    
    CoreDataProvider.save(using: context)
//    todoList.save(using: context)
    
    return todoList
  }
}
