//
//  Color+Extensions.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-06.
//

import SwiftUI

extension Color {
#if os(macOS)
  static let lightModeBackground = Color(NSColor.windowBackgroundColor)
#else
  static let lightModeBackground = Color(UIColor.systemGroupedBackground)
#endif
}
