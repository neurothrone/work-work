//
//  Todo+Extensions.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import CoreData

extension Todo {
  //MARK: - Requests
  static func all(in list: TodoList) -> NSFetchRequest<Todo> {
    MoveableEntity.allByOrder(
      predicate: NSPredicate(format: "%K == %@", "list.id", list.id as CVarArg)
    )
  }
  
  //MARK: - Data
  static func create(
    with title: String,
    in list: TodoList,
    using context: NSManagedObjectContext
  ) {
    let todo = Todo(context: context)
    todo.title = title
    todo.list = list
    todo.order = Int16(list.todosCount)
    
    todo.save(using: context)
  }
  
  static func toggleIsDone(for todo: Todo, using context: NSManagedObjectContext) {
    todo.isDone.toggle()
    todo.save(using: context)
  }
}
