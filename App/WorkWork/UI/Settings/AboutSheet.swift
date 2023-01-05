//
//  AboutSheet.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-03.
//

import SwiftUI

import SwiftUI

struct AboutSheet: View {
  @EnvironmentObject var appState: AppState
  
  var body: some View {
    VStack(spacing: 4) {
      HStack(spacing: .zero) {
        Text("Made with ")
        Image(systemName: MyApp.SystemImage.heartFill)
          .foregroundColor(appState.selectedColor.color)
        Text(" by Zaid Neurothrone")
        
      }
      
      HStack(spacing: .zero) {
        Text("Copyright ")
        Image(systemName: MyApp.SystemImage.copyright)
        Text(" ")
        Text(Date.now, format: .dateTime.year())
      }
      
      Text("Version \(UIApplication.appVersion)")
        .foregroundColor(appState.selectedColor.color)
      
      CustomLinkView(
        urlString: MyApp.Link.svgRepo,
        text: "App icon by svgrepo.com"
      )
      .padding(.top)
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: 20)
        .fill(.ultraThickMaterial)
    )
  }
}

struct AboutSheet_Previews: PreviewProvider {
  static var previews: some View {
    AboutSheet()
      .preferredColorScheme(.dark)
      .environmentObject(AppState())
  }
}
