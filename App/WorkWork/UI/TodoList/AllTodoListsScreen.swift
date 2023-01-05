//
//  AllTodoListsScreen.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import SwiftUI

struct AllTodoListsScreen: View {
  @Environment(\.managedObjectContext) var moc
  
  @AppStorage(MyApp.AppStorage.selectedColor)
  var selectedColor: CustomColor = .purple
  
  @FetchRequest(
    fetchRequest: TodoList.allByOrder(),
    animation: .default
  )
  private var todoLists: FetchedResults<TodoList>
  
  @State private var isAddSheetPresented = false
  @State private var title = ""
  
  @StateObject private var viewModel: TodoListViewModel = .init()
  @FocusState var isTextFieldFocused: Bool
  
  var body: some View {
    content
      .sheet(isPresented: $isAddSheetPresented) {
#if DEBUG
        NavigationStack {
          AddTodoListSheet()
        }
#else
        AddTodoListSheet()
#endif
      }
      .onChange(of: viewModel.isTextFieldFocused) {
        isTextFieldFocused = $0
      }
      .toolbar {
        //MARK: Navigation Bar
        ToolbarItem(placement: .navigationBarLeading) {
          Button {
            
          } label: {
            Label(
              "Settings",
              systemImage: MyApp.SystemImage.settings
            )
            .tint(selectedColor.color)
          }
        }
        
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
                    systemImage: MyApp.SystemImage.quickAdd
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
            
            if viewModel.actionMode == .add {
              Spacer()
              
              Button(action: {}) {
                Label(
                  "More",
                  systemImage: MyApp.SystemImage.moreOptionsAdd
                )
                .labelStyle(.titleAndIcon)
              }
              .buttonStyle(.borderedProminent)
              .tint(selectedColor.color.opacity(0.5))
            }
            
            Spacer()
            
            Button(role: .cancel) {
              viewModel.isTextFieldFocused = false
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
        HStack {
          TextField("Title", text: $viewModel.title)
            .autocorrectionDisabled(true)
            .textInputAutocapitalization(.sentences)
            .textFieldStyle(.roundedBorder)
            .focused($isTextFieldFocused)
            .submitLabel(.done)
            .onSubmit {
              viewModel.addOrUpdate(using: moc)
            }
        }
        .listRowSeparator(.hidden)
        .padding(.bottom)
      }
      
      
      if todoLists.isEmpty {
        Text("No list yet.")
      } else {
        ForEach(todoLists) { todoList in
          NavigationLink {
            TodoListScreen(todoList: todoList)
          } label: {
            TodoListRowView(
              todoList: todoList,
              onDelete: {
                // NOTE: It is necessary to wrap deletion logic with NSManagedObjectContext.perform to prevent a race condition from causing a crash
                moc.perform { todoList.delete(using: moc) }
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
    .listStyle(.insetGrouped)
    .scrollContentBackground(.hidden)
  }
}



struct AllTodoListsScreen_Previews: PreviewProvider {
  static var previews: some View {
    Screen.lists.view
      .environment(\.managedObjectContext, CoreDataProvider.preview.viewContext)
      .preferredColorScheme(.dark)
  }
}
