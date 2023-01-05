//
//  SettingsScreen.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import SwiftUI

struct SettingsScreen: View {
  @AppStorage(MyApp.AppStorage.selectedColor)
  var selectedColor: CustomColor = .purple
  
  var body: some View {
    Form {
      //MARK: App Color Theme
      Section {
        HStack {
          ForEach(CustomColor.allCases) { customColor in
            Button {
              withAnimation(.easeInOut) {
                selectedColor = customColor
              }
            } label: {
              Image(systemName: selectedColor == customColor
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
        Text("App Color Theme")
      }
      
      // TODO: Manual Dark / Light Theme toggle
      
      Text("Todo isDone style. Swipe only, Tap Only, Both")
            
      Text("List style. Inset Grouped or Grouped")
      
      Text("Allow users to add padding vertically to list items to make swiping easier?")
    }
    .navigationTitle("Settings")
  }
}

struct SettingsScreen_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      SettingsScreen()
        .preferredColorScheme(.dark)
    }
  }
}
