//
//  TodoList+Preview.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import CoreData

extension TodoList {
  enum Preview {
    static func generateSample(using context: NSManagedObjectContext) -> TodoList {
      let todoList = TodoList(context: context)
      todoList.title = "Preview List"
      
      for index in 1...5 {
        let todo = Todo(context: context)
        todo.title = "Preview Todo \(index)"
        todo.list = todoList
      }
      
      CoreDataProvider.save(using: context)
      return todoList
    }
    
    static func generateSamples(using context: NSManagedObjectContext) {
      for index in 1...5 {
        let todoList = TodoList(context: context)
        todoList.title = "Preview List \(index)"
      }
      
      CoreDataProvider.save(using: context)
    }
  }
}
