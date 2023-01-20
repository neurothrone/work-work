//
//  TodoList+Preview.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import CoreData

extension TodoList {
  public enum Preview {
    public static func generateSample(using context: NSManagedObjectContext) -> TodoList {
      let todoList = TodoList.create(with: "Preview List", using: context)
      
      for index in 1...5 {
        let todo = Todo(context: context)
        todo.title = "Preview Todo \(index)"
        todo.list = todoList
      }
      
      CoreDataProvider.save(using: context)
      return todoList
    }
    
    public static func generateSamples(using context: NSManagedObjectContext) {
      for index in 1...5 {
        _ = TodoList.create(with: "Preview List \(index)", using: context)
      }
    }
  }
}
