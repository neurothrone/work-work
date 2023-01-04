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
      content
        .navigationTitle(todoList.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
          ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            Button("Dismiss", action: { isTextFieldFocused = false })
          }
          
          ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: changeTodoMode) {
              Image(systemName: activeModeSystemName)
                .imageScale(.large)
                .foregroundColor(.purple)
            }
          }
        }
  }
  
  private var content: some View {
    List {
      if activeTodoMode != nil {
        HStack {
          TextField("Todo title", text: $todoTitle)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.sentences)
            .textFieldStyle(.roundedBorder)
            .focused($isTextFieldFocused)
            .submitLabel(.done)
            .onSubmit(addOrUpdateTodo)
          
          Button(action: addOrUpdateTodo) {
            Text(activeTodoMode == .add ? "Add" : "Update")
          }
          .buttonStyle(.borderedProminent)
          .disabled(todoTitle.isEmpty)
          .tint(.purple)
        }
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
                moc.perform { deleteTodo(todo) }
              },
              onEdit: {
                changeViewToEditingTodo(todo)
              },
              onToggle: {
                Todo.toggleIsDone(for: todo, using: moc)
              })
          }
        }
        .onMove { source, destination in
          Todo.move(elements: Array(todos), from: source, to: destination, using: moc)
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
  
  private func addOrUpdateTodo() {
    if let selectedTodo {
      selectedTodo.title = todoTitle
      selectedTodo.save(using: moc)
      
      withAnimation(.linear) {
        self.selectedTodo = nil
        activeTodoMode = nil
      }
    } else {
      Todo.create(with: todoTitle, in: todoList, using: moc)
      
      withAnimation(.linear) {
        isTextFieldFocused = true
      }
    }
    
    withAnimation(.linear) {
      todoTitle = ""
    }
  }
  
  private func deleteTodo(_ todo: Todo) {
    withAnimation {
      todo.delete(using: moc)
    }
    
    guard activeTodoMode == .edit else { return }
    
    withAnimation(.linear) {
      todoTitle = ""
      activeTodoMode = nil
    }
  }
}

struct TodoListScreen_Previews: PreviewProvider {
  static var previews: some View {
    let context = CoreDataProvider.preview.viewContext
    let todoList = TodoList.Preview.generateSample(using: context)
    
    return NavigationStack {
      TodoListScreen(todoList: todoList)
        .environment(\.managedObjectContext, context)
    }
  }
}
