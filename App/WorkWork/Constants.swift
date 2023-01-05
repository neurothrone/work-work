//
//  Constants.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-02.
//

enum MyApp {
  static let name = "WorkWork"
  
  enum CKConfig {
    static let containerName = "Entities"
    static let sharedAppGroup = "group.workWork"
    static let cloudContainerID = "iCloud.workWork"
  }
  
  enum SystemImage {
    static let settings = "gear"
    static let showAddListTextField = "folder.badge.plus"
    static let quickAdd = "folder.fill.badge.plus"
    static let moreOptionsAdd = "square.grid.3x1.folder.fill.badge.plus"
    static let dismissKeyboard = "keyboard.chevron.compact.down.fill"
    
    static let editActionMode = "pencil.circle"
    static let noActionMode = "circle.slash"
    
    static let folder = "folder"
  }
  
  enum AppStorage {
    static let selectedColor = "selectedColor"
    static let isOnboardingPresented = true
    static let selectedScreen = "selectedScreen"
    
  }
  
  enum Link {
    static let svgRepo = "https://www.svgrepo.com/"
  }
}
