//
//  AppState.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-05.
//

import CoreData
import SwiftUI
import WorkWorkKit

final class AppState: ObservableObject {
  //MARK: - Properties

  @AppStorage(MyApp.AppStorage.prefersDarkMode)
  var prefersDarkMode: Bool = true
  
#if os(iOS)
  @AppStorage(MyApp.AppStorage.selectedColor)
  var selectedColor: CustomColor = .purple {
    didSet {
      DispatchQueue.main.async {
        self.changeSegmentedControlColor(to: self.selectedColor.color)
        
        withAnimation(.easeInOut) {
          self.idForChangingAllSegmentedControls = .init()
        }
      }
    }
  }
#elseif os(watchOS)
  @AppStorage(MyApp.AppStorage.selectedColor)
  var selectedColor: CustomColor = .purple
#endif
  
  @AppStorage(MyApp.AppStorage.listStyle)
  var listStyle: ListStyle = .insetGrouped
  
  @AppStorage(MyApp.AppStorage.todoCompletionStyle)
  var todoCompletionStyle: TodoCompletionStyle = .both
  
  @AppStorage(MyApp.AppStorage.showTodosProgressBar)
  var showTodosProgressBar: Bool = true
  
  @AppStorage(MyApp.AppStorage.todosProgressBarStyle)
  var todosProgressBarStyle: TodosProgressBarStyle = .linear
  
  @AppStorage(MyApp.AppStorage.primaryButtonHandedness)
  var primaryButtonHandedness: PrimaryButtonHandedness = .default
  
  @AppStorage(MyApp.AppStorage.todoRowVerticalPadding)
  var todoRowVerticalPadding: Int = .zero

  @Published var idForChangingAllSegmentedControls: UUID = .init()
  
  @Published var path: [TodoList] = []
  
  //MARK: - Methods
  
  func setUp(colorScheme: ColorScheme) {
    registerDefaults(colorScheme: colorScheme)
    
#if os(iOS)
    changeSegmentedControlColor(to: selectedColor.color)
#endif
  }
  
  private func registerDefaults(colorScheme: ColorScheme) {
    // A default is only set if the key is nil
    UserDefaults.standard.register(
      defaults: [
        MyApp.AppStorage.prefersDarkMode: colorScheme == .dark ? true : false,
      ])
  }
  
#if os(iOS)
  func changeSegmentedControlColor(to color: Color) {
    UISegmentedControl.appearance()
      .selectedSegmentTintColor = UIColor(color.opacity(0.5))
    UISegmentedControl.appearance()
      .backgroundColor = UIColor(color.opacity(0.3))
    UISegmentedControl.appearance()
      .setTitleTextAttributes(
        [.foregroundColor: UIColor(Color.primary)],
        for: .selected
      )
    UISegmentedControl.appearance()
      .setTitleTextAttributes(
        [.foregroundColor: UIColor(Color.secondary)],
        for: .normal
      )
  }
#endif
  
  public func deleteAllData(using context: NSManagedObjectContext) {
    TodoList.deleteAll(using: context)
  }
}
