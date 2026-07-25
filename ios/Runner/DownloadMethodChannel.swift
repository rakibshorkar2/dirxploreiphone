import Flutter
import Foundation

/// Bridges Flutter ↔ Native iOS download operations via MethodChannel.
/// Channel name: com.dirxplore/downloads
/// Progress channel: com.dirxplore/download_progress (EventChannel)
class DownloadMethodChannel: NSObject, FlutterStreamHandler {

    static let shared = DownloadMethodChannel()
    private let channelName = "com.dirxplore/downloads"
    private let eventChannelName = "com.dirxplore/download_progress"

    private var methodChannel: FlutterMethodChannel?
    private var eventChannel: FlutterEventChannel?
    private var eventSink: FlutterEventSink?

    private override init() { super.init() }

    func register(messenger: FlutterBinaryMessenger, appDelegate: AppDelegate) {
        methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: messenger)
        eventChannel = FlutterEventChannel(name: eventChannelName, binaryMessenger: messenger)
        eventChannel?.setStreamHandler(self)

        // Set up callbacks from BackgroundDownloadManager → Flutter
        BackgroundDownloadManager.shared.setCallbacks(
            progress: { [weak self] id, downloaded, total, speed in
                self?.sendProgress(id: id, downloaded: downloaded, total: total, speed: speed)
            },
            completion: { [weak self] id, url in
                self?.methodChannel?.invokeMethod("onDownloadCompleted", arguments: [
                    "id": id,
                    "path": url?.path ?? ""
                ])
            },
            failure: { [weak self] id, error in
                self?.methodChannel?.invokeMethod("onDownloadFailed", arguments: [
                    "id": id,
                    "error": error
                ])
            },
            paused: { [weak self] id, resumeData in
                let resumePath = resumeData != nil ? ResumeDataManager.shared.resumeDataPath(forId: id) : nil
                self?.methodChannel?.invokeMethod("onDownloadPaused", arguments: [
                    "id": id,
                    "resumeDataPath": resumePath ?? ""
                ])
            }
        )

        // Handle method calls from Flutter
        methodChannel?.setMethodCallHandler { [weak self] call, result in
            self?.handleMethodCall(call, result: result)
        }
    }

    private func handleMethodCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any] ?? [:]

        switch call.method {
        case "startDownload":
            guard let id = args["id"] as? String,
                  let url = args["url"] as? String,
                  let filename = args["filename"] as? String else {
                result(FlutterError(code: "INVALID_ARGS", message: "Missing required arguments", details: nil))
                return
            }
            let resumePath = args["resumeDataPath"] as? String
            BackgroundDownloadManager.shared.startDownload(
                id: id, url: url, filename: filename, resumeDataPath: resumePath
            )
            result(nil)

        case "pauseDownload":
            guard let id = args["id"] as? String else {
                result(FlutterError(code: "INVALID_ARGS", message: "Missing id", details: nil))
                return
            }
            BackgroundDownloadManager.shared.pauseDownload(id: id)
            result(nil)

        case "cancelDownload":
            guard let id = args["id"] as? String else {
                result(FlutterError(code: "INVALID_ARGS", message: "Missing id", details: nil))
                return
            }
            BackgroundDownloadManager.shared.cancelDownload(id: id)
            result(nil)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func sendProgress(id: String, downloaded: Int64, total: Int64, speed: Double) {
        let progress = total > 0 ? Double(downloaded) / Double(total) : 0
        let data: [String: Any] = [
            "id": id,
            "downloadedBytes": downloaded,
            "totalBytes": total,
            "progress": progress,
            "speed": speed
        ]
        DispatchQueue.main.async {
            self.eventSink?(data)
            // Also invoke via method channel for reliability
            self.methodChannel?.invokeMethod("onDownloadProgress", arguments: data)
        }
    }

    // ─── FlutterStreamHandler ──────────────────────────────────────
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}
