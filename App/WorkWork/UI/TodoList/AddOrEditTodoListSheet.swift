//
//  AddOrEditTodoListSheet.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import SwiftUI
import WorkWorkKit

struct AddOrEditTodoListSheet: View {
  @Environment(\.dismiss) var dismiss
  @Environment(\.managedObjectContext) var moc
  @EnvironmentObject var appState: AppState
  
  @StateObject private var viewModel: AddOrEditTodoListViewModel
  
  init(todoListToUpdate: TodoList? = nil) {
    let vm = AddOrEditTodoListViewModel(todoList: todoListToUpdate)
    _viewModel = StateObject(wrappedValue: vm)
  }
  
  private let columns = [
    GridItem(
      .adaptive(minimum: 60),
      spacing: 20,
      alignment: .leading
    )
  ]
  
  private var isValid: Bool {
    if viewModel.title.isEmpty {
      return false
    }
    
    guard let todoListToUpdate = viewModel.todoList,
          let currentIcon = Icon(rawValue: todoListToUpdate.systemImage)
    else { return true }
    
    return todoListToUpdate.title != viewModel.title || currentIcon != viewModel.selectedIcon
  }
  
  var body: some View {
    content
      .navigationTitle("\(viewModel.actionText) Folder")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        //MARK: Navigation Bar
        ToolbarItem(placement: .navigationBarLeading) {
          Button("Cancel", role: .cancel, action: { dismiss() })
            .buttonStyle(.plain)
            .foregroundColor(.secondary)
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
          Button(viewModel.actionText, action: addOrUpdate)
            .disabled(!isValid)
            .tint(appState.selectedColor.color)
        }
        
        //MARK: Keyboard
        ToolbarItemGroup(placement: .keyboard) {
          Spacer()
          
          Button(role: .cancel) {
            // TODO: Temporary fix until root cause is discovered
            hideKeyboard()
            //              viewModel.isTextFieldFocused = false
          } label: {
            Label(
              "Dismiss",
              systemImage: MyApp.SystemImage.dismissKeyboard
            )
            .labelStyle(.titleAndIcon)
          }
          .buttonStyle(.bordered)
          .tint(appState.selectedColor.color)
        }
      }
  }
  
  private var content: some View {
    Form {
      CustomTextFieldView(
        text: $viewModel.title,
        placeholder: "Folder title"
      )
      .listRowInsets(EdgeInsets(
        top: 15,
        leading: 15,
        bottom: .zero,
        trailing: 15)
      )
      
      Section {
        LazyVGrid(columns: columns) {
          IconPickerView(
            selectedIcon: $viewModel.selectedIcon,
            selectionColor: appState.selectedColor.color
          )
        }
      } header: {
        Text("Select an icon")
      }
    }
  }
  
  private func addOrUpdate() {
    viewModel.addOrUpdate(using: moc)
    dismiss()
  }
}

struct AddOrEditTodoListSheet_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      AddOrEditTodoListSheet(todoListToUpdate: nil)
        .environment(\.managedObjectContext, CoreDataProvider.preview.viewContext)
        .environmentObject(AppState())
      //        .preferredColorScheme(.dark)
    }
  }
}
