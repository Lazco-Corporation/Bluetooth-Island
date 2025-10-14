//
//  Constants.swift
//  Bluetooth-Island
//
//  App-wide constants for consistent styling and configuration
//

import Foundation

/// Application-wide constants
enum Constants {
  /// SF Symbol icon names
  enum Icons {
    static let defaultDevice = "antenna.radiowaves.left.and.right"
    static let checkmark = "checkmark"
    static let timer = "timer"
  }

  /// Visual design constants
  enum Design {
    /// Dynamic Island icon sizes
    enum DynamicIsland {
      static let expandedIconSize: CGFloat = 36
      static let expandedIconFrameSize: CGFloat = 50
    }

    /// Lock screen icon sizes
    enum LockScreen {
      static let iconSize: CGFloat = 28
      static let iconFrameSize: CGFloat = 40
      static let padding: CGFloat = 16
    }

    /// Checkmark animation
    enum Animation {
      static let checkmarkDuration: TimeInterval = 0.8
    }
  }

  /// Logger configuration
  enum Logging {
    static let subsystem = "com.lazco.BluetoothIsland"

    enum Category {
      static let intent = "Intent"
      static let notification = "NotificationManager"
      static let liveActivity = "LiveActivity"
    }
  }

  /// App Group for sharing data between app and widget
  enum AppGroup {
    static let identifier = "group.com.lazco.BluetoothIsland"
  }

  /// Notification categories
  enum Notification {
    static let deviceConnectionCategory = "DEVICE_CONNECTION"
    static let defaultTitle = "Connected to"
    static let minTriggerInterval: TimeInterval = 0.1
  }
}
