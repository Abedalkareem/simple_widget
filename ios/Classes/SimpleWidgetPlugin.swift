import Flutter
import UIKit
import WidgetKit

public class SimpleWidgetPlugin: NSObject, FlutterPlugin {

  // MARK: - Private Properties

  private var eventSink: FlutterEventSink?
  private var launchOptionsURL: URL?

  // MARK: -

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "simple_widget", binaryMessenger: registrar.messenger())
    let instance = SimpleWidgetPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    let eventChannel = FlutterEventChannel(name: "simple_widget/events", binaryMessenger: registrar.messenger())
    eventChannel.setStreamHandler(instance)

    registrar.addApplicationDelegate(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

    guard let method = Methods(rawValue: call.method) else {
      result(Errors.notImplemented)
      return
    }

    switch method {
    case .updateWidgets:
      guard let arguments = call.arguments as? String else {
        result(Errors.wrongArguments)
        return
      }
      Storage.shared.save(arguments)
      result(nil)
    case .getTimelinesData:
      let _ = MigrationHelper.shared.migrateBase64ToFiles()
      result(Storage.shared.getTimelinesData())
    case .refreshWidgets:
      if #available(iOS 14.0, *) {
        WidgetCenter.shared.reloadAllTimelines()
        result(nil)
      } else {
        result(Errors.notSupported)
      }
    case .setGroupID:
      guard let arguments = call.arguments as? String else {
        result(Errors.wrongArguments)
        return
      }
      Settings.groupId = arguments
      result(nil)
    case .setAppScheme:
      guard let arguments = call.arguments as? String else {
        result(Errors.wrongArguments)
        return
      }
      Settings.appScheme = arguments
      result(nil)
    case .getLaunchedURL:
      result(launchOptionsURL)
    case .saveImageFile:
      guard let arguments = call.arguments as? [String: Any],
            let bytes = (arguments["bytes"] as? FlutterStandardTypedData)?.data else {
        result(Errors.wrongArguments)
        return
      }
      let filename = arguments["filename"] as? String
      if let path = ImageFileManager.shared.saveImage(bytes, filename: filename) {
        result(path)
      } else {
        result(Errors.wrongArguments)
      }
    case .deleteImageFiles:
      guard let paths = call.arguments as? [String] else {
        result(Errors.wrongArguments)
        return
      }
      ImageFileManager.shared.deleteImages(paths)
      result(nil)
    case .migrateToFileStorage:
      let changed = MigrationHelper.shared.migrateBase64ToFiles()
      result(changed)
    case .getImageBasePath:
      result(ImageFileManager.shared.getBasePath())
    }
  }
}

// MARK: - UIApplication

extension SimpleWidgetPlugin {

  public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
    guard let url = launchOptions[UIApplication.LaunchOptionsKey.url] as? URL else {
      return true
    }

    if check(url: url) {
      launchOptionsURL = url
    }
    return true
  }

  public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    guard check(url: url) else {
      return false
    }

    eventSink?(url.absoluteString)
    return false
  }

  @discardableResult
  private func check(url: URL) -> Bool {
    url.scheme == Settings.appScheme
  }
}

// MARK: - FlutterStreamHandler

extension SimpleWidgetPlugin: FlutterStreamHandler {
  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    eventSink = events
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }
}
