//
//  AllTodoListsScreen.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import SwiftUI

struct AllTodoListsScreen: View {
  @Environment(\.managedObjectContext) var moc
  @EnvironmentObject var appState: AppState
  
  @FetchRequest(
    fetchRequest: TodoList.allByOrder(),
    animation: .default
  )
  private var todoLists: FetchedResults<TodoList>
  
  @FocusState var isTextFieldFocused: Bool
  @State private var isAddOrEditSheetPresented = false
  @StateObject private var viewModel: TodoListViewModel = .init()
  
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
      .toolbar {
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
            .frame(maxWidth: .infinity, alignment: .trailing)
          }
        }
        
        //MARK: Keyboard
        ToolbarItemGroup(placement: .keyboard) {
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
          .tint(appState.selectedColor.color)
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
          NavigationLink {
            TodoListScreen(todoList: todoList)
          } label: {
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
