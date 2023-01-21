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
  
  @FocusState var isTextFieldFocused: Bool
  @State private var isMoreSheetPresented: Bool = false
  @State private var todoTitle: String = ""
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
  
  var body: some View {
    content
//      .background(
//        appState.prefersDarkMode
//        ? .black
//        : Color.gray.opacity(0.25)
//      )
      .onChange(of: viewModel.isTextFieldFocused) {
        isTextFieldFocused = $0
      }
      .navigationTitle(viewModel.todoList.title)
      .navigationBarTitleDisplayMode(.inline)
      .sheet(isPresented: $isMoreSheetPresented) {
        TodoListMoreSheet(viewModel: viewModel)
      }
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button {
            isMoreSheetPresented.toggle()
          } label: {
            CustomLabelView(
              text: "More",
              systemImage: MyApp.SystemImage.infoCircle,
              color: appState.selectedColor.color,
              spacing: 2
            )
          }
        }
      }
  }
  
  private var content: some View {
    List {
      if appState.showTodosProgressBar {
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
      }
      
      if viewModel.isTextFieldVisible {
        HStack {
          TextField("Todo title", text: $viewModel.title)
            .textFieldStyle(.plain)
            .focused($isTextFieldFocused)
          
          Button(action: { viewModel.addOrUpdate(using: moc) }) {
            Image(systemName: viewModel.actionMode == .edit
                  ? MyApp.SystemImage.editActionMode
                  : MyApp.SystemImage.plusCircle
            )
            .resizable()
            .frame(width: 44, height: 44)
            .foregroundColor(appState.selectedColor.color)
          }
          .buttonStyle(.plain)
          .disabled(!isValid)
          .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button {
              withAnimation(.linear) {
                viewModel.isTextFieldVisible = false
                viewModel.changeActionMode()
              }
            } label: {
              Label(
                "Hide Text Field",
                systemImage: MyApp.SystemImage.noActionMode
              )
            }
            .tint(appState.selectedColor.color.opacity(0.75))
          }
          .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            if viewModel.actionMode == .edit {
              Button(action: viewModel.changeActionMode) {
                Label(
                  "Change to Add Mode",
                  systemImage: MyApp.SystemImage.plusCircle
                )
              }
              .tint(appState.selectedColor.color.opacity(0.75))
            }
          }
        }
        .listRowBackground(EmptyView())
        .listRowInsets(EdgeInsets())
      }
        
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
                if !viewModel.isTextFieldVisible {
                  withAnimation(.linear) {
                    viewModel.isTextFieldVisible.toggle()
                  }
                }
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
      } header: {
        SectionHeaderView(leftText: "Todos", rightText: "\(todos.count)")
      }
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
//        .preferredColorScheme(.dark)
    }
  }
}
