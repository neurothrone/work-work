//
//  WorkWorkApp.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-02.
//

import SwiftUI
import WorkWorkKit

@main
struct AppMain: App {
  @Environment(\.colorScheme) var colorScheme
  @Environment(\.scenePhase) var scenePhase
  @StateObject private var appState: AppState = .init()
  
  private let coreDataProvider: CoreDataProvider = .shared

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, coreDataProvider.viewContext)
        .environmentObject(appState)
        .preferredColorScheme(appState.prefersDarkMode ? .dark : .light)
        .tint(appState.selectedColor.color)
        .onAppear {
          appState.setUp(colorScheme: colorScheme)
        }
        .onChange(of: scenePhase) { newScenePhase in
          if newScenePhase == .background {
            CoreDataProvider.save(using: coreDataProvider.viewContext)
          }
        }
    }
  }
}
