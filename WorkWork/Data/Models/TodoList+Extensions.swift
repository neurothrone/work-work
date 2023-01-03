//
//  TodoList+Extensions.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import CoreData

extension TodoList {
  //MARK: - Requests
  static var all: NSFetchRequest<TodoList> {
    let request = TodoList.fetchRequest()
    request.sortDescriptors = [.init(keyPath: \TodoList.order, ascending: true)]
    return request
  }
  
  //MARK: - Data
  static func createWith(
    name: String,
    using context: NSManagedObjectContext
  ) -> TodoList {
    let todoList = TodoList(context: context)
    todoList.name = name
    todoList.save(using: context)
    
    return todoList
  }
}
