//
//  CustomTextField.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-05.
//

import SwiftUI

struct CustomTextField: View {
  @Binding var text: String
  
  let placeholder: String
  let onSubmit: () -> Void
  
  var body: some View {
    HStack {
      TextField(placeholder, text: $text)
        .autocorrectionDisabled(true)
        .textInputAutocapitalization(.sentences)
        .textFieldStyle(.roundedBorder)
        .submitLabel(.done)
        .onSubmit(onSubmit)
    }
    .listRowSeparator(.hidden)
    .padding(.bottom)
  }
}

struct CustomTextField_Previews: PreviewProvider {
  static var previews: some View {
    CustomTextField(text: .constant(""), placeholder: "Todo Title", onSubmit: {})
  }
}
