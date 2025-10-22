//
//  DeviceType.swift
//  Bluetooth-Island
//
//  Device type options for App Intents
//

import AppIntents

/// Device type options for selecting icons in Live Activities and Notifications
enum DeviceType: String, AppEnum {
  case airpods = "AirPods"
  case beats = "Beats"
  case watch = "Apple Watch"
  case keyboard = "Keyboard"
  case mouse = "Mouse"
  case speaker = "Speaker"
  case headphones = "Headphones"
  case car = "Car"
  case phone = "Phone"
  case tablet = "Tablet"
  case computer = "Computer"
  case tv = "Apple TV"
  case generic = "Generic Device"

  static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Device Type")

  static var caseDisplayRepresentations: [DeviceType: DisplayRepresentation] = [
    .airpods: DisplayRepresentation(title: "AirPods", image: .init(systemName: "airpodspro")),
    .beats: DisplayRepresentation(title: "Beats", image: .init(systemName: "beats.headphones")),
    .watch: DisplayRepresentation(title: "Apple Watch", image: .init(systemName: "applewatch")),
    .keyboard: DisplayRepresentation(title: "Keyboard", image: .init(systemName: "keyboard")),
    .mouse: DisplayRepresentation(title: "Mouse", image: .init(systemName: "computermouse")),
    .speaker: DisplayRepresentation(title: "Speaker", image: .init(systemName: "hifispeaker")),
    .headphones: DisplayRepresentation(title: "Headphones", image: .init(systemName: "headphones")),
    .car: DisplayRepresentation(title: "Car", image: .init(systemName: "car")),
    .phone: DisplayRepresentation(title: "Phone", image: .init(systemName: "iphone")),
    .tablet: DisplayRepresentation(title: "Tablet", image: .init(systemName: "ipad")),
    .computer: DisplayRepresentation(title: "Computer", image: .init(systemName: "macbook")),
    .tv: DisplayRepresentation(title: "Apple TV", image: .init(systemName: "tv")),
    .generic: DisplayRepresentation(title: "Generic Device", image: .init(systemName: Constants.Icons.defaultDevice))
  ]

  /// Returns the internal device type string for use in BluetoothActivityAttributes
  /// Uses lowercase for consistency with DeviceIconMapper
  var deviceTypeString: String {
    switch self {
    case .airpods: return "airpods"
    case .beats: return "beats"
    case .watch: return "watch"
    case .keyboard: return "keyboard"
    case .mouse: return "mouse"
    case .speaker: return "speaker"
    case .headphones: return "headphones"
    case .car: return "car"
    case .phone: return "iphone"
    case .tablet: return "ipad"
    case .computer: return "mac"
    case .tv: return "tv"
    case .generic: return "generic"
    }
  }

  /// Returns the SF Symbol name for this device type
  /// Delegates to DeviceIconMapper for consistency
  var iconName: String {
    DeviceIconMapper.icon(for: deviceTypeString)
  }
}
