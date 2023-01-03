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
    fetchRequest: TodoList.all,
    animation: .default
  )
  private var todoLists: FetchedResults<TodoList>
  
  var body: some View {
    NavigationStack {
      List {
        if todoLists.isEmpty {
          Text("No list yet.")
        } else {
          ForEach(todoLists) { todoList in
            Text(todoList.name)
          }
        }
      }
    }
  }
}

struct AllTodoListsScreen_Previews: PreviewProvider {
  static var previews: some View {
    AllTodoListsScreen()
      .environment(\.managedObjectContext, CoreDataProvider.preview.viewContext)
  }
}
