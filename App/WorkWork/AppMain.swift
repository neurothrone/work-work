//
//  WorkWorkApp.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-02.
//

import SwiftUI

@main
struct AppMain: App {
  @AppStorage(MyApp.AppStorage.selectedColor)
  var selectedColor: CustomColor = .purple
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
        .tint(selectedColor.color)
    }
  }
}
