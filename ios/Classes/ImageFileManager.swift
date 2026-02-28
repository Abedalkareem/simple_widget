//
//  ImageFileManager.swift
//  simple_widget
//

import Foundation

class ImageFileManager {

  static let shared = ImageFileManager()

  private let imageDir = "widget_images"

  func getImageDirectory() -> URL? {
    guard let groupId = Settings.groupId else {
      return nil
    }
    guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupId) else {
      return nil
    }
    let dir = containerURL.appendingPathComponent(imageDir)
    if !FileManager.default.fileExists(atPath: dir.path) {
      try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
    }
    return dir
  }

  func saveImage(_ bytes: Data, filename: String?) -> String? {
    guard let dir = getImageDirectory() else { return nil }
    let name = filename ?? "\(UUID().uuidString).png"
    let file = dir.appendingPathComponent(name)
    do {
      try bytes.write(to: file)
      return "\(imageDir)/\(name)"
    } catch {
      print("Failed to save image: \(error)")
      return nil
    }
  }

  func deleteImages(_ relativePaths: [String]) {
    guard let groupId = Settings.groupId,
          let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupId) else {
      return
    }
    for path in relativePaths {
      let file = containerURL.appendingPathComponent(path)
      try? FileManager.default.removeItem(at: file)
    }
  }

  func getBasePath() -> String? {
    guard let groupId = Settings.groupId,
          let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupId) else {
      return nil
    }
    return containerURL.path
  }
}
