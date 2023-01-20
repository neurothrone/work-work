//
//  CustomLabelView.swift
//  WorkWork WatchOnly Watch App
//
//  Created by Zaid Neurothrone on 2023-01-20.
//

import SwiftUI

struct CustomLabelView: View {
  
  let text: String
  let systemImage: String
  let color: Color
  let spacing: CGFloat
  
  var body: some View {
    HStack(spacing: 2) {
      Image(systemName: "info.circle")
      Text("About")
    }
    .foregroundColor(color)
  }
}

struct CustomLabelView_Previews: PreviewProvider {
  static var previews: some View {
    CustomLabelView(
      text: "About",
      systemImage: "info.circle",
      color: .purple,
      spacing: 2
    )
  }
}
