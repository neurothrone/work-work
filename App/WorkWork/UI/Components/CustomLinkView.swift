//
//  CustomLinkView.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-05.
//

import SwiftUI

struct CustomLinkView: View {
  let urlString: String
  let text: String
  
  var body: some View {
    Link(destination: URL(string: urlString)!) {
      HStack(alignment: .center) {
        Text(text)
          .font(.footnote)
          .fixedSize(horizontal: false, vertical: true)
        Image(systemName: MyApp.SystemImage.linkCircleFill)
      }
      .foregroundColor(.blue)
    }
  }
}

struct CustomLinkView_Previews: PreviewProvider {
  static var previews: some View {
    CustomLinkView(
      urlString: MyApp.Link.svgRepo,
      text: "App icon by svgrepo.com"
    )
  }
}
