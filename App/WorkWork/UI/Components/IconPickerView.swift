//
//  IconPickerView.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-05.
//

import SwiftUI

enum Icon: String {
  case none = "x.square.fill",
       folder
}

extension Icon: Identifiable, CaseIterable {
  var id: Self { self }
}

struct IconPickerView: View {
  @AppStorage(MyApp.AppStorage.selectedColor)
  var selectedColor: CustomColor = .purple
  
  @State private var selectedIcon: Icon = .none
  
  private let columns = [
    GridItem(.adaptive(minimum: 60))
  ]
  
  var body: some View {
    ScrollView {
      Text("Select an icon")
      
      LazyVGrid(columns: columns) {
        ForEach(Icon.allCases) { icon in
          Button(action: { selectedIcon = icon }) {
            Image(systemName: icon.rawValue)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 50, height: 50)
              .foregroundColor(
                icon == .none
                ? .secondary
                : selectedColor.color
              )
          }
        }
      }
      .padding()
    }
  }
}

struct IconPickerView_Previews: PreviewProvider {
  static var previews: some View {
    IconPickerView()
  }
}
