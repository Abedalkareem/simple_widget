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

  // MARK: - init

  init() {
    userDefaults = UserDefaults(suiteName: groupId)
  }

  // MARK: -
  
  func getWidgets() -> [AppWidgetData] {
    let value = userDefaults?.string(forKey: "AppWidgetsData") ?? ""
    let decoder = JSONDecoder()
    do {
      let jsonData = Data(value.utf8)
      let appWidgetData = try decoder.decode([AppWidgetData].self, from: jsonData)
      return appWidgetData
    } catch {
      print(error.localizedDescription)
    }
    return []
  }
}
