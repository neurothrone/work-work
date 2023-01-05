//
//  TodoListScreen.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import SwiftUI

struct TodoListScreen: View {
  @AppStorage(MyApp.AppStorage.selectedColor)
  var selectedColor: CustomColor = .purple
  
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
        //MARK: Bottom Bar
        ToolbarItemGroup(placement: .bottomBar) {
          Button(action: viewModel.changeActionMode) {
            Label(
              viewModel.activeModeText,
              systemImage: viewModel.activeModeSystemName
            )
          }
          .tint(selectedColor.color)
          
          Spacer()
        }
        
        //MARK: Keyboard
        ToolbarItemGroup(placement: .keyboard) {
          HStack {
            Button(action: { viewModel.addOrUpdate(using: moc) }) {
              Group {
                if viewModel.actionMode == .add {
                  Label(
                    "Add",
                    systemImage: MyApp.SystemImage.showAddTodoTextField
                  )
                } else {
                  Label(
                    "Update",
                    systemImage: MyApp.SystemImage.editActionMode
                  )
                }
              }
              .labelStyle(.titleAndIcon)
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
            
            Button(role: .cancel) {
              // TODO: Temporary fix until root cause is discovered
              hideKeyboard()
//              viewModel.isTextFieldFocused = false
            } label: {
              Label(
                "Dismiss",
                systemImage: MyApp.SystemImage.dismissKeyboard
              )
              .labelStyle(.titleAndIcon)
            }
            .buttonStyle(.bordered)
          }
          .tint(selectedColor.color)
        }
      }
  }
  
  private var content: some View {
    List {
      if viewModel.actionMode != nil {
        CustomTextField(
          text: $viewModel.title,
          placeholder: "Todo Title",
          onSubmit: {
            viewModel.addOrUpdate(using: moc)
          }
        )
        .focused($isTextFieldFocused)
        .listRowSeparator(.hidden)
        .padding(.bottom)
      }
      
      if todos.isEmpty {
        Text("No todos yet.")
      } else {
        ForEach(todos) { todo in
          TodoRowView(
            todo: todo,
            onDelete: {
              // NOTE: It is necessary to wrap deletion logic with NSManagedObjectContext.perform to prevent a race condition from causing a crash
              moc.perform { viewModel.delete(todo, using: moc) }
            },
            onEdit: {
              viewModel.changeToEditingOf(todo)
            },
            onToggle: {
              Todo.toggleIsDone(for: todo, using: moc)
            })
        }
        .onMove { source, destination in
          moc.perform {
            Todo.moveEntities(todos, from: source, to: destination, using: moc)
          }
        }
      }
    }
    .listStyle(.insetGrouped)
    .scrollContentBackground(.hidden)
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
        .preferredColorScheme(.dark)
    }
  }
}
