//
//  CustomTextFieldView.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-05.
//

import SwiftUI

struct CustomTextFieldView: View {
  @Binding var text: String
  
  let placeholder: String
  let onSubmit: () -> Void
  
  var body: some View {
    TextField(placeholder, text: $text)
      .autocorrectionDisabled(true)
      .textInputAutocapitalization(.sentences)
      .textFieldStyle(.roundedBorder)
      .submitLabel(.done)
      .onSubmit(onSubmit)
      .listRowSeparator(.hidden)
      .padding(.bottom)
  }
}

struct CustomTextFieldView_Previews: PreviewProvider {
  static var previews: some View {
    CustomTextFieldView(text: .constant(""), placeholder: "Todo Title", onSubmit: {})
  }
}
