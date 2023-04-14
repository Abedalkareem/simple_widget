//
//  AppUserDefaults.swift
//  WidgetExampleExtension
//
//  Created by abedalkareem omreyh on 09/04/2023.
//

import Foundation

class AppUserDefaults {

  // MARK: - Properties

  static let shared = AppUserDefaults()

  // MARK: - Private Properties

  private let groupId = Settings.groupId

  private let userDefaults: UserDefaults?

  private let key = "TimelineData"

  // MARK: - init

  init() {
    userDefaults = UserDefaults(suiteName: groupId)
  }

  // MARK: -
  
  func getTimelines() -> [TimelineData] {
    let value = userDefaults?.string(forKey: key) ?? ""
    let decoder = JSONDecoder()
    do {
      let jsonData = Data(value.utf8)
      let appWidgetData = try decoder.decode([TimelineData].self, from: jsonData)
      return appWidgetData
    } catch {
      print(error.localizedDescription)
    }
    return []
  }
}
