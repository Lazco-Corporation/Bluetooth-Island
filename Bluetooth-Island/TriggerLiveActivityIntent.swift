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
  static var description = IntentDescription("Displays a Live Activity when connected to a device. Configure the trigger device in Shortcuts Automation.")

  // Run in background without opening the app
  static var openAppWhenRun: Bool = false

  // MARK: - Parameters

  @Parameter(title: "Device Name", description: "Name of the connected device")
  var deviceName: String

  @Parameter(
    title: "Device Type",
    description: "Type of device for icon display",
    default: .generic
  )
  var deviceType: DeviceType

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

    Task {
      try? await Task.sleep(nanoseconds: 5_000_000_000)
      let finalContent = ActivityContent(state: contentState, staleDate: Date())
      await activity.end(finalContent, dismissalPolicy: .immediate)
      print("🛑 [LiveActivity] Ended for: \(deviceName)")
    }

    return .result(dialog: "Showing \(deviceName) in Dynamic Island")
  }
}
