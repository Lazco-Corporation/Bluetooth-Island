//
//  LiveActivityManager.swift
//  Bluetooth-Island
//
//  Manages ActivityKit Live Activities for Bluetooth connection events
//

import ActivityKit
import Foundation
import os.log

/// Manages the lifecycle of Bluetooth connection Live Activities
actor LiveActivityManager {
  // MARK: - Properties

  /// Current active activity
  private var currentActivity: Activity<BluetoothActivityAttributes>?

  /// Logger for debugging
  private let logger = Logger(subsystem: "com.lazco.BluetoothIsland", category: "LiveActivityManager")

  // MARK: - Public Methods

  /// Starts a Live Activity for a Bluetooth connection event
  /// - Parameter deviceName: The name of the connected device
  /// - Note: Authorization check should be done by caller before calling this method
  func startBluetoothConnectionActivity(deviceName: String) async {
    // End any existing activity first
    await endCurrentActivity()

    do {
      // Create the activity attributes
      let attributes = BluetoothActivityAttributes(
        sessionId: UUID().uuidString
      )

      // Create the initial content state
      let contentState = BluetoothActivityAttributes.ContentState(
        deviceName: deviceName,
        connectionTime: Date(),
        deviceType: determineDeviceType(from: deviceName)
      )

      // Create the activity content
      let content = ActivityContent(
        state: contentState,
        staleDate: nil,
        relevanceScore: 1.0
      )

      // Start the Live Activity (no push notifications)
      currentActivity = try Activity.request(
        attributes: attributes,
        content: content,
        pushType: nil
      )

      logger.info("✅ Started Live Activity for device: \(deviceName)")
      print("🎬 [LiveActivity] Started for: \(deviceName)")

      // Schedule automatic dismissal after 2 seconds
      Task {
        try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        await endCurrentActivity()
      }

    } catch {
      logger.error("❌ Failed to start Live Activity: \(error.localizedDescription)")
      print("❌ [LiveActivity] Failed to start: \(error.localizedDescription)")
    }
  }

  /// Ends the current Live Activity
  func endCurrentActivity() async {
    guard let activity = currentActivity else { return }

    let finalContent = ActivityContent(
      state: activity.content.state,
      staleDate: Date()
    )

    await activity.end(finalContent, dismissalPolicy: .immediate)
    currentActivity = nil

    logger.info("Ended Live Activity")
  }

  // MARK: - Private Methods

  /// Determines device type from device name for icon selection
  /// - Parameter deviceName: The device name
  /// - Returns: A device type identifier string
  private func determineDeviceType(from deviceName: String) -> String {
    let lowercasedName = deviceName.lowercased()

    if lowercasedName.contains("airpods") {
      return "airpods"
    } else if lowercasedName.contains("beats") {
      return "beats"
    } else if lowercasedName.contains("watch") {
      return "watch"
    } else if lowercasedName.contains("keyboard") {
      return "keyboard"
    } else if lowercasedName.contains("mouse") {
      return "mouse"
    } else if lowercasedName.contains("speaker") {
      return "speaker"
    } else {
      return "generic"
    }
  }
}
