//
//  ContentView.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-02.
//

import SwiftUI

struct ContentView: View {
  @EnvironmentObject var appState: AppState
  
  @AppStorage(MyApp.AppStorage.selectedColor)
  var selectedColor: CustomColor = .purple
  
  var body: some View {
    NavigationStack {
      AllTodoListsScreen()
        .navigationTitle("Folders")
        .toolbar {
          //MARK: Navigation Bar
          ToolbarItem(placement: .navigationBarTrailing) {
            NavigationLink {
              SettingsScreen()
                .environmentObject(appState)
            } label: {
              Label(
                "Settings",
                systemImage: MyApp.SystemImage.settings
              )
              .tint(selectedColor.color)
            }
          }
        }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      ContentView()
        .environment(\.managedObjectContext, CoreDataProvider.preview.viewContext)
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
    }
  }
}
