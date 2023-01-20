//
//  Icon.swift
//  WorkWork
//
//  Created by Zaid Neurothrone on 2023-01-09.
//

public enum Icon: String {
  case folder,
       folderFill = "folder.fill",
       folderCircle = "folder.circle",
       folderCircleFill = "folder.circle.fill",
       questionMarkFolder = "questionmark.folder",
       questionMarkFolderFill = "questionmark.folder.fill",
       folderBadgeGearshape = "folder.badge.gearshape",
       folderFillBadgeGearshape = "folder.fill.badge.gearshape",
       folderBadgeQuestionmark = "folder.badge.questionmark",
       folderFillBadgeQuestionmark = "folder.fill.badge.questionmark",
       folderBadgePersonCrop = "folder.badge.person.crop",
       folderFillBadgePersonCrop = "folder.fill.badge.person.crop",
       house,
       houseFill = "house.fill",
       houseCircle = "house.circle",
       houseCircleFill = "house.circle.fill",
       archivebox,
       archiveboxFill = "archivebox.fill",
       archiveboxCircle = "archivebox.circle",
       archiveboxCircleFill = "archivebox.circle.fill",
       shippingboxCircle = "shippingbox.circle",
       shippingboxCircleFill = "shippingbox.circle.fill",
       person,
       personFill = "person.fill",
       personCircle = "person.circle",
       personCircleFill = "person.circle.fill",
       lightbulb,
       lightbulbFill = "lightbulb.fill",
       lightbulbCircle = "lightbulb.circle",
       lightbulbCircleFill = "lightbulb.circle.fill",
       figureWalk = "figure.walk",
       figureWalkCircle = "figure.walk.circle",
       figureWalkCircleFill = "figure.walk.circle.fill",
       figureWalkMotion = "figure.walk.motion"
  
  public static let `default`: Icon = .folder
}

extension Icon: Identifiable, CaseIterable {
  public var id: Self { self }
}
