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
  
  @State private var newListName = ""
  
  var body: some View {
    content
      .navigationTitle("Add List")
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button("Cancel", role: .cancel, action: { dismiss() })
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Add") {
            _ = TodoList.createWith(name: newListName, using: moc)
            dismiss()
          }
          .disabled(newListName.isEmpty)
          .tint(.purple)
        }
      }
  }
  
  private var content: some View {
    VStack {
      TextField("Name", text: $newListName)
        .autocorrectionDisabled(true)
        .textFieldStyle(.roundedBorder)
        .textInputAutocapitalization(.sentences)
      
      Spacer()
    }
    .padding()
  }
}

struct AddTodoListSheet_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      AddTodoListSheet()
        .environment(\.managedObjectContext, CoreDataProvider.preview.viewContext)
    }
  }
}
