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
    let request: NSFetchRequest<Todo> = Todo.fetchRequest()
    request.sortDescriptors = [.init(keyPath: \Todo.createdDate, ascending: false)]
    request.predicate = NSPredicate(format: "%K == %@", "list.id", list.id as CVarArg)
    return request
  }
  
  //MARK: - Data
  static func toggleIsDone(for todo: Todo, using context: NSManagedObjectContext) {
    todo.isDone.toggle()
    todo.save(using: context)
  }
  
  
  static func addTodo(with title: String, to list: TodoList, using context: NSManagedObjectContext) {
    let todo = Todo(context: context)
    todo.title = title
    todo.list = list
    todo.save(using: context)
  }
}
