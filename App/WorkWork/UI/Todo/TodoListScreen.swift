//
//  TodoListScreen.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import SwiftUI

struct TodoListScreen: View {
  @Environment(\.managedObjectContext) var moc
  @FetchRequest private var todos: FetchedResults<Todo>
  
  @FocusState var isTextFieldFocused: Bool
  @StateObject private var viewModel: TodosViewModel
  
  init(todoList: TodoList) {
    _todos = FetchRequest(
      fetchRequest: Todo.all(in: todoList),
      animation: .default
    )
    
    let vm = TodosViewModel(todoList: todoList)
    _viewModel = StateObject(wrappedValue: vm)
  }
  
  var body: some View {
    content
      .navigationTitle(viewModel.todoList.title)
      .navigationBarTitleDisplayMode(.inline)
      .onChange(of: viewModel.isTextFieldFocused) {
        isTextFieldFocused = $0
      }
      .toolbar {
        ToolbarItemGroup(placement: .keyboard) {
          Spacer()
          Button("Dismiss", action: { viewModel.isTextFieldFocused = false })
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(action: viewModel.changeTodoMode) {
            Image(systemName: viewModel.activeModeSystemName)
              .imageScale(.large)
              .foregroundColor(.purple)
          }
        }
      }
  }
  
  private var content: some View {
    List {
      if viewModel.activeTodoMode != nil {
        HStack {
          TextField("Todo title", text: $viewModel.todoTitle)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.sentences)
            .textFieldStyle(.roundedBorder)
            .focused($isTextFieldFocused)
            .submitLabel(.done)
            .onSubmit {
              viewModel.addOrUpdateTodo(using: moc)
            }
          
          Button(action: { viewModel.addOrUpdateTodo(using: moc) }) {
            Text(viewModel.activeTodoMode == .add ? "Add" : "Update")
          }
          .buttonStyle(.borderedProminent)
          .disabled(viewModel.todoTitle.isEmpty)
          .tint(.purple)
        }
        .listRowSeparator(.hidden)
        .padding(.bottom)
      }
      
      if todos.isEmpty {
        Text("No todos yet.")
      } else {
        ForEach(todos) { todo in
          if todo != viewModel.selectedTodo {
            TodoRowView(
              todo: todo,
              onDelete: {
                // NOTE: It is necessary to wrap deletion logic with NSManagedObjectContext.perform to prevent a race condition from causing a crash
                moc.perform { viewModel.deleteTodo(todo, using: moc) }
              },
              onEdit: {
                viewModel.changeViewToEditingTodo(todo)
              },
              onToggle: {
                Todo.toggleIsDone(for: todo, using: moc)
              })
          }
        }
        .onMove { source, destination in
          moc.perform {
            Todo.moveEntities(todos, from: source, to: destination, using: moc)
          }
        }
      }
    }
    .listStyle(.grouped)
    // NOTE: one-line fix for slow SwiftUI lists. Trade-off is gain in speed for loss in animation
    //    .id(UUID())
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
