//
//  WKApplication+Extensions.swift
//  WorkWork WatchOnly Watch App
//
//  Created by Zaid Neurothrone on 2023-01-20.
//

import WatchKit

extension WKApplication {
  static var appVersion: String {
    Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
  }
}
