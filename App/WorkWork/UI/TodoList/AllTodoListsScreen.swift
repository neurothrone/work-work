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
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            isAddSheetPresented.toggle()
          } label: {
            Label("Add", systemImage: "note.text.badge.plus")
          }
        }
      }
  }
  
  private var content: some View {
    List {
      HStack {
        TextField("List title", text: $title)
          .autocorrectionDisabled(true)
          .textInputAutocapitalization(.sentences)
          .textFieldStyle(.roundedBorder)
//          .focused($isTextFieldFocused)
          .submitLabel(.done)
          .onSubmit {
            _ = TodoList.createWith(title, using: moc)
          }
//          .onSubmit(addOrUpdateTodo)
        
//        Button(action: addOrUpdateTodo) {
//          Text(activeTodoMode == .add ? "Add" : "Update")
//        }
//        .buttonStyle(.borderedProminent)
//        .disabled(title.isEmpty)
//        .tint(.purple)
      }
      .listRowSeparator(.hidden)
      .padding(.bottom)
      
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
    .listStyle(.grouped)
  }
}



struct AllTodoListsScreen_Previews: PreviewProvider {
  static var previews: some View {
    Screen.lists.view
      .environment(\.managedObjectContext, CoreDataProvider.preview.viewContext)
  }
}
