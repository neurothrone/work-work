//
//  WatchIconPickerView.swift
//  WorkWork WatchOnly Watch App
//
//  Created by Zaid Neurothrone on 2023-01-21.
//

import SwiftUI

struct WatchIconPickerView: View {
  @Environment(\.dismiss) var dismiss
  @EnvironmentObject var appState: AppState
  
  @ObservedObject var viewModel: AddOrEditTodoListViewModel
  
  private let columns = [
    GridItem(
      .adaptive(minimum: 60),
      spacing: .zero,
      alignment: .center
    )
  ]
  
  var body: some View {
    NavigationStack {
      ScrollView {
        LazyVGrid(columns: columns) {
          IconPickerView(
            selectedIcon: $viewModel.selectedIcon,
            selectionColor: appState.selectedColor.color
          )
        }
      }
      .navigationTitle("Select an icon")
      .toolbar {
        //MARK: Navigation Bar
        ToolbarItem(placement: .confirmationAction) {
          Button("Done", action: { dismiss() })
            .tint(appState.selectedColor.color)
        }
    }
    }
  }
}

struct WatchIconPickerView_Previews: PreviewProvider {
  static var previews: some View {
    WatchIconPickerView(viewModel: AddOrEditTodoListViewModel(todoList: nil))
      .environmentObject(AppState())
  }
}
