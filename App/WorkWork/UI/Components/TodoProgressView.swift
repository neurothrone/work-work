//
//  TodoProgressView.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-09.
//

import SwiftUI

struct TodoProgressView: View {
  let label: String
  let color: Color
  let value: Double
  let minValue: Double
  let maxValue: Double
  
  var body: some View {
    Gauge(
      value: value,
      in: minValue...maxValue) {
        Text(label)
      } currentValueLabel: {
        Text("\(Int(value))")
      } minimumValueLabel: {
        Text("\(Int(minValue))")
      } maximumValueLabel: {
        Text("\(Int(maxValue))")
      }
      .gaugeStyle(.linearCapacity)
      .tint(color)
  }
}

struct TodoProgressView_Previews: PreviewProvider {
  static var previews: some View {
    TodoProgressView(
      label: "Todos Progress",
      color: .purple,
      value: 2,
      minValue: .zero,
      maxValue: 10
    )
  }
}
