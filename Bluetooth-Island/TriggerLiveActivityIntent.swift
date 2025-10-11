//
//  TriggerLiveActivityIntent.swift
//  Bluetooth-Island
//
//  App Intent for triggering Live Activities or Notifications via Shortcuts
//

import ActivityKit
import AppIntents
import Foundation
import os.log

/// Errors that can occur during Live Activity triggering
enum LiveActivityError: Error, CustomLocalizedStringResourceConvertible {
  case disabled

  var localizedStringResource: LocalizedStringResource {
    switch self {
    case .disabled:
      return "Live Activities are disabled. Enable them in Settings."
    }
  }
}


/// Live Activity Intent that triggers a Live Activity from Shortcuts automation in the background
struct TriggerLiveActivityIntent: LiveActivityIntent {
  // MARK: - Intent Configuration

  static var title: LocalizedStringResource = "Show Live Activity for Device"
  static var description = IntentDescription("Displays a Live Activity when connected to a device.")

  // Run in background without opening the app
  static var openAppWhenRun: Bool = false

  // MARK: - Parameters

  @Parameter(title: "Device Name", description: "Name of the connected device")
  var deviceName: String

  // MARK: - Logger

  private let logger = Logger(subsystem: "com.lazco.BluetoothIsland", category: "TriggerLiveActivityIntent")

  // MARK: - Perform (LiveActivityIntent)

  @MainActor
  func perform() async throws -> some IntentResult & ProvidesDialog {
    logger.info("📱 [Shortcut] Triggered Live Activity for: \(self.deviceName)")
    print("📱 [Shortcut] Triggered Live Activity for: \(deviceName)")

    // Check if Live Activities are enabled
    guard ActivityAuthorizationInfo().areActivitiesEnabled else {
      logger.error("❌ [Shortcut] Live Activities are disabled in Settings")
      print("❌ [Shortcut] Live Activities are disabled in Settings")
      throw LiveActivityError.disabled
    }

    // Create the activity attributes
    let attributes = BluetoothActivityAttributes(
      sessionId: UUID().uuidString
    )

    // Determine device type
    let deviceType = determineDeviceType(from: deviceName)

    // Create the initial content state
    let contentState = BluetoothActivityAttributes.ContentState(
      deviceName: deviceName,
      connectionTime: Date(),
      deviceType: deviceType
    )

    // Create the activity content
    let content = ActivityContent(
      state: contentState,
      staleDate: nil,
      relevanceScore: 1.0
    )

    // Start the Live Activity
    let activity = try Activity.request(
      attributes: attributes,
      content: content,
      pushType: nil
    )

    logger.info("✅ [Shortcut] Live Activity started successfully")
    print("✅ [Shortcut] Live Activity started for: \(deviceName)")

    // Schedule automatic dismissal after 2 seconds
    Task {
      try? await Task.sleep(nanoseconds: 2_000_000_000)
      let finalContent = ActivityContent(state: contentState, staleDate: Date())
      await activity.end(finalContent, dismissalPolicy: .immediate)
      print("🛑 [LiveActivity] Ended for: \(deviceName)")
    }

    return .result(dialog: "Showing \(deviceName) in Dynamic Island")
  }

  // MARK: - Helper Methods

  private func determineDeviceType(from deviceName: String) -> String {
    let lowercased = deviceName.lowercased()

    if lowercased.contains("airpods") {
      return "airpods"
    } else if lowercased.contains("beats") {
      return "beats"
    } else if lowercased.contains("watch") {
      return "watch"
    } else if lowercased.contains("keyboard") {
      return "keyboard"
    } else if lowercased.contains("mouse") {
      return "mouse"
    } else if lowercased.contains("speaker") {
      return "speaker"
    } else {
      return "generic"
    }
  }
}

/// Notification Intent that sends a standard notification
struct TriggerNotificationIntent: AppIntent {
  static var title: LocalizedStringResource = "Show Notification for Device"
  static var description = IntentDescription("Sends a notification to Notification Center")
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
