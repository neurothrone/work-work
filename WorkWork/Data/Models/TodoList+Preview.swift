//
//  TodoList+Preview.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import CoreData

extension TodoList {
  enum Preview {
    static func generateSamples(using context: NSManagedObjectContext) {
      for index in 1...5 {
        let todoList = TodoList(context: context)
        todoList.name = "Preview List \(index)"
      }
      
      CoreDataProvider.save(using: context)
    }
  }
}
