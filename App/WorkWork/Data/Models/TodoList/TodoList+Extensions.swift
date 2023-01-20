//
//  TodoList+Extensions.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import CoreData

extension TodoList {
  static func create(
    with title: String,
    icon: Icon = .default,
    using context: NSManagedObjectContext
  ) -> TodoList {
    let todoList = TodoList(context: context)
    todoList.title = title
    todoList.systemImage = icon.rawValue
    todoList.order = TodoList.nextOrder(for: TodoList.self, using: context)
    todoList.save(using: context)

    return todoList
  }
  
  static func update(
    list: TodoList,
    with newTitle: String,
    newIcon: Icon,
    using context: NSManagedObjectContext
  ) {
    list.title = newTitle
    list.systemImage = newIcon.rawValue
    list.save(using: context)
  }
  
  static func deleteAll(using context: NSManagedObjectContext) {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: TodoList.self))
    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    batchDeleteRequest.resultType = .resultTypeObjectIDs

    guard let result = try? context.execute(batchDeleteRequest) as? NSBatchDeleteResult else { return }

    let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result.result as! [NSManagedObjectID]]
    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
  }
  
  static func uncheckAllTodos(
    in todoList: TodoList,
    using context: NSManagedObjectContext
  ) {
    let request: NSFetchRequest<Todo> = Todo.fetchRequest()
    
    let todoInListPredicate = NSPredicate(format: "%K == %@", "list.id", todoList.id as CVarArg)
    let isDonePredicate = NSPredicate(format: "%K == %@", #keyPath(Todo.isDone), NSNumber(value: true))
    let compoundPredicate = NSCompoundPredicate(
      andPredicateWithSubpredicates: [
        todoInListPredicate,
        isDonePredicate
      ])
    request.predicate = compoundPredicate
    
    do {
      let todos = try context.fetch(request)
      
      for todo in todos {
        todo.isDone = false
      }
      
      CoreDataProvider.save(using: context)
    } catch {
      print("❌ -> Failed to fetch Todos. Error: \(error.localizedDescription)")
    }
  }
  
  static func deleteAllTodos(
    in todoList: TodoList,
    using context: NSManagedObjectContext
  ) {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Todo.self))
    fetchRequest.predicate = NSPredicate(format: "%K == %@", "list.id", todoList.id as CVarArg)
    let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    batchDeleteRequest.resultType = .resultTypeObjectIDs

    guard let result = try? context.execute(batchDeleteRequest) as? NSBatchDeleteResult else { return }

    let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result.result as! [NSManagedObjectID]]
    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
  }
}
