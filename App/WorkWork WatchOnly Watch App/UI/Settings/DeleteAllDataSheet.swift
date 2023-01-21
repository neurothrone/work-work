//
//  DeleteAllDataSheet.swift
//  WorkWork WatchOnly Watch App
//
//  Created by Zaid Neurothrone on 2023-01-20.
//

import SwiftUI

struct DeleteAllDataSheet: View {
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject var appState: AppState
  
  @State private var sliderValue: Double = .zero
  @State private var isConfirmingDeletion = false
  
  private let maxValue: Double = 100
  let onConfirmDelete: () -> Void
  
  private var isDeleteButtonDisabled: Bool {
    sliderValue < maxValue
  }
  
  var body: some View {
    NavigationStack {
      ScrollView {
        content
      }
      .toolbar {
        ToolbarItem(placement: .cancellationAction) {
          Button("Cancel", role: .cancel, action: { dismiss() })
            .buttonStyle(.plain)
            .foregroundColor(.secondary)
        }
      }
    }
  }
  
  private var content: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text("Are you sure? This will delete all of your data on all your local devices and remotely in iCloud.")
      
      VStack(spacing: 4) {
        Image(systemName: MyApp.SystemImage.exclamationmarkCircle)
          .resizable()
          .frame(width: 44, height: 44)
          .aspectRatio(contentMode: .fit)
          .foregroundColor(.red)
        
        Text("You must tap on the slider below and use the digital crown to move the circle to the end to confirm.")
          .font(.callout)
      }
      .padding(10)
      .background(
        RoundedRectangle(cornerRadius: 10)
          .fill(.red.opacity(0.5))
      )
      .frame(maxWidth: .infinity, alignment: .center)
      
      Gauge(value: sliderValue, in: .zero...maxValue) {
        Text("Deletion Enabled Progress")
      }
      .tint(.red)
      .gaugeStyle(.accessoryLinear)
      .labelsHidden()
      .focusable()
      .digitalCrownRotation(
        $sliderValue,
        from: .zero,
        through: maxValue,
        sensitivity: .high,
        isContinuous: false,
        isHapticFeedbackEnabled: true
      )
      .padding(.vertical)
      
      if !isDeleteButtonDisabled {
        Button(role: .destructive, action: deleteAllData) {
          Label(
            "Delete",
            systemImage: MyApp.SystemImage.trashFill
          )
          .frame(maxWidth: .infinity)
          .padding(.vertical)
        }
        .buttonStyle(.borderedProminent)
        .tint(.red)
      }
      
      Spacer()
    }
    .padding(.horizontal, 5)
    .animation(.easeInOut, value: isDeleteButtonDisabled)
  }
}

extension DeleteAllDataSheet {
  private func deleteAllData() {
    onConfirmDelete()
    dismiss()
  }
}

struct DeleteAllDataSheet_Previews: PreviewProvider {
  static var previews: some View {
    DeleteAllDataSheet(onConfirmDelete: {})
      .environmentObject(AppState())
  }
}
