//
//  TodoListScreen.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import SwiftUI
import WorkWorkKit

struct TodoListScreen: View {
  @Environment(\.managedObjectContext) var moc
  @EnvironmentObject var appState: AppState
  
  @FetchRequest private var todos: FetchedResults<Todo>
  
  @FocusState var isTextFieldFocused: Bool
  @StateObject private var viewModel: TodosViewModel
  
  init(todoList: TodoList) {
    _todos = FetchRequest(
      fetchRequest: Todo.allByOrder(in: todoList),
      animation: .default
    )
    
    let vm = TodosViewModel(todoList: todoList)
    _viewModel = StateObject(wrappedValue: vm)
  }
  
  private var isValid: Bool {
    if viewModel.title.isEmpty {
      return false
    }
    
    if let selection = viewModel.selection,
       viewModel.actionMode == .edit,
       viewModel.title == selection.title {
      return false
    }
    
    return true
  }
  
  private var completedTodosCount: Int {
    todos.reduce(.zero) { $0 + ($1.isDone ? 1 : .zero) }
  }
  
  var body: some View {
    content
      .background(
        appState.prefersDarkMode
        ? .black
        : Color.lightModeBackground
      )
      .navigationTitle(viewModel.todoList.title)
      .onChange(of: viewModel.isTextFieldFocused) {
        isTextFieldFocused = $0
      }
      .toolbar {
        //MARK: Navigation Bar
        ToolbarItemGroup(placement: .navigationBarTrailing) {
          Menu {
            Button(action: { viewModel.uncheckTodos(using: moc) }) {
              Label(
                "Uncheck all Todos",
                systemImage: MyApp.SystemImage.uncheckAllTodos
              )
            }
            
            Button(
              role: .destructive,
              action: { viewModel.deleteTodos(using: moc) }) {
                Label(
                  "Delete all Todos",
                  systemImage: MyApp.SystemImage.deleteAllTodos
                )
              }
          } label: {
            Label(
              "More",
              systemImage: MyApp.SystemImage.moreOptions
            )
            .foregroundColor(appState.selectedColor.color)
          }
        }
        
        //MARK: Bottom Bar
        ToolbarItemGroup(placement: .bottomBar) {
          ZStack {
            Text("\(todos.count) Todos")
              .font(.callout.bold())
              .foregroundColor(.secondary)
              .frame(maxWidth: .infinity, alignment: .center)
            
            Button(action: viewModel.changeActionMode) {
              Label(
                viewModel.activeModeText,
                systemImage: viewModel.activeModeSystemName
              )
            }
            .tint(appState.selectedColor.color)
            .frame(
              maxWidth: .infinity,
              alignment: appState.primaryButtonHandedness == .right
              ? .trailing
              : .leading
            )
          }
        }        
        
        //MARK: Keyboard
        ToolbarItemGroup(placement: .keyboard) {
          keyboard
            .tint(appState.selectedColor.color)
        }
      }
  }
  
  @ViewBuilder
  private var keyboard: some View {
    if appState.primaryButtonHandedness == .right {
      HStack {
        Button(role: .cancel, action: dismissKeyboard) {
          Label(
            "Dismiss",
            systemImage: MyApp.SystemImage.dismissKeyboard
          )
          .labelStyle(.titleAndIcon)
        }
        .buttonStyle(.bordered)
        
        Spacer()
        
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
        .disabled(!isValid)
      }
    } else {
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
        .disabled(!isValid)
        
        Spacer()
        
        Button(role: .cancel) {
          // TODO: Temporary fix until root cause is discovered
          dismissKeyboard()
//              viewModel.isTextFieldFocused = false
          
          withAnimation(.linear) {
            viewModel.actionMode = nil
          }
        } label: {
          Label(
            "Dismiss",
            systemImage: MyApp.SystemImage.dismissKeyboard
          )
          .labelStyle(.titleAndIcon)
        }
        .buttonStyle(.bordered)
      }
    }
  }
  
  @ViewBuilder
  private var content: some View {
    if appState.listStyle == .insetGrouped {
      list
        .listStyle(.insetGrouped)
    } else {
      list
        .listStyle(.grouped)
    }
  }
  
  private var list: some View {
    List {
      if appState.showTodosProgressBar {
        TodoProgressView(
          text: "Todos Progress",
          color: appState.selectedColor.color,
          value: Double(completedTodosCount),
          minValue: .zero,
          maxValue: Double(viewModel.todoList.todosCount),
          style: appState.todosProgressBarStyle
        )
        .frame(maxWidth: .infinity, alignment: .center)
      }
      
      if viewModel.actionMode != nil {
        CustomTextFieldView(
          text: $viewModel.title,
          placeholder: "Todo title"
        )
        .focused($isTextFieldFocused)
        .padding(.bottom)
        .onSubmit {
          dismissKeyboard()
        }
      }
      
      if todos.isEmpty {
        Text("No todos yet.")
          .foregroundColor(.secondary)
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
              
              if todo.isDone && appState.deleteCompletedTodos {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                  moc.perform { viewModel.delete(todo, using: moc) }
                }
              }
            })
          .padding(
            .vertical,
            CGFloat(appState.todoRowVerticalPadding)
          )
        }
        .onMove { source, destination in
          moc.perform {
            Todo.moveEntities(todos, from: source, to: destination, using: moc)
          }
        }
      }
    }
    .scrollContentBackground(.hidden)
    // NOTE: one-line fix for slow SwiftUI lists. Trade-off is gain in speed for loss in animation
    //    .id(UUID())
  }
}

extension TodoListScreen {
  private func dismissKeyboard() {
    // TODO: Temporary fix until root cause is discovered
    self.hideKeyboard()
//              viewModel.isTextFieldFocused = false
    
    withAnimation(.linear) {
      viewModel.actionMode = nil
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
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
    }
  }
}
