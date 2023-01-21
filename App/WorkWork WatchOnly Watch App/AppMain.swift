//
//  AppMain.swift
//  WorkWork WatchOnly Watch App
//
//  Created by Zaid Neurothrone on 2023-01-20.
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
        .tint(appState.selectedColor.color)
        .onChange(of: scenePhase) { newScenePhase in
          if newScenePhase == .background {
            CoreDataProvider.save(using: coreDataProvider.viewContext)
          }
        }
    }
  }
}
