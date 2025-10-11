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
  /// Static properties that don't change during the activity's lifetime
  public struct ContentState: Codable, Hashable {
    /// The name of the connected Bluetooth device
    var deviceName: String

    /// The connection timestamp
    var connectionTime: Date

    /// Optional device type icon identifier
    var deviceType: String?
  }

  /// Unique identifier for this activity session
  var sessionId: String
}
