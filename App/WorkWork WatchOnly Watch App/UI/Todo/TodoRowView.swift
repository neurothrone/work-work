//
//  TodoRowView.swift
//  WorkWork WatchOnly Watch App
//
//  Created by Zaid Neurothrone on 2023-01-20.
//

import SwiftUI
import WorkWorkKit

struct TodoRowView: View {
  @Environment(\.managedObjectContext) var moc
  @EnvironmentObject var appState: AppState
  
  @ObservedObject var todo: Todo
  
  let onDelete: () -> Void
  let onEdit: () -> Void
  let onToggle: () -> Void
  
  var body: some View {
    content
      .swipeActions(edge: .leading, allowsFullSwipe: true) {
        if appState.todoCompletionStyle != .tapOnly {
          Button(action: onToggle) {
            Label("Toggle", systemImage: todo.isDone
                  ? MyApp.SystemImage.todoIsNotDone
                  : MyApp.SystemImage.todoIsDone)
          }
          .tint(appState.selectedColor.color.opacity(0.5))
        }
      }
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
  
  @ViewBuilder
  private var content: some View {
    if appState.todoCompletionStyle == .swipeOnly && todo.isDone {
      row
        .animation(.spring(), value: todo.isDone)
        .listRowBackground(
          RoundedRectangle(cornerRadius: 10)
            .fill(appState.selectedColor.color.opacity(0.4))
        )
    } else {
      row
    }
  }
  
  private var row: some View {
    HStack {
      if appState.todoCompletionStyle != .swipeOnly {
        Button(action: onToggle) {
          Image(systemName: todo.isDone
                ? MyApp.SystemImage.todoIsDone
                : MyApp.SystemImage.circle
          )
          .foregroundColor(appState.selectedColor.color)
          .imageScale(.large)
        }
        .buttonStyle(.plain)
      }
      
      Text(todo.title)
        .lineLimit(1)
    }
  }
}

struct TodoRowView_Previews: PreviewProvider {
  static var previews: some View {
    let context = CoreDataProvider.preview.viewContext
    let todo = Todo.Preview.generateSample(using: context)

    return List {
      TodoRowView(
        todo: todo,
        onDelete: {},
        onEdit: {},
        onToggle: {}
      )
      .environment(\.managedObjectContext, context)
      .environmentObject(AppState())
    }
    .listStyle(.plain)
  }
}
