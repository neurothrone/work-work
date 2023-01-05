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
          Button {
            isAddSheetPresented.toggle()
          } label: {
            Label(
              "Add",
              systemImage: MyApp.SystemImage.showAddListTextField
            )
            .tint(selectedColor.color)
          }
          
          Spacer()
        }
        
        //MARK: Keyboard
        ToolbarItemGroup(placement: .keyboard) {
          HStack {
            Button(action: {}) {
              Label(
                "Add",
                systemImage: MyApp.SystemImage.quickAdd
              )
              .labelStyle(.titleAndIcon)
            }
            .buttonStyle(.borderedProminent)
            .tint(selectedColor.color)
            
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
            
            Spacer()
            
            Button(role: .cancel, action: {}) {
              Label(
                "Dismiss",
                systemImage: MyApp.SystemImage.dismissKeyboard
              )
              .labelStyle(.titleAndIcon)
            }
            .buttonStyle(.bordered)
            .tint(selectedColor.color)
          }
        }
      }
  }
  
  private var content: some View {
    List {
      TextField("List title", text: $title)
        .autocorrectionDisabled(true)
        .textInputAutocapitalization(.sentences)
        .textFieldStyle(.roundedBorder)
      //          .focused($isTextFieldFocused)
        .submitLabel(.done)
        .onSubmit {
          _ = TodoList.createWith(title, using: moc)
        }
        .padding(.bottom)
        .listRowSeparator(.hidden)
        .scrollDisabled(true)
      
      
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
                
              })
          }
        }
        .onMove { source, destination in
          TodoList.moveEntities(todoLists, from: source, to: destination, using: moc)
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
