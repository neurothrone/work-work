//
//  CustomColor.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-05.
//

import SwiftUI

enum CustomColor: String {
  case red,
       green,
       blue,
       purple,
       indigo,
       mint
}

extension CustomColor: Identifiable, CaseIterable {
  var id: Self { self }
  
  var color: Color {
    switch self {
    case .red:
      return Color.red
    case .green:
      return Color.green
    case .blue:
      return Color.blue
    case .purple:
      return Color.purple
    case .indigo:
      return Color.indigo
    case .mint:
      return Color.mint
    }
  }
}
