//
//  AllTodoListsScreen.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import SwiftUI

struct AllTodoListsScreen: View {
  @Environment(\.managedObjectContext) var moc
  @Environment(\.scenePhase) var scenePhase
  @EnvironmentObject var appState: AppState
  
  @FetchRequest(
    fetchRequest: TodoList.allByOrder(),
    animation: .default
  )
  private var todoLists: FetchedResults<TodoList>
  
  @FocusState var isTextFieldFocused: Bool
  @State private var isAddOrEditSheetPresented = false
  @StateObject private var viewModel: TodoListViewModel = .init()
  
  @SceneStorage(MyApp.SceneStorage.storedTodoListId)
  var storedTodoListId: String?
  
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
    NavigationStack(path: $appState.path) {
      content
        .background(
          appState.prefersDarkMode
          ? .black
          : Color.lightModeBackground
        )
        .navigationTitle("Folders")
        .sheet(isPresented: $isAddOrEditSheetPresented) {
#if DEBUG
          NavigationStack {
            AddOrEditTodoListSheet(todoListToUpdate: viewModel.selection ?? nil)
          }
#else
          AddOrEditTodoListSheet(todoListToUpdate: viewModel.selection ?? nil)
#endif
        }
        .onChange(of: viewModel.isTextFieldFocused) {
          isTextFieldFocused = $0
        }
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
        .toolbar {
          //MARK: Navigation Bar
          ToolbarItem(placement: .navigationBarTrailing) {
            NavigationLink {
              SettingsScreen()
                .environmentObject(appState)
            } label: {
              Label(
                "Settings",
                systemImage: MyApp.SystemImage.settings
              )
              .tint(appState.selectedColor.color)
            }
          }
          
          //MARK: Bottom Bar
          ToolbarItemGroup(placement: .bottomBar) {
            ZStack {
              Text("\(todoLists.count) Folders")
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
  }
  
  @ViewBuilder
  private var keyboard: some View {
    if appState.primaryButtonHandedness == .right {
      HStack {
        Button(role: .cancel) {
          // TODO: Temporary fix until root cause is discovered
          hideKeyboard()
          //              viewModel.isTextFieldFocused = false
          
          withAnimation(.linear) {
            viewModel.changeActionMode()
          }
        } label: {
          Label(
            "Dismiss",
            systemImage: MyApp.SystemImage.dismissKeyboard
          )
          .labelStyle(.titleAndIcon)
        }
        .buttonStyle(.bordered)
        
        Spacer()
        
        Button(action: { isAddOrEditSheetPresented.toggle() }) {
          Label(
            "More",
            systemImage: MyApp.SystemImage.moreOptionsAddList
          )
          .labelStyle(.titleAndIcon)
        }
        .buttonStyle(.borderedProminent)
        .tint(appState.selectedColor.color.opacity(0.5))
        
        Spacer()
        
        Button(action: { viewModel.addOrUpdate(using: moc) }) {
          Group {
            if viewModel.actionMode == .add {
              Label(
                "Add",
                systemImage: MyApp.SystemImage.quickAddList
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
                systemImage: MyApp.SystemImage.quickAddList
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
        
        Button(action: { isAddOrEditSheetPresented.toggle() }) {
          Label(
            "More",
            systemImage: MyApp.SystemImage.moreOptionsAddList
          )
          .labelStyle(.titleAndIcon)
        }
        .buttonStyle(.borderedProminent)
        .tint(appState.selectedColor.color.opacity(0.5))
        
        Spacer()
        
        Button(role: .cancel) {
          // TODO: Temporary fix until root cause is discovered
          hideKeyboard()
          //              viewModel.isTextFieldFocused = false
          
          withAnimation(.linear) {
            viewModel.changeActionMode()
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
      if viewModel.actionMode != nil {
        CustomTextFieldView(
          text: $viewModel.title,
          placeholder: "Folder Title"
        )
        .focused($isTextFieldFocused)
        .listRowSeparator(.hidden)
        .padding(.bottom)
      }
      
      if todoLists.isEmpty {
        Text("No list yet.")
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
    }
    .navigationDestination(for: TodoList.self) { todoList in
      TodoListScreen(todoList: todoList)
    }
    .scrollContentBackground(.hidden)
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
