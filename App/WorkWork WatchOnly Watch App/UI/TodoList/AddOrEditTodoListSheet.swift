//
//  AddOrEditTodoListSheet.swift
//  WorkWork WatchOnly Watch App
//
//  Created by Zaid Neurothrone on 2023-01-20.
//

import SwiftUI
import WorkWorkKit

struct AddOrEditTodoListSheet: View {
  @Environment(\.dismiss) var dismiss
  @Environment(\.managedObjectContext) var moc
  @EnvironmentObject var appState: AppState
  
  @State private var isIconPickerPresented: Bool = false
  @StateObject private var viewModel: AddOrEditTodoListViewModel
  
  init(todoListToUpdate: TodoList? = nil) {
    let vm = AddOrEditTodoListViewModel(todoList: todoListToUpdate)
    _viewModel = StateObject(wrappedValue: vm)
  }
  
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
      .sheet(isPresented: $isIconPickerPresented) {
        WatchIconPickerView(viewModel: viewModel)
          .environmentObject(appState)
      }
      .toolbar {
        //MARK: Navigation Bar
        ToolbarItem(placement: .confirmationAction) {
          Button("Cancel", role: .cancel, action: { dismiss() })
            .buttonStyle(.plain)
            .foregroundColor(.secondary)
        }
      }
  }
  
  private var content: some View {
    Form {
      TextField("Folder title", text: $viewModel.title)
        .autocorrectionDisabled(true)
        .textInputAutocapitalization(.sentences)
        .padding(.bottom)
        .listRowInsets(EdgeInsets())
        .listRowBackground(EmptyView())
        .textFieldStyle(.plain)
      
      Button {
        isIconPickerPresented.toggle()
      } label: {
        HStack {
          Text("Select an icon")
          Spacer()
          Image(systemName: viewModel.selectedIcon.rawValue)
            .foregroundColor(appState.selectedColor.color)
            .imageScale(.large)
        }
      }
      
      Button(viewModel.actionText, action: addOrUpdate)
        .disabled(!isValid)
        .buttonStyle(.borderedProminent)
        .listRowInsets(EdgeInsets())
        .listRowBackground(EmptyView())
        .padding(.top)
        .tint(appState.selectedColor.color.opacity(0.75))
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
    }
  }
}

