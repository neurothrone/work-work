//
//  AllTodoListsScreen.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import SwiftUI

struct AllTodoListsScreen: View {
  @Environment(\.managedObjectContext) var moc

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
        ToolbarItemGroup(placement: .bottomBar) {
          Button {
            isAddSheetPresented.toggle()
          } label: {
            Label("Add", systemImage: "folder.badge.plus")
          }
          
          Spacer()
        }
        
        ToolbarItemGroup(placement: .keyboard) {
          HStack {
            Button(action: {}) {
              Label("Add", systemImage: "folder.fill.badge.plus")
                .labelStyle(.titleAndIcon)
            }
            .buttonStyle(.borderedProminent)
            .tint(.purple)
            
            Spacer()
            
            Button(action: {}) {
              Label("More", systemImage: "square.grid.3x1.folder.fill.badge.plus")
                .labelStyle(.titleAndIcon)
            }
            .buttonStyle(.bordered)
            .tint(.purple)
            
            Spacer()
            
            Button(action: {}) {
              Label("Dismiss", systemImage: "keyboard.chevron.compact.down.fill")
                .labelStyle(.titleAndIcon)
            }
            .buttonStyle(.bordered)
          }
        }
        
        ToolbarItem(placement: .navigationBarLeading) {
          Button {
            
          } label: {
            Label("Settings", systemImage: "gear")
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
