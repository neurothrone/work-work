//
//  SectionHeaderView.swift
//  WorkWork WatchOnly Watch App
//
//  Created by Zaid Neurothrone on 2023-01-20.
//

import SwiftUI

struct SectionHeaderView: View {
  
  let leftText: String
  let rightText: String
  
  var body: some View {
    HStack {
      Text(leftText)
      Spacer()
      Text(rightText)
    }
  }
}

struct SectionHeaderView_Previews: PreviewProvider {
  static var previews: some View {
    SectionHeaderView(leftText: "Folders", rightText: "5")
  }
}
