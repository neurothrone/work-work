//
//  AboutSheet.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import SwiftUI

struct AboutSheet: View {
#if os(watchOS)
  @Environment(\.dismiss) var dismiss
#endif
  
  @EnvironmentObject var appState: AppState
  
  var body: some View {
#if os(iOS)
    content
#elseif os(watchOS)
    ScrollView {
      content
    }
    .navigationTitle("About")
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button("Cancel", role: .cancel, action: { dismiss() })
          .buttonStyle(.plain)
          .foregroundColor(.secondary)
      }
    }
#endif
  }
  
  private var content: some View {
    VStack(spacing: 4) {
      HStack(spacing: .zero) {
        Text("Made with ")
        Image(systemName: MyApp.SystemImage.heartFill)
          .foregroundColor(appState.selectedColor.color)
        Text(" by")
      }
      
      Text("Zaid Neurothrone")
        .font(.headline)
        .foregroundColor(appState.selectedColor.color)
      
      HStack(spacing: .zero) {
        Text("Copyright ")
        Image(systemName: MyApp.SystemImage.copyright)
        Text(" ")
        Text(Date.now, format: .dateTime.year())
      }
      
#if os(iOS)
      Text("Version \(UIApplication.appVersion)")
        .foregroundColor(appState.selectedColor.color)
#elseif os(watchOS)
      Text("Version \(WKApplication.appVersion)")
        .foregroundColor(appState.selectedColor.color)
#endif
      
      CustomLinkView(
        urlString: MyApp.Link.svgRepo,
        text: "App icon by svgrepo.com"
      )
      .padding(.top)
    }
    .padding()
#if os(iOS)
    .background(
      RoundedRectangle(cornerRadius: 20)
        .fill(.ultraThickMaterial)
    )
#elseif os(watchOS)
    .background(
      RoundedRectangle(cornerRadius: 20)
        .fill(appState.selectedColor.color.opacity(0.25))
    )
#endif
  }
}

struct AboutSheet_Previews: PreviewProvider {
  static var previews: some View {
    NavigationStack {
      AboutSheet()
        .preferredColorScheme(.dark)
        .environmentObject(AppState())
    }
  }
}
