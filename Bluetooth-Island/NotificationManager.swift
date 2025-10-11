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

  private let logger = Logger(subsystem: "com.lazco.BluetoothIsland", category: "NotificationManager")

  // MARK: - Authorization

  /// Requests notification permission from the user
  func requestAuthorization() async -> Bool {
    logger.info("Requesting notification authorization")
    print("🔔 [Notification] Requesting authorization...")

    do {
      let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])

      if granted {
        logger.info("Notification authorization granted")
        print("✅ [Notification] Authorization granted")
      } else {
        logger.warning("Notification authorization denied")
        print("❌ [Notification] Authorization denied")
      }

      return granted
    } catch {
      logger.error("Failed to request notification authorization: \(error.localizedDescription)")
      print("⚠️ [Notification] Authorization error: \(error.localizedDescription)")
      return false
    }
  }

  /// Checks if notifications are authorized
  func checkAuthorization() async -> Bool {
    let settings = await UNUserNotificationCenter.current().notificationSettings()
    return settings.authorizationStatus == .authorized
  }

  // MARK: - Send Notification

  /// Sends a notification with device connection information
  func sendConnectionNotification(deviceName: String) async {
    logger.info("Sending connection notification for: \(deviceName)")
    print("📨 [Notification] Sending notification for: \(deviceName)")

    // Check authorization first
    let isAuthorized = await checkAuthorization()

    if !isAuthorized {
      logger.warning("Notifications not authorized, requesting permission")
      print("⚠️ [Notification] Not authorized, requesting permission...")
      let granted = await requestAuthorization()

      if !granted {
        logger.error("Cannot send notification - permission denied")
        print("❌ [Notification] Cannot send - permission denied")
        return
      }
    }

    // Create notification content
    let content = UNMutableNotificationContent()
    content.title = "Device Connected"
    content.body = deviceName
    content.sound = .default

    // Set notification category for potential future customization
    content.categoryIdentifier = "DEVICE_CONNECTION"

    // Create trigger (immediate delivery)
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)

    // Create request
    let request = UNNotificationRequest(
      identifier: UUID().uuidString,
      content: content,
      trigger: trigger
    )

    // Add notification
    do {
      try await UNUserNotificationCenter.current().add(request)
      logger.info("Notification sent successfully")
      print("✅ [Notification] Sent successfully")
    } catch {
      logger.error("Failed to send notification: \(error.localizedDescription)")
      print("❌ [Notification] Failed to send: \(error.localizedDescription)")
    }
  }

  // MARK: - Helper Methods

  /// Determines device type from device name
  private func determineDeviceType(from deviceName: String) -> String {
    let lowercased = deviceName.lowercased()

    if lowercased.contains("airpods") {
      return "airpods"
    } else if lowercased.contains("watch") {
      return "watch"
    } else if lowercased.contains("iphone") {
      return "iphone"
    } else if lowercased.contains("ipad") {
      return "ipad"
    } else if lowercased.contains("mac") {
      return "mac"
    } else if lowercased.contains("headphone") || lowercased.contains("headset") {
      return "headphones"
    } else if lowercased.contains("speaker") {
      return "speaker"
    } else if lowercased.contains("car") {
      return "car"
    } else if lowercased.contains("tv") {
      return "tv"
    } else {
      return "generic"
    }
  }

  /// Returns SF Symbol name for device type
  private func deviceTypeIcon(_ deviceType: String) -> String? {
    switch deviceType {
    case "airpods":
      return "airpodspro"
    case "watch":
      return "applewatch"
    case "iphone":
      return "iphone"
    case "ipad":
      return "ipad"
    case "mac":
      return "macbook"
    case "headphones":
      return "headphones"
    case "speaker":
      return "hifispeaker"
    case "car":
      return "car"
    case "tv":
      return "tv"
    default:
      return "antenna.radiowaves.left.and.right"
    }
  }
}
