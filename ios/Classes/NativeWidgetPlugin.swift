import Flutter
import UIKit
import WidgetKit

public class NativeWidgetPlugin: NSObject, FlutterPlugin {

  // MARK: - Private Properties

  private var eventSink: FlutterEventSink?
  private var launchOptionsURL: URL?

  // MARK: -

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "native_widget", binaryMessenger: registrar.messenger())
    let instance = NativeWidgetPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    let eventChannel = FlutterEventChannel(name: "native_widget/events", binaryMessenger: registrar.messenger())
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
      AppUserDefaults.shared.save(arguments)
      result(nil)
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
    }
  }
}

// MARK: - UIApplication

extension NativeWidgetPlugin {

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

extension NativeWidgetPlugin: FlutterStreamHandler {
  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    eventSink = events
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }
}
