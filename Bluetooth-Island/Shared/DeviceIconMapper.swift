//
//  DeviceIconMapper.swift
//  Bluetooth-Island
//
//  Shared utility for mapping device types to SF Symbol icons
//  Used by both the main app and widget extension
//

import Foundation

/// Utility for mapping device type strings to SF Symbol names
enum DeviceIconMapper {
  /// Maps a device type string to its corresponding SF Symbol name
  /// - Parameter deviceType: The device type string (e.g., "airpods", "watch")
  /// - Returns: SF Symbol name for the device icon
  static func icon(for deviceType: String?) -> String {
    guard let type = deviceType else {
      return Constants.Icons.defaultDevice
    }

    switch type.lowercased() {
    case "airpods":
      return "airpodspro"
    case "beats":
      return "beats.headphones"
    case "watch":
      return "applewatch"
    case "keyboard":
      return "keyboard"
    case "mouse":
      return "computermouse"
    case "speaker":
      return "hifispeaker"
    case "headphones":
      return "headphones"
    case "car":
      return "car"
    case "iphone":
      return "iphone"
    case "ipad":
      return "ipad"
    case "mac":
      return "macbook"
    case "tv":
      return "tv"
    case "generic":
      return Constants.Icons.defaultDevice
    default:
      return Constants.Icons.defaultDevice
    }
  }
}
