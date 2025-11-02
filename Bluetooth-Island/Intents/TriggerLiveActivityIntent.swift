//
//  TriggerLiveActivityIntent.swift
//  Bluetooth-Island
//
//  App Intent for triggering Live Activities via Shortcuts
//

import ActivityKit
import AppIntents
import Foundation
import os.log

/// Errors that can occur during Live Activity operations
enum LiveActivityError: Error, CustomLocalizedStringResourceConvertible {
  case disabled
  case activityRequestFailed

  var localizedStringResource: LocalizedStringResource {
    switch self {
    case .disabled:
      "Live Activities are disabled. Enable them in Settings > \(Bundle.main.displayName ?? "Bluetooth Island")."
    case .activityRequestFailed:
      "Failed to start Live Activity. Please try again."
    }
  }
}

/// Live Activity Intent that triggers a Live Activity from Shortcuts automation in the background
struct TriggerLiveActivityIntent: LiveActivityIntent {
  // MARK: - Intent Configuration

  static var title: LocalizedStringResource = "Show Live Activity (Dynamic Island)"
  static var description = IntentDescription(
    "Displays a Live Activity in the Dynamic Island. Requires Dynamic Island-compatible device. Perfect for automation triggers."
  )

  // Run in background without opening the app
  static var openAppWhenRun: Bool = false

  // MARK: - Parameters

  @Parameter(
    title: "Device Name",
    description: "Text to display (e.g., \"AirPods Pro\", \"Office\", \"Home\")",
    inputOptions: .init(capitalizationType: .words)
  )
  var deviceName: String

  @Parameter(
    title: "Icon",
    description: "Choose an icon that represents your device",
    default: .generic
  )
  var deviceType: DeviceType

  @Parameter(
    title: "Display Duration",
    description: "How long the notification stays visible",
    default: .fiveSeconds
  )
  var duration: Duration

  // MARK: - Logger

  private let logger = Logger(
    subsystem: Constants.Logging.subsystem,
    category: Constants.Logging.Category.intent
  )

  // MARK: - Perform (LiveActivityIntent)

  @MainActor
  func perform() async throws -> some IntentResult & ProvidesDialog {
    logger.info("📱 Triggered Live Activity: \(deviceName, privacy: .public)")

    // Check if Live Activities are enabled
    guard ActivityAuthorizationInfo().areActivitiesEnabled else {
      logger.error("❌ Live Activities are disabled in Settings")
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
      staleDate: nil
    )

    // Start the Live Activity
    do {
      let activity = try Activity.request(
        attributes: attributes,
        content: content,
        pushType: nil
      )

      logger.info("✅ Live Activity started: \(activity.id)")

      // Schedule automatic dismissal after configured duration
      Task {
        try? await Task.sleep(nanoseconds: duration.nanoseconds)
        let finalContent = ActivityContent(state: contentState, staleDate: Date())
        await activity.end(finalContent, dismissalPolicy: .immediate)
        logger.info(
          "🛑 Live Activity ended: \(deviceName, privacy: .public) after \(duration.seconds, privacy: .public)s"
        )
      }

      return .result(dialog: "Showing \(deviceName) in Dynamic Island")
    } catch {
      logger.error("❌ Failed to start Live Activity: \(error.localizedDescription)")
      throw LiveActivityError.activityRequestFailed
    }
  }
}
