//
//  TodoListMoreSheet.swift
//  WorkWork WatchOnly Watch App
//
//  Created by Zaid Neurothrone on 2023-01-21.
//

import SwiftUI
import WorkWorkKit

struct TodoListMoreSheet: View {
  @Environment(\.managedObjectContext) var moc
  @EnvironmentObject var appState: AppState
  
  @ObservedObject var viewModel: TodosViewModel
  
  var body: some View {
    VStack {
      Button(action: { viewModel.isTextFieldVisible.toggle() }) {
        CustomLabelView(
          text: viewModel.isTextFieldVisible
          ? "Hide Text Field"
          : "Show Text Field",
          systemImage: viewModel.isTextFieldVisible
          ? MyApp.SystemImage.circleSlash
          : MyApp.SystemImage.plusCircle,
          color: appState.selectedColor.color
        )
        .frame(maxWidth: .infinity, alignment: .leading)
      }
      
      Button(action: { viewModel.uncheckTodos(using: moc) }) {
        CustomLabelView(
          text: "Uncheck All Todos",
          systemImage: MyApp.SystemImage.uncheckAllTodos,
          color: appState.selectedColor.color
        )
        .frame(maxWidth: .infinity, alignment: .leading)
      }
      
      Button(action: { viewModel.deleteTodos(using: moc) }) {
        CustomLabelView(
          text: "Delete All Todos",
          systemImage: MyApp.SystemImage.deleteAllTodos,
          color: .red
        )
        .frame(maxWidth: .infinity, alignment: .leading)
      }
      
      Spacer()
    }
  }
}

struct TodoListMoreSheet_Previews: PreviewProvider {
  static var previews: some View {
    let context = CoreDataProvider.preview.viewContext
    let todoList = TodoList.Preview.generateSample(using: context)
    
    TodoListMoreSheet(viewModel: TodosViewModel(todoList: todoList))
      .environment(\.managedObjectContext, context)
      .environmentObject(AppState())
  }
}
