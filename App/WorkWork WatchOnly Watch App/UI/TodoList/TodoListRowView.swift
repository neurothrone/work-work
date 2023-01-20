//
//  TodoListRowView.swift
//  WorkWork WatchOnly Watch App
//
//  Created by Zaid Neurothrone on 2023-01-20.
//

import SwiftUI

import SwiftUI
import WorkWorkKit

struct TodoListRowView: View {
  @Environment(\.managedObjectContext) var moc
  @EnvironmentObject var appState: AppState
  
  @ObservedObject var todoList: TodoList
  
  let onDelete: () -> Void
  let onEdit: () -> Void
  
  var body: some View {
    content
      .swipeActions(edge: .trailing, allowsFullSwipe: true) {
        Button(role: .destructive, action: onDelete) {
          Label("Delete", systemImage: MyApp.SystemImage.delete)
        }
        .tint(.red)
        
        Button(action: onEdit) {
          Label("Edit", systemImage: MyApp.SystemImage.edit)
        }
        .tint(appState.selectedColor.color.opacity(0.75))
      }
  }
  
  private var content: some View {
    HStack {
      Image(systemName: !todoList.isFault
            ? todoList.systemImage
            : Icon.default.rawValue
      )
      .foregroundColor(appState.selectedColor.color)
      
      Text(todoList.title)
        .lineLimit(1)

      if todoList.todos.isNotEmpty {
        Spacer()
        Text(todoList.completedTodosCount == .zero
             ? "\(todoList.todosCount)"
             : "\(todoList.completedTodosCount) / \(todoList.todosCount)"
        )
        .foregroundColor(.primary.opacity(0.8))
      }
    }
  }
}

struct TodoListRowView_Previews: PreviewProvider {
  static var previews: some View {
    let context = CoreDataProvider.preview.viewContext
    let todoList = TodoList.Preview.generateSample(using: context)
    
    return List {
      TodoListRowView(
        todoList: todoList,
        onDelete: {},
        onEdit: {}
      )
      .environment(\.managedObjectContext, context)
      .environmentObject(AppState())
    }
    .listStyle(.plain)
  }
}
