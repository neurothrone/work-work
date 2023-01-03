//
//  ContentView.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-02.
//

import SwiftUI

struct ContentView: View {
  @AppStorage(MyApp.AppStorage.selectedScreen)
  var selectedScreen: Screen = .lists
  
  var body: some View {
    TabView(selection: $selectedScreen) {
      Group {
        ForEach(Screen.allCases) { screen in
          screen.view
            .tabItem {
              Label(
                screen.rawValue.capitalized,
                systemImage: screen.systemImage
              )
            }
        }
      }
      .toolbarBackground(.visible, for: .tabBar)
      .toolbarBackground(.ultraThinMaterial, for: .tabBar)
    }
    .tint(.purple)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environment(\.managedObjectContext, CoreDataProvider.preview.viewContext)
  }
}
