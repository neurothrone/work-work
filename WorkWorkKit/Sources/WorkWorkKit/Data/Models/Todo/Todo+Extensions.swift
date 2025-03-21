//
//  Todo+Extensions.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import CoreData

extension Todo {
  //MARK: - Requests
  public static func allByOrder(in list: TodoList) -> NSFetchRequest<Todo> {
    MoveableEntity.allByOrder(
      predicate: NSPredicate(format: "%K == %@", "list.id", list.id as CVarArg)
    )
  }
  
  //MARK: - Data
  public static func create(
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
  
  public static func toggleIsDone(for todo: Todo, using context: NSManagedObjectContext) {
    todo.isDone.toggle()
    todo.list.completedTodosCount += todo.isDone ? 1 : -1
    todo.save(using: context)
  }
}
