//
//  AllTodoListsScreen.swift
//  WorkWork WatchOnly Watch App
//
//  Created by Zaid Neurothrone on 2023-01-20.
//

import SwiftUI
import WorkWorkKit

struct TList: Identifiable, Hashable {
  let name: String
  let completedTodosCount: Int
  let todosCount: Int
  
  var id: String { name }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(name)
  }
}


struct AllTodoListsScreen: View {
  private enum Sheet: Identifiable {
    case add,
         edit(todoList: TList)
    
    var id: String {
      switch self {
      case .add:
        return "add"
      case .edit(_):
        return "edit"
      }
    }
  }
  
  @Environment(\.managedObjectContext) var moc
  @Environment(\.scenePhase) var scenePhase
  @EnvironmentObject var appState: AppState
  
  @FetchRequest(
    fetchRequest: TodoList.allByOrder(),
    animation: .default
  )
  private var todoLists: FetchedResults<TodoList>
  
  @SceneStorage(MyApp.SceneStorage.storedTodoListId)
  var storedTodoListId: String?
  
  @State private var sheet: Sheet? = nil
  @StateObject private var viewModel: TodoListViewModel = .init()
  
  var body: some View {
    NavigationStack(path: $appState.path) {
      list
        .navigationTitle("WorkWork")
        .onChange(of: scenePhase) { newScenePhase in
          if newScenePhase == .inactive {
            // Set stored id to nil if we are in TodoListsScreen
            if appState.path.isEmpty {
              storedTodoListId = nil
            }
            
            // Save the id of a TodoList if we have navigated to it
            if let selectedList = appState.path.first {
              storedTodoListId = selectedList.id
            }
          }
          
          // Navigate to a TodoList if there is an id stored in SceneStorage
          if newScenePhase == .active {
            if let listId = storedTodoListId,
               let list: TodoList = todoLists.first(where: { $0.id == listId }) {
              appState.path = [list]
            }
          }
        }
        .sheet(item: $sheet) { sheet in
          // TODO: add & edit sheets
        }
        .toolbar {
          ToolbarItemGroup(placement: .confirmationAction) {
            NavigationLink {
              SettingsScreen()
                .environmentObject(appState)
            } label: {
              CustomLabelView(
                text: "Settings",
                systemImage: MyApp.SystemImage.settings,
                color: appState.selectedColor.color,
                spacing: .zero
              )
            }
          }
        }
    }
  }
  
  private var list: some View {
    List {
      NavigationLink {
        // TODO: Add Folder Sheet
        Text("Add Folder")
      } label: {
        CustomLabelView(
          text: "Add Folder",
          systemImage: MyApp.SystemImage.showAddListTextField,
          color: appState.selectedColor.color
        )
      }
      
      Section {
        if todoLists.isEmpty {
          Text("No folders yet.")
            .foregroundColor(.secondary)
        } else {
          ForEach(todoLists) { todoList in
            NavigationLink(value: todoList) {
              TodoListRowView(
                todoList: todoList,
                onDelete: {
                  // NOTE: It is necessary to wrap deletion logic with NSManagedObjectContext.perform to prevent a race condition from causing a crash
                  moc.perform { viewModel.delete(todoList, using: moc) }
                },
                onEdit: {
                  viewModel.changeToEditingOf(todoList)
                })
            }
          }
          .onMove { source, destination in
            moc.perform {
              TodoList.moveEntities(todoLists, from: source, to: destination, using: moc)
            }
          }
        }
      } header: {
        SectionHeaderView(leftText: "Folders", rightText: "\(todoLists.count)")
      }
    }
    .listStyle(.plain)
    .navigationDestination(for: TodoList.self) { todoList in
      TodoListScreen(todoList: todoList)
    }
//    .scrollContentBackground(.hidden)
  }
}

struct AllTodoListsScreen_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      AllTodoListsScreen()
    }
    .environment(\.managedObjectContext, CoreDataProvider.preview.viewContext)
    .environmentObject(AppState())
    .preferredColorScheme(.dark)
  }
}
