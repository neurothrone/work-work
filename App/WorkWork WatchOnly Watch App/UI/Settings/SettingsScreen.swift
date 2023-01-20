//
//  SettingsScreen.swift
//  WorkWork WatchOnly Watch App
//
//  Created by Zaid Neurothrone on 2023-01-20.
//

import SwiftUI
import WorkWorkKit

struct SettingsScreen: View {
  @Environment(\.managedObjectContext) private var moc
  @EnvironmentObject var appState: AppState
  
  @State private var isAboutSheetPresented = false
  @State private var isDeleteDataSheetPresented = false
  
  @State private var selectedColor: CustomColor = .default
  
  var body: some View {
    content
      .navigationTitle("Settings")
      .onAppear {
        selectedColor = appState.selectedColor
      }
      .sheet(isPresented: $isAboutSheetPresented) {
        AboutSheet()
          .presentationDetents([.fraction(0.25), .medium, .large])
      }
      .sheet(isPresented: $isDeleteDataSheetPresented) {
        DeleteAllDataSheet {
          appState.deleteAllData(using: moc)
        }
        .presentationDetents([.fraction(0.5), .medium, .large])
      }
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          Button(action: { isAboutSheetPresented.toggle() }) {
            CustomLabelView(
              text: "About",
              systemImage: MyApp.SystemImage.infoCircle,
              color: appState.selectedColor.color,
              spacing: 2
            )
          }
        }
      }
  }
  
  private var content: some View {
    Form {
      //MARK: - App Color Theme
      Section {
        Toggle(
          "Dark Theme",
          isOn: $appState.prefersDarkMode
        )
        .tint(appState.selectedColor.color.opacity(0.75))
      } header: {
        Text("App Color Theme")
      }
      
      //MARK: - Todos Progress Bar
      Section {
        Toggle(
          "Show",
          isOn: $appState.showTodosProgressBar
        )
        .tint(appState.selectedColor.color)
      } header: {
        Text("Todos Progress Bar")
      }
      
      //MARK: - App Color Style
      Section {
        HStack {
          Picker(
            selection: $selectedColor,
            label: EmptyView()
          ) {
            ForEach(CustomColor.allCases) { customColor in
              HStack(spacing: 8) {
                Image(
                  systemName: appState.selectedColor == customColor
                  ? MyApp.SystemImage.circleFill
                  : MyApp.SystemImage.circle
                )
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundColor(customColor.color)
                
                Text(customColor.rawValue.capitalized)
              }
            }
          }
          .pickerStyle(.navigationLink)
          .onChange(of: selectedColor) { newSelectedColor in
            appState.selectedColor = newSelectedColor
          }
        }
      } header: {
        Text("App Color Style")
      }
      
      //MARK: - Todo Completion Style
      Section {
        Picker(
          selection: $appState.todoCompletionStyle,
          label: EmptyView()
        ) {
          ForEach(TodoCompletionStyle.allCases) { style in
            Text(style.rawValue)
              .foregroundColor(
                appState.todoCompletionStyle == style
                ? appState.selectedColor.color
                : .primary
              )
          }
        }
        .pickerStyle(.navigationLink)
      } header: {
        Text("Todo Completion Style")
      }
      
      //MARK: - Data
      Section {
        Button("Delete All Data", role: .destructive) {
          isDeleteDataSheetPresented.toggle()
        }
      } header: {
        Text("Data")
      }
    }
  }
}

struct SettingsScreen_Previews: PreviewProvider {
  @Environment(\.colorScheme) static var colorScheme
  
  static var previews: some View {
    let appState = AppState()
    
    NavigationStack {
      SettingsScreen()
        .environment(\.managedObjectContext, CoreDataProvider.preview.viewContext)
        .environmentObject(appState)
        .tint(appState.selectedColor.color)
        .preferredColorScheme(appState.prefersDarkMode ? .dark : .light)
        .onAppear {
          appState.setUp(colorScheme: colorScheme)
        }
    }
  }
}
