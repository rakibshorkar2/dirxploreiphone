import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterStreamHandler {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController

    // Download Method Channel
    let downloadChannel = FlutterMethodChannel(name: "com.dirxplore/downloads",
                                              binaryMessenger: controller.binaryMessenger)
    downloadChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      self.handleDownloadCall(call: call, result: result)
    })

    // Download Event Channel (Progress)
    let eventChannel = FlutterEventChannel(name: "com.dirxplore/downloads_event",
                                          binaryMessenger: controller.binaryMessenger)
    eventChannel.setStreamHandler(self)

    // Keychain Method Channel
    let keychainChannel = FlutterMethodChannel(name: "com.dirxplore/keychain",
                                              binaryMessenger: controller.binaryMessenger)
    keychainChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      self.handleKeychainCall(call: call, result: result)
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func handleDownloadCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any]
    switch call.method {
    case "startDownload":
      if let urlStr = args?["url"] as? String, let url = URL(string: urlStr),
         let filename = args?["filename"] as? String {
        let id = args?["id"] as? String ?? String(urlStr.hashValue)
        BackgroundDownloadManager.shared.startDownload(url: url, filename: filename, id: id)
        result(nil)
      } else {
        result(FlutterError(code: "INVALID_ARGS", message: "Missing URL or filename", details: nil))
      }
    case "pauseDownload":
      if let id = args?["id"] as? String {
        BackgroundDownloadManager.shared.pauseDownload(id: id)
        result(nil)
      }
    case "resumeDownload":
      if let id = args?["id"] as? String {
        BackgroundDownloadManager.shared.resumeDownload(id: id)
        result(nil)
      }
    case "cancelDownload":
      if let id = args?["id"] as? String {
        BackgroundDownloadManager.shared.cancelDownload(id: id)
        result(nil)
      }
    case "getActiveDownloads":
      result(BackgroundDownloadManager.shared.getActiveTasks())
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func handleKeychainCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any]
    let service = "com.dirxplore.proxy"
    switch call.method {
    case "saveCredentials":
      if let host = args?["host"] as? String,
         let user = args?["username"] as? String,
         let pass = args?["password"] as? String {
        let data = try? JSONEncoder().encode(["user": user, "pass": pass])
        let status = KeychainManager.shared.save(service: service, account: host, data: data ?? Data())
        result(status == errSecSuccess)
      }
    case "getCredentials":
      if let host = args?["host"] as? String {
        if let data = KeychainManager.shared.load(service: service, account: host),
           let dict = try? JSONDecoder().decode([String: String].self, from: data) {
          result(dict)
        } else {
          result(nil)
        }
      }
    case "deleteCredentials":
      if let host = args?["host"] as? String {
        KeychainManager.shared.delete(service: service, account: host)
        result(nil)
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // MARK: - FlutterStreamHandler
  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    BackgroundDownloadManager.shared.progressSink = events
    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    BackgroundDownloadManager.shared.progressSink = nil
    return nil
  }
}
