//
//  IconPickerView.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-05.
//

import SwiftUI
import WorkWorkKit

struct IconPickerView: View {
  @Binding var selectedIcon: Icon
  
  let selectionColor: Color
  
  var body: some View {
    ForEach(Icon.allCases) { icon in
      Button(action: { selectedIcon = icon }) {
        Image(systemName: icon.rawValue)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 50, height: 50)
          .foregroundColor(
            icon == selectedIcon
            ? selectionColor
            : .secondary
          )
      }
      .buttonStyle(.plain)
    }
  }
}

struct IconPickerView_Previews: PreviewProvider {
  private static let columns = [GridItem(.adaptive(minimum: 60))]
  
  static var previews: some View {
    ScrollView {
      LazyVGrid(columns: columns) {
        StatefulPreviewWrapper(Icon.default) {
          IconPickerView(
            selectedIcon: $0,
            selectionColor: .purple
          )
        }
      }
    }
  }
}
