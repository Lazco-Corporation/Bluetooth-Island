//
//  NotificationManager.swift
//  Bluetooth-Island
//
//  Manages user notifications
//

import Foundation
import UserNotifications
import os.log

/// Manages notification permissions and delivery
actor NotificationManager {
  // MARK: - Properties

  private let logger = Logger(
    subsystem: Constants.Logging.subsystem,
    category: Constants.Logging.Category.notification
  )

  // MARK: - Authorization

  /// Requests notification permission from the user
  /// - Returns: `true` if permission was granted, `false` otherwise
  func requestAuthorization() async -> Bool {
    logger.info("Requesting notification authorization")

    do {
      let granted = try await UNUserNotificationCenter.current()
        .requestAuthorization(options: [.alert, .sound, .badge])

      if granted {
        logger.info("✅ Notification authorization granted")
      } else {
        logger.warning("❌ Notification authorization denied")
      }

      return granted
    } catch {
      logger.error("⚠️ Authorization error: \(error.localizedDescription)")
      return false
    }
  }

  /// Checks if notifications are currently authorized
  /// - Returns: `true` if authorized, `false` otherwise
  func checkAuthorization() async -> Bool {
    let settings = await UNUserNotificationCenter.current().notificationSettings()
    return settings.authorizationStatus == .authorized
  }

  // MARK: - Send Notification

  /// Sends a notification with device connection information
  /// - Parameter deviceName: The name of the device to display in the notification
  func sendConnectionNotification(deviceName: String) async {
    logger.info("Sending notification: \(deviceName, privacy: .public)")

    // Check authorization first
    let isAuthorized = await checkAuthorization()

    if !isAuthorized {
      logger.warning("⚠️ Not authorized, requesting permission")
      let granted = await requestAuthorization()

      guard granted else {
        logger.error("❌ Cannot send notification - permission denied")
        return
      }
    }

    // Create notification content
    let content = UNMutableNotificationContent()
    content.title = Constants.Notification.defaultTitle
    content.body = deviceName
    content.sound = .default
    content.categoryIdentifier = Constants.Notification.deviceConnectionCategory

    // Create trigger (immediate delivery)
    let trigger = UNTimeIntervalNotificationTrigger(
      timeInterval: Constants.Notification.minTriggerInterval,
      repeats: false
    )

    // Create request with unique identifier
    let request = UNNotificationRequest(
      identifier: UUID().uuidString,
      content: content,
      trigger: trigger
    )

    // Add notification
    do {
      try await UNUserNotificationCenter.current().add(request)
      logger.info("✅ Notification sent successfully")
    } catch {
      logger.error("❌ Failed to send notification: \(error.localizedDescription)")
    }
  }
}
