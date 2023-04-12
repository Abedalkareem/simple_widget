//
//  AppUserDefaults.swift
//  native_widget
//
//  Created by abedalkareem omreyh on 09/04/2023.
//

import UIKit

class AppUserDefaults {

  // MARK: - Properties

  static let shared = AppUserDefaults()

  // MARK: - Private Properties

  private let groupId = Settings.groupId

  private let userDefaults: UserDefaults?

  private let key = "AppWidgetsData"

  // MARK: - init

  init() {
    userDefaults = UserDefaults(suiteName: groupId)
  }

  // MARK: -

  func save(_ string: String) {
    assert(groupId != nil, "Please provide a group id using `setGroupID`")
    userDefaults?.set(string, forKey: key)
  }

  func get(_ string: String) -> String? {
    assert(groupId != nil, "Please provide a group id using `setGroupID`")
    return userDefaults?.string(forKey: key)
  }
}
