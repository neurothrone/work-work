//
//  ContentView.swift
//  WorkWork WatchOnly Watch App
//
//  Created by Zaid Neurothrone on 2023-01-20.
//

import SwiftUI
import WorkWorkKit

struct ContentView: View {
  var body: some View {
    AllTodoListsScreen()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
      .environment(\.managedObjectContext, CoreDataProvider.preview.viewContext)
      .environmentObject(AppState())
      .preferredColorScheme(.dark)
  }
}
