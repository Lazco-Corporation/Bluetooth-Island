//
//  BluetoothActivityAttributes.swift
//  Bluetooth-Island
//
//  Live Activity data model for Bluetooth connection events
//

import ActivityKit
import Foundation

/// ActivityAttributes defining the data structure for Bluetooth connection Live Activities
struct BluetoothActivityAttributes: ActivityAttributes {
  /// Dynamic content that can be updated during the activity's lifetime
  struct ContentState: Codable, Hashable {
    /// The name of the connected device to display
    var deviceName: String

    /// The connection timestamp for animation timing
    var connectionTime: Date

    /// Device type identifier for icon selection (e.g., "airpods", "watch")
    var deviceType: String?
  }

  /// Unique identifier for this activity session
  /// Used to distinguish between multiple activity instances
  var sessionId: String
}
