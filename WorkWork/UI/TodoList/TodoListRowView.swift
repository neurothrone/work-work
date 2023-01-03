//
//  TodoListRowView.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import SwiftUI

struct TodoListRowView: View {
  @Environment(\.managedObjectContext) var moc
  
  @ObservedObject var todoList: TodoList
  
  let onDelete: () -> Void
  let onEdit: () -> Void
  
  var body: some View {
    content
      .contextMenu {
        Button(action: onEdit) {
          Label("Edit", systemImage: "pencil")
        }
      }
      .swipeActions(edge: .trailing, allowsFullSwipe: true) {
        Button(role: .destructive, action: onDelete) {
          Label("Delete", systemImage: "trash")
        }
      }
  }
  
  private var content: some View {
    HStack {
      Text(todoList.name)
    }
  }
}

struct TodoListRowView_Previews: PreviewProvider {
  static var previews: some View {
    let context = CoreDataProvider.preview.viewContext
    let todoList = TodoList.Preview.generateSample(using: context)
    
    return List {
      TodoListRowView(todoList: todoList, onDelete: {}, onEdit: {})
        .environment(\.managedObjectContext, context)
    }
    .listStyle(.grouped)
  }
}
