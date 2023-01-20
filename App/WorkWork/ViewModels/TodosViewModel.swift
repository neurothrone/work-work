//
//  TodosViewModel.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-05.
//

import CoreData
import SwiftUI
import WorkWorkKit

final class TodosViewModel: BaseViewModel<Todo> {
  let todoList: TodoList
  
  init(todoList: TodoList) {
    self.todoList = todoList
  }
  
  override var addSystemImage: String {
    MyApp.SystemImage.plusCircle
  }

  override func createEntity(using context: NSManagedObjectContext) {
    Todo.create(with: title, in: todoList, using: context)
  }
  
  override func delete(_ entity: Todo, using context: NSManagedObjectContext) {
    if entity.isDone {
      todoList.completedTodosCount -= 1
    }
    
    super.delete(entity, using: context)
  }
  
  func uncheckTodos(using context: NSManagedObjectContext) {
    TodoList.uncheckAllTodos(in: todoList, using: context)
  }
  
  func deleteTodos(using context: NSManagedObjectContext) {
    TodoList.deleteAllTodos(in: todoList, using: context)
  }
}
