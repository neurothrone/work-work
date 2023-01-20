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
    changeSegmentedControlColor(to: selectedColor.color)
  }
  
  private func registerDefaults(colorScheme: ColorScheme) {
    UserDefaults.standard.register(defaults: [
      MyApp.AppStorage.prefersDarkMode: colorScheme == .dark ? true : false,
    ])
  }
  
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
  
  public func deleteAllData(using context: NSManagedObjectContext) {
    TodoList.deleteAll(using: context)
  }
}
