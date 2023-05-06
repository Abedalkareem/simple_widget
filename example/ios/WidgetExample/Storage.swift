//
//  Storage.swift
//  WidgetExampleExtension
//
//  Created by abedalkareem omreyh on 09/04/2023.
//

import Foundation

class Storage {

  // MARK: - Properties

  static let shared = Storage()

  // MARK: - Private Properties

  private let groupId = Settings.groupId

  private let fileName = "timeline_data.json"


  // MARK: -

  func getTimelines() -> [TimelineData] {
    guard let file = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupId)?.appendingPathComponent(fileName) else {
      assert(false, "Please provide a group id using `setGroupID`")
      return []
    }
    let decoder = JSONDecoder()
    do {
      let data = try Data(contentsOf: file)
      let appWidgetData = try decoder.decode([TimelineData].self, from: data)
      return appWidgetData
    } catch {
      assert(false, "Couldn't load \(fileName)")
    }
    return []
  }
}
