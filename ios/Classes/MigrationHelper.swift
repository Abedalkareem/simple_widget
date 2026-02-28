//
//  MigrationHelper.swift
//  simple_widget
//

import Foundation
import CommonCrypto

class MigrationHelper {

  static let shared = MigrationHelper()

  private let migrationKey = "migrated_to_files"

  func isMigrated() -> Bool {
    return UserDefaults.standard.bool(forKey: migrationKey)
  }

  private func setMigrated() {
    UserDefaults.standard.set(true, forKey: migrationKey)
  }

  func migrateBase64ToFiles() -> Bool {
    if isMigrated() {
      return false
    }

    guard let jsonString = Storage.shared.getTimelinesData(),
          let jsonData = jsonString.data(using: .utf8) else {
      setMigrated()
      return false
    }

    do {
      guard var timelines = try JSONSerialization.jsonObject(with: jsonData) as? [[String: Any]] else {
        setMigrated()
        return false
      }

      var changed = false
      var hashToPath: [String: String] = [:]

      for i in 0..<timelines.count {
        guard var dataArray = timelines[i]["data"] as? [[String: Any]] else { continue }

        for j in 0..<dataArray.count {
          if let bgValue = dataArray[j]["background"] as? String,
             !bgValue.isEmpty,
             !bgValue.hasPrefix("widget_images/") {
            if let path = saveBase64AsFile(bgValue, hashToPath: &hashToPath) {
              dataArray[j]["background"] = path
              changed = true
            }
          }

          if let fgValue = dataArray[j]["foreground"] as? String,
             !fgValue.isEmpty,
             !fgValue.hasPrefix("widget_images/") {
            if let path = saveBase64AsFile(fgValue, hashToPath: &hashToPath) {
              dataArray[j]["foreground"] = path
              changed = true
            }
          }
        }

        timelines[i]["data"] = dataArray
      }

      if changed {
        let newData = try JSONSerialization.data(withJSONObject: timelines)
        if let newString = String(data: newData, encoding: .utf8) {
          Storage.shared.save(newString)
        }
      }

      setMigrated()
      return changed
    } catch {
      print("Migration failed: \(error)")
      return false
    }
  }

  private func saveBase64AsFile(_ base64String: String, hashToPath: inout [String: String]) -> String? {
    guard let bytes = Data(base64Encoded: base64String) else { return nil }

    let hash = md5(bytes)
    if let existingPath = hashToPath[hash] {
      return existingPath
    }

    guard let path = ImageFileManager.shared.saveImage(bytes, filename: nil) else { return nil }
    hashToPath[hash] = path
    return path
  }

  private func md5(_ data: Data) -> String {
    var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
    data.withUnsafeBytes { body in
      _ = CC_MD5(body.baseAddress, CC_LONG(data.count), &digest)
    }
    return digest.map { String(format: "%02x", $0) }.joined()
  }
}
