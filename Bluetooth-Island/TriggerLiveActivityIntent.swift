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

  static var title: LocalizedStringResource = "Show Live Activity (Dynamic Island)"
  static var description = IntentDescription("Displays a Live Activity. Requires iPhone 14 Pro or newer. Perfect for automation triggers.")

  // Run in background without opening the app
  static var openAppWhenRun: Bool = false

  // MARK: - Parameters

  @Parameter(title: "Device Name", description: "Text to display (e.g., \"AirPods Pro\", \"Office\", \"Home\")")
  var deviceName: String

  @Parameter(
    title: "Icon",
    description: "Choose an icon that represents your device",
    default: .bluetooth
  )
  var deviceType: DeviceType

  @Parameter(
    title: "Display Duration",
    description: "How long the notification stays visible",
    default: .fiveSeconds
  )
  var duration: Duration

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

    // Create the initial content state
    let contentState = BluetoothActivityAttributes.ContentState(
      deviceName: deviceName,
      connectionTime: Date(),
      deviceType: deviceType.deviceTypeString
    )

    // Create the activity content
    let content = ActivityContent(
      state: contentState,
      staleDate: nil,
    )

    // Start the Live Activity
    let activity = try Activity.request(
      attributes: attributes,
      content: content,
      pushType: nil
    )

    logger.info("✅ [Shortcut] Live Activity started successfully")
    print("✅ [Shortcut] Live Activity started for: \(deviceName)")

    // Schedule automatic dismissal after configured duration
    Task {
      try? await Task.sleep(nanoseconds: duration.nanoseconds)
      let finalContent = ActivityContent(state: contentState, staleDate: Date())
      await activity.end(finalContent, dismissalPolicy: .immediate)
      print("🛑 [LiveActivity] Ended for: \(deviceName) after \(duration.seconds)s")
    }

    return .result(dialog: "Showing \(deviceName) in Dynamic Island")
  }
}
