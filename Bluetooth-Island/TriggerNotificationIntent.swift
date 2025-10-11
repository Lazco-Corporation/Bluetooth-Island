import ActivityKit
import AppIntents
import Foundation
import os.log

/// Notification Intent that sends a standard notification
struct TriggerNotificationIntent: AppIntent {
  static var title: LocalizedStringResource = "Show Notification for Device"
  static var description = IntentDescription("Sends a notification when connected to a device.")
  static var openAppWhenRun: Bool = false

  @Parameter(title: "Device Name", description: "Name of the connected device")
  var deviceName: String

  private let logger = Logger(subsystem: "com.lazco.BluetoothIsland", category: "TriggerNotificationIntent")

  @MainActor
  func perform() async throws -> some IntentResult {
    logger.info("📱 [Shortcut] Triggered Notification for: \(self.deviceName)")
    print("📱 [Shortcut] Triggered Notification for: \(deviceName)")

    let notificationManager = NotificationManager()
    await notificationManager.sendConnectionNotification(deviceName: deviceName)

    logger.info("✅ [Shortcut] Notification sent successfully")
    print("✅ [Shortcut] Notification sent successfully")

    return .result()
  }
}
