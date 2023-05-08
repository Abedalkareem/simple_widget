//
//  Storage.swift
//  simple_widget
//
//  Created by abedalkareem omreyh on 09/04/2023.
//

import UIKit
import Flutter

class Storage {

  // MARK: - Properties

  static let shared = Storage()

  // MARK: - Private Properties

  private let groupId = Settings.groupId

  private let fileName = "timeline_data.json"

  // MARK: -

  func save(_ string: String) {
    assert(groupId != nil, "Please provide a group id using `setGroupID`")
    guard let file = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupId!)?.appendingPathComponent(fileName) else {
      assert(false, "Please provide a group id using `setGroupID`")
      return
    }
    do {
      try string.data(using: .utf8)?.write(to: file)
    } catch {
      print("Couldn't wrtie \(fileName)")
    }

  }

  func getTimelinesData() -> String? {
    assert(groupId != nil, "Please provide a group id using `setGroupID`")
    guard let file = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupId!)?.appendingPathComponent(fileName) else {
      assert(false, "Please provide a group id using `setGroupID`")
      return nil
    }
    do {
      let data = try Data(contentsOf: file)
      return String(data: data, encoding: .utf8)
    } catch {
      print("Couldn't load \(fileName)")
    }
    return nil
  }
}
