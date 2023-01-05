//
//  SettingsScreen.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import SwiftUI

struct SettingsScreen: View {
  @EnvironmentObject var appState: AppState
  
  var body: some View {
    Form {
      //MARK: Dark / Light Theme
      Section {
        Toggle(
          "Prefers dark theme",
          isOn: $appState.prefersDarkMode
        )
          
        
      } header: {
        Text("App Color Theme")
      }

      
      //MARK: App Color Theme
      Section {
        HStack {
          ForEach(CustomColor.allCases) { customColor in
            Button {
              withAnimation(.easeInOut) {
                appState.selectedColor = customColor
              }
            } label: {
              Image(
                systemName: appState.selectedColor == customColor
                ? MyApp.SystemImage.circleFill
                : MyApp.SystemImage.circle
              )
              .resizable()
              .aspectRatio(contentMode: .fit)
              .foregroundColor(customColor.color)
            }
            .buttonStyle(.plain)
          }
        }
      } header: {
        Text("App Color Style")
      }
      
      Text("Todo isDone style. Swipe only, Tap Only, Both")
            
      Text("List style. Inset Grouped or Grouped")
      
      Text("Allow users to add padding vertically to list items to make swiping easier?")
    }
    .navigationTitle("Settings")
//    .preferredColorScheme(appState.prefersDarkMode ? .dark : .light)
  }
}

struct SettingsScreen_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      SettingsScreen()
        .environmentObject(AppState())
    }
  }
}
