//
//  TodoProgressView.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-09.
//

import SwiftUI

struct TodoProgressView: View {
  let text: String
  let color: Color
  let value: Double
  let minValue: Double
  let maxValue: Double
  let style: TodosProgressBarStyle
  
  private var hasNoValue: Bool {
    value.isZero && maxValue.isZero
  }
  
  var body: some View {
    if style == .linear {
      gauge
        .gaugeStyle(.linearCapacity)
    } else {
#if os(iOS)
      VStack {
        label
        gauge
          .gaugeStyle(.accessoryCircularCapacity)
      }
#elseif os(watchOS)
      gauge
        .gaugeStyle(.accessoryCircularCapacity)
#endif
    }
  }
  
  private var gauge: some View {
    Gauge(
      value: value,
      in: minValue...maxValue) {
        label
      } currentValueLabel: {
        Text("\(Int(value))")
          .font(.title3.bold())
          .foregroundColor(color)
      } minimumValueLabel: {
        Text("\(Int(minValue))")
      } maximumValueLabel: {
        Text("\(Int(maxValue))")
      }
      .tint(
        hasNoValue
        ? .clear
        : color
      )
  }
  
  private var label: some View {
    Text(text)
      .font(.headline)
      .foregroundColor(.secondary)
  }
}

struct TodoProgressView_Previews: PreviewProvider {
  static var previews: some View {
    TodoProgressView(
      text: "Todos Progress",
      color: .purple,
      value: .zero,
      minValue: .zero,
      maxValue: 5,
      style: .linear
    )
  }
}
