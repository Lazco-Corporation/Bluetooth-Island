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

  static var title: LocalizedStringResource = "Send Notification"
  static var description = IntentDescription(
    "Sends a persistent notification to Notification Center. Works on all iPhones. Requires notification permission."
  )

  // Run in background without opening the app
  static var openAppWhenRun: Bool = false

  // MARK: - Parameters

  @Parameter(
    title: "Device Name",
    description: "Text to display in notification (e.g., \"AirPods Pro\", \"Office\", \"Home\")",
    inputOptions: .init(capitalizationType: .words)
  )
  var deviceName: String

  @Parameter(
    title: "Icon",
    description: "Choose an icon that represents your device",
    default: .generic
  )
  var deviceType: DeviceType

  // MARK: - Logger

  private let logger = Logger(
    subsystem: Constants.Logging.subsystem,
    category: Constants.Logging.Category.intent
  )

  // MARK: - Perform

  @MainActor
  func perform() async throws -> some IntentResult {
    logger.info("📱 Triggered Notification: \(deviceName, privacy: .public)")

    let notificationManager = NotificationManager()
    await notificationManager.sendConnectionNotification(deviceName: deviceName)

    logger.info("✅ Notification sent: \(deviceName, privacy: .public)")

    return .result()
  }
}
