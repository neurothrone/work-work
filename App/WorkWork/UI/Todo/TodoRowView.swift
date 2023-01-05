//
//  TodoRowView.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import SwiftUI

struct TodoRowView: View {
  @Environment(\.managedObjectContext) var moc
  
  @ObservedObject var todo: Todo
  
  let onDelete: () -> Void
  let onEdit: () -> Void
  let onToggle: () -> Void
  
  var body: some View {
    content
      .swipeActions(edge: .leading, allowsFullSwipe: true) {
        Button(action: onToggle) {
          Label("Toggle", systemImage: todo.isDone
                ? "x.circle"
                : "checkmark.circle.fill")
        }
        .tint(todo.isDone
              ? .purple.opacity(0.75)
              : .purple)
        
      }
      .swipeActions(edge: .trailing, allowsFullSwipe: true) {
        Button(role: .destructive, action: onDelete) {
          Label("Delete", systemImage: "trash")
        }
        Button(action: onEdit) {
          Label("Edit", systemImage: "pencil")
        }
        .tint(.mint)
      }
  }
  
  private var content: some View {
    HStack {
      Button(action: onToggle) {
        Image(systemName: todo.isDone
              ? "checkmark.circle.fill"
              : "circle"
        )
        .foregroundColor(.purple)
        .imageScale(.large)
      }
      .buttonStyle(.plain)
      
      Text(todo.title)
    }
  }
}

struct TodoRowView_Previews: PreviewProvider {
  static var previews: some View {
    let context = CoreDataProvider.preview.viewContext
    let todo = Todo.Preview.generateSample(using: context)
    
    return List {
      TodoRowView(todo: todo, onDelete: {}, onEdit: {}, onToggle: {})
        .environment(\.managedObjectContext, context)
    }
    .listStyle(.grouped)
  }
}
