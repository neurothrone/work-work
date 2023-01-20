//
//  Todo+Preview.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import CoreData

extension Todo {
  public enum Preview {
    public static func generateSample(using context: NSManagedObjectContext) -> Todo {
      let todo = Todo(context: context)
      todo.title = "Preview Todo"
      todo.save(using: context)
      return todo
    }
  }
}
