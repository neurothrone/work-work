//
//  SettingsScreen.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import SwiftUI



struct SettingsScreen: View {
  @Environment(\.managedObjectContext) private var moc
  @EnvironmentObject var appState: AppState
  
  @State private var isAboutSheetPresented = false
  @State private var isDeleteDataSheetPresented = false
  
  var body: some View {
    content
      .navigationTitle("Settings")
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
      .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
      .toolbar {
        Menu {
          Button(action: { isAboutSheetPresented.toggle() }) {
            Label("About", systemImage: "info.circle")
          }
        } label: {
          Image(systemName: "ellipsis.circle")
        }
      }
  }
  
  private var content: some View {
    Form {
      //MARK: - App Color Theme
      Section {
        Toggle(
          "Prefers Dark Theme",
          isOn: $appState.prefersDarkMode
        )
        
        
      } header: {
        Text("App Color Theme")
      }
      
      //MARK: - App Color Style
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
      
      //MARK: - List Style
      Section {
        Picker("List Style", selection: $appState.listStyle) {
          ForEach(ListStyle.allCases) { listStyle in
            Text(listStyle.rawValue)
          }
        }
        .pickerStyle(.segmented)
      } header: {
        Text("List Style")
      }
      
      //MARK: - Todo Completion Style
      Section {
        Picker("Todo Completion Style", selection: $appState.todoCompletionStyle) {
          ForEach(TodoCompletionStyle.allCases) { style in
            Text(style.rawValue)
          }
        }
        .pickerStyle(.segmented)
      } header: {
        Text("Todo Completion Style")
      }
      
      //MARK: - Todo Row Vertical Padding
      Section {
        Stepper(
          appState.todoRowVerticalPadding.description,
          value: $appState.todoRowVerticalPadding,
          in: .zero...20,
          step: 5
        )
      } header: {
        Text("Todo Row Vertical Padding")
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
  static var previews: some View {
    let appState = AppState()
    
    NavigationStack {
      SettingsScreen()
        .environment(\.managedObjectContext, CoreDataProvider.preview.viewContext)
        .environmentObject(appState)
        .tint(appState.selectedColor.color)
        .preferredColorScheme(appState.prefersDarkMode ? .dark : .light)
    }
  }
}
