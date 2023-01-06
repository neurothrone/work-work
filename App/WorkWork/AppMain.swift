//
//  WorkWorkApp.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-02.
//

import SwiftUI

@main
struct AppMain: App {
  @Environment(\.colorScheme) var colorScheme
  @StateObject private var appState: AppState = .init()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .onAppear(perform: setUp)
        .environment(\.managedObjectContext, CoreDataProvider.shared.viewContext)
        .environmentObject(appState)
        .preferredColorScheme(appState.prefersDarkMode ? .dark : .light)
        .tint(appState.selectedColor.color)
    }
  }
}

extension AppMain {
  private func setUp() {
    appState.setUp(colorScheme: colorScheme)
  }
}
