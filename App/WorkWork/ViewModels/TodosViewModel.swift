//
//  TodosViewModel.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-05.
//

import CoreData
import SwiftUI

//final class TodosViewModel: BaseViewModel<Todo> {
//  let todoList: TodoList
//  
//  init(todoList: TodoList) {
//    self.todoList = todoList
//  }
//
//  override func createEntity(using context: NSManagedObjectContext) {
//    Todo.create(with: title, in: todoList, using: context)
//  }
//}

final class TodosViewModel: ObservableObject {
  enum TodoMode {
    case add,
         edit
  }

  @Published var isTextFieldFocused: Bool = false
  @Published var todoTitle = ""
  @Published var selectedTodo: Todo? = nil
  @Published var activeTodoMode: TodoMode? = nil

  let todoList: TodoList

  init(todoList: TodoList) {
    self.todoList = todoList
  }

  var activeModeSystemName: String {
    switch activeTodoMode {
    case .add:
      return "plus.circle"
    case .edit:
      return "pencil.circle"
    default:
      return "circle.slash"
    }
  }

  func changeTodoMode() {
    withAnimation(.linear) {
      switch activeTodoMode {
      case .add:
        isTextFieldFocused = false
        activeTodoMode = nil
      case .edit:
        isTextFieldFocused = false
        todoTitle = ""
        selectedTodo = nil
        activeTodoMode = nil
      case nil:
        activeTodoMode = .add
      }
    }
  }

  func changeViewToEditingTodo(_ todo: Todo) {
    activeTodoMode = .edit
    todoTitle = todo.title
    selectedTodo = todo
  }

  func addOrUpdateTodo(using context: NSManagedObjectContext) {
    if let selectedTodo {
      selectedTodo.title = todoTitle
      selectedTodo.save(using: context)

      withAnimation(.linear) {
        self.selectedTodo = nil
        activeTodoMode = nil
      }
    } else {
      Todo.create(with: todoTitle, in: todoList, using: context)

      withAnimation(.linear) {
        isTextFieldFocused = true
      }
    }

    withAnimation(.linear) {
      todoTitle = ""
    }
  }

  func deleteTodo(_ todo: Todo, using context: NSManagedObjectContext) {
    withAnimation {
      todo.delete(using: context)
    }

    guard activeTodoMode == .edit else { return }

    withAnimation(.linear) {
      todoTitle = ""
      activeTodoMode = nil
    }
  }
}
