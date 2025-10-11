//
//  TriggerNotificationIntent.swift
//  Bluetooth-Island
//
//  App Intent for sending notifications via Shortcuts
//

import AppIntents
import Foundation
import os.log

/// Notification Intent that sends a standard notification
struct TriggerNotificationIntent: AppIntent {
  // MARK: - Intent Configuration

  static var title: LocalizedStringResource = "Show Notification for Device"
  static var description = IntentDescription("Sends a notification to Notification Center. Configure the trigger device in Shortcuts Automation.")

  // Run in background without opening the app
  static var openAppWhenRun: Bool = false

  // MARK: - Parameters

  @Parameter(title: "Device Name", description: "Name of the connected device")
  var deviceName: String

  // MARK: - Logger

  private let logger = Logger(subsystem: "com.lazco.BluetoothIsland", category: "TriggerNotificationIntent")

  // MARK: - Perform

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
