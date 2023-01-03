//
//  TodoListScreen.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import SwiftUI

struct TodoListScreen: View {
  private enum TodoMode {
    case add,
         edit
  }
  
  @Environment(\.managedObjectContext) var moc
  
  @FetchRequest private var todos: FetchedResults<Todo>
  
  @ObservedObject var todoList: TodoList
  
  @FocusState private var isTextFieldFocused: Bool
  @State private var todoTitle = ""
  @State private var selectedTodo: Todo? = nil
  @State private var activeTodoMode: TodoMode? = nil
  
  init(todoList: TodoList) {
    self.todoList = todoList
    
    _todos = FetchRequest(
      fetchRequest: Todo.all(in: todoList),
      animation: .default
    )
  }
  
  private var activeModeSystemName: String {
    switch activeTodoMode {
    case .add:
      return "plus.circle"
    case .edit:
      return "pencil.circle"
    default:
      return "circle.slash"
    }
  }
  
  var body: some View {
    NavigationStack {
      content
        .navigationTitle(todoList.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: changeTodoMode) {
              Image(systemName: activeModeSystemName)
            }
          }
        }
    }
  }
  
  private var content: some View {
    List {
      if activeTodoMode != nil {
        TextField("Todo title", text: $todoTitle)
          .autocorrectionDisabled(true)
          .textInputAutocapitalization(.sentences)
          .textFieldStyle(.roundedBorder)
          .focused($isTextFieldFocused)
          .listRowSeparator(.hidden)
          .padding(.bottom)
      }
      
      if todos.isEmpty {
        Text("No todos yet.")
      } else {
        ForEach(todos) { todo in
          if todo != selectedTodo {
            TodoRowView(
              todo: todo,
              onDelete: {
                // NOTE: It is necessary to wrap deletion logic with NSManagedObjectContext.perform to prevent a race condition from causing a crash
                moc.perform { todo.delete(using: moc) }
              },
              onEdit: {
                changeViewToEditingTodo(todo)
              },
              onToggle: {
                Todo.toggleIsDone(for: todo, using: moc)
              })
          }
        }
      }
    }
    .listStyle(.grouped)
  }
  
  private func changeTodoMode() {
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
  
  private func changeViewToEditingTodo(_ todo: Todo) {
    activeTodoMode = .edit
    todoTitle = todo.title
    selectedTodo = todo
  }
}

struct TodoListScreen_Previews: PreviewProvider {
  static var previews: some View {
    let context = CoreDataProvider.preview.viewContext
    let todoList = TodoList.Preview.generateSample(using: context)
    
    return TodoListScreen(todoList: todoList)
      .environment(\.managedObjectContext, context)
  }
}
