//
//  SettingsScreen.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import SwiftUI

struct SettingsScreen: View {
  var body: some View {
    Form {
      Text("Interactive color style. Selection of built-in dark/light mode supported colors. Start with 5-6 colors.")
      
      Text("Todo isDone style. Swipe only, Tap Only, Both")
            
      Text("List style. Inset Grouped or Grouped")
      
      Text("Allow users to add padding vertically to list items to make swiping easier?")
    }
    .navigationTitle("Settings")
  }
}

struct SettingsScreen_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      SettingsScreen()
    }
  }
}
