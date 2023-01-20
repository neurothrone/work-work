//
//  TodoListScreen.swift
//  WorkWork WatchOnly Watch App
//
//  Created by Zaid Neurothrone on 2023-01-20.
//

import SwiftUI
import WorkWorkKit

struct TodoListScreen: View {
  @Environment(\.managedObjectContext) var moc
  @EnvironmentObject var appState: AppState
  
  @FetchRequest private var todos: FetchedResults<Todo>
  
  @StateObject private var viewModel: TodosViewModel
  
  init(todoList: TodoList) {
    _todos = FetchRequest(
      fetchRequest: Todo.all(in: todoList),
      animation: .default
    )
    
    let vm = TodosViewModel(todoList: todoList)
    _viewModel = StateObject(wrappedValue: vm)
  }
  
  private var completedTodosCount: Int {
    todos.reduce(.zero) { $0 + ($1.isDone ? 1 : .zero) }
  }
  
  var body: some View {
    List {
      HStack {
        Text("Completed Todos")
          .foregroundColor(.secondary)

        Spacer()
        
        TodoProgressView(
          text: "Completed Todos",
          color: appState.selectedColor.color,
          value: Double(completedTodosCount),
          minValue: .zero,
          maxValue: Double(todos.count),
          style: .circular
        )
      }
      .listRowBackground(EmptyView())

      Section {
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
                //                viewModel.changeToEditingOf(todo)
              },
              onToggle: {
                Todo.toggleIsDone(for: todo, using: moc)
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
    }
    .listStyle(.plain)
    .navigationTitle(viewModel.todoList.title)
    .navigationBarTitleDisplayMode(.inline)
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
