//
//  AppState.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-05.
//

import SwiftUI

final class AppState: ObservableObject {
  @AppStorage(MyApp.AppStorage.prefersDarkMode)
  var prefersDarkMode: Bool = true
  
  @AppStorage(MyApp.AppStorage.selectedColor)
  var selectedColor: CustomColor = .purple

  func registerDefaults(colorScheme: ColorScheme) {
    UserDefaults.standard.register(defaults: [
      MyApp.AppStorage.prefersDarkMode: colorScheme == .dark ? true : false,
    ])
  }
}
