//
//  DeviceType.swift
//  Bluetooth-Island
//
//  Device type options for App Intents
//

import AppIntents

/// Device type options for selecting icons in Live Activities and Notifications
enum DeviceType: String, AppEnum {
  case bluetooth = "Bluetooth"
  case airpods = "AirPods"
  case beats = "Beats"
  case watch = "Apple Watch"
  case keyboard = "Keyboard"
  case mouse = "Mouse"
  case speaker = "Speaker"
  case headphones = "Headphones"
  case car = "Car"
  case iphone = "iPhone"
  case ipad = "iPad"
  case mac = "Mac"
  case tv = "Apple TV"
  case generic = "Generic Device"

  static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Device Type")

  static var caseDisplayRepresentations: [DeviceType: DisplayRepresentation] = [
    .bluetooth: DisplayRepresentation(
      title: "Bluetooth",
      image: .init(systemName: "bluetooth")
    ),
    .airpods: DisplayRepresentation(
      title: "AirPods",
      image: .init(systemName: "airpodspro")
    ),
    .beats: DisplayRepresentation(
      title: "Beats",
      image: .init(systemName: "beats.headphones")
    ),
    .watch: DisplayRepresentation(
      title: "Apple Watch",
      image: .init(systemName: "applewatch")
    ),
    .keyboard: DisplayRepresentation(
      title: "Keyboard",
      image: .init(systemName: "keyboard")
    ),
    .mouse: DisplayRepresentation(
      title: "Mouse",
      image: .init(systemName: "computermouse")
    ),
    .speaker: DisplayRepresentation(
      title: "Speaker",
      image: .init(systemName: "hifispeaker")
    ),
    .headphones: DisplayRepresentation(
      title: "Headphones",
      image: .init(systemName: "headphones")
    ),
    .car: DisplayRepresentation(
      title: "Car",
      image: .init(systemName: "car")
    ),
    .iphone: DisplayRepresentation(
      title: "iPhone",
      image: .init(systemName: "iphone")
    ),
    .ipad: DisplayRepresentation(
      title: "iPad",
      image: .init(systemName: "ipad")
    ),
    .mac: DisplayRepresentation(
      title: "Mac",
      image: .init(systemName: "macbook")
    ),
    .tv: DisplayRepresentation(
      title: "Apple TV",
      image: .init(systemName: "tv")
    ),
    .generic: DisplayRepresentation(
      title: "Generic Device",
      image: .init(systemName: "antenna.radiowaves.left.and.right")
    )
  ]

  /// Returns the internal device type string for use in BluetoothActivityAttributes
  var deviceTypeString: String {
    switch self {
    case .bluetooth: return "bluetooth"
    case .airpods: return "airpods"
    case .beats: return "beats"
    case .watch: return "watch"
    case .keyboard: return "keyboard"
    case .mouse: return "mouse"
    case .speaker: return "speaker"
    case .headphones: return "headphones"
    case .car: return "car"
    case .iphone: return "iphone"
    case .ipad: return "ipad"
    case .mac: return "mac"
    case .tv: return "tv"
    case .generic: return "generic"
    }
  }
}
