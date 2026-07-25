import Foundation
import UserNotifications

/// Handles local push notifications for download completion/failure.
class NotificationHandler {
    static let shared = NotificationHandler()
    private let center = UNUserNotificationCenter.current()

    private init() {
        requestPermission()
    }

    func requestPermission() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }

    func sendDownloadCompleteNotification(filename: String) {
        let content = UNMutableNotificationContent()
        content.title = "Download Complete"
        content.body = "\"\(filename)\" has been downloaded."
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: "download_complete_\(filename)",
            content: content,
            trigger: nil
        )
        center.add(request, withCompletionHandler: nil)
    }

    func sendDownloadFailedNotification(filename: String, error: String) {
        let content = UNMutableNotificationContent()
        content.title = "Download Failed"
        content.body = "\"\(filename)\" failed: \(error)"
        content.sound = .default

        let request = UNNotificationRequest(
            identifier: "download_failed_\(filename)",
            content: content,
            trigger: nil
        )
        center.add(request, withCompletionHandler: nil)
    }
}
