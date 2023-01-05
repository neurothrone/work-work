//
//  AppState.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-05.
//

import CoreData
import SwiftUI

//MARK: - Enums
enum ListStyle: String {
  case insetGrouped = "Inset Grouped",
       grouped = "Grouped"
}

extension ListStyle: Identifiable, CaseIterable {
  var id: Self { self }
}

enum TodoCompletionStyle: String {
  case both = "Both",
       swipeOnly = "Swipe Only",
       tapOnly = "Tap Only"
}

extension TodoCompletionStyle: Identifiable, CaseIterable {
  var id: Self { self }
}

//MARK: - AppState
final class AppState: ObservableObject {
  //MARK: Properties
  
  @AppStorage(MyApp.AppStorage.prefersDarkMode)
  var prefersDarkMode: Bool = true
  
  @AppStorage(MyApp.AppStorage.selectedColor)
  var selectedColor: CustomColor = .purple
  
  @AppStorage("listStyle")
  var listStyle: ListStyle = .insetGrouped
  
  @AppStorage("todoCompletionStyle")
  var todoCompletionStyle: TodoCompletionStyle = .both
  
  @AppStorage("todoRowVerticalPadding")
  var todoRowVerticalPadding: Int = .zero

  
  //MARK: Methods
  
  func registerDefaults(colorScheme: ColorScheme) {
    UserDefaults.standard.register(defaults: [
      MyApp.AppStorage.prefersDarkMode: colorScheme == .dark ? true : false,
    ])
  }
  
  func deleteAllData(using context: NSManagedObjectContext) {
    TodoList.deleteAll(using: context)
  }
}
