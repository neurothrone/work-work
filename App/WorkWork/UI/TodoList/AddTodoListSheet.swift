//
//  AddTodoListSheet.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import SwiftUI

struct AddTodoListSheet: View {
  @Environment(\.dismiss) var dismiss
  @Environment(\.managedObjectContext) var moc
  @EnvironmentObject var appState: AppState
  
  @State private var title = ""
  @State private var selectedIcon: Icon = .default
  
  private let columns = [
    GridItem(
      .adaptive(minimum: 60),
      spacing: 20,
      alignment: .leading
    )
  ]
  
  var body: some View {
    content
      .navigationTitle("Add Folder")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button("Cancel", role: .cancel, action: { dismiss() })
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Add") {
            _ = TodoList.create(with: title, using: moc)
            dismiss()
          }
          .disabled(title.isEmpty)
          .tint(appState.selectedColor.color)
        }
      }
  }
  
  private var content: some View {
    Form {
      CustomTextFieldView(
        text: $title,
        placeholder: "Folder title",
        onSubmit: { /* hideKeyboard() */ }
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
            selectedIcon: $selectedIcon,
            selectionColor: appState.selectedColor.color
          )
        }
      } header: {
        Text("Select an icon")
      }
    }
  }
}

struct AddTodoListSheet_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      AddTodoListSheet()
        .environment(\.managedObjectContext, CoreDataProvider.preview.viewContext)
        .environmentObject(AppState())
//        .preferredColorScheme(.dark)
    }
  }
}
