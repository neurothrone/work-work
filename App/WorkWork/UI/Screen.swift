//
//  Screen.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import SwiftUI

enum Screen: String {
  case lists, settings
}

extension Screen: Identifiable, CaseIterable {
  var id: Self { self }
  
  var systemImage: String {
    switch self {
    case .lists:
      return "list.dash"
    case .settings:
      return "gear"
    }
  }
  
  var view: some View {
    NavigationStack {
      self.screen
        .navigationTitle(self.rawValue.capitalized)
        .navigationBarTitleDisplayMode(.inline)
    }
  }
  
  @ViewBuilder
  private var screen: some View {
    switch self {
    case .lists:
      AllTodoListsScreen()
    case .settings:
      SettingsScreen()
    }
  }
}
