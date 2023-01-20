//
//  AddOrEditTodoListViewModel.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-09.
//

import CoreData
import Foundation
import WorkWorkKit

final class AddOrEditTodoListViewModel: ObservableObject {
  @Published var title: String = ""
  @Published var selectedIcon: Icon = .default
  @Published var todoList: TodoList?
  
  let actionText: String
  
  init(todoList: TodoList? = nil) {
    self.todoList = todoList
    
    if let todoListToUpdate = todoList {
      actionText = "Update"
      
      title = todoListToUpdate.title
      selectedIcon = Icon(rawValue: todoListToUpdate.systemImage) ?? .default
    } else {
      actionText = "Add"
    }
  }
  
  func addOrUpdate(using context: NSManagedObjectContext) {
    if let todoListToUpdate = todoList {
      TodoList.update(
        list: todoListToUpdate,
        with: title,
        newIcon: selectedIcon,
        using: context
      )
    } else {
      _ = TodoList.create(with: title, icon: selectedIcon, using: context)
    }
  }
}
