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
      Text("Todo isDone style. Swipe only, Tap Only, Both")
      
      Text("Interactive color style. Selection of built-in dark/light mode supported colors. Start with 5-6 colors.")
      
      Text("List style. Inset Grouped or Grouped")
    }
  }
}

struct SettingsScreen_Previews: PreviewProvider {
  static var previews: some View {
    Screen.settings.view
  }
}
