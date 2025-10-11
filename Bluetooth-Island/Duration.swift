//
//  Duration.swift
//  Bluetooth-Island
//
//  Duration options for Live Activity display time
//

import AppIntents

/// Duration options for how long the Live Activity should display
enum Duration: String, AppEnum {
  case oneSecond = "1 second"
  case twoSeconds = "2 seconds"
  case threeSeconds = "3 seconds"
  case fiveSeconds = "5 seconds"
  case tenSeconds = "10 seconds"
  case fifteenSeconds = "15 seconds"

  static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Duration")

  static var caseDisplayRepresentations: [Duration: DisplayRepresentation] = [
    .oneSecond: DisplayRepresentation(
      title: "1 second",
      image: .init(systemName: "timer")
    ),
    .twoSeconds: DisplayRepresentation(
      title: "2 seconds",
      image: .init(systemName: "timer")
    ),
    .threeSeconds: DisplayRepresentation(
      title: "3 seconds",
      image: .init(systemName: "timer")
    ),
    .fiveSeconds: DisplayRepresentation(
      title: "5 seconds",
      image: .init(systemName: "timer")
    ),
    .tenSeconds: DisplayRepresentation(
      title: "10 seconds",
      image: .init(systemName: "timer")
    ),
    .fifteenSeconds: DisplayRepresentation(
      title: "15 seconds",
      image: .init(systemName: "timer")
    ),
  ]

  /// Returns the duration in nanoseconds for Task.sleep
  var nanoseconds: UInt64 {
    switch self {
    case .oneSecond:
      return 1_000_000_000
    case .twoSeconds:
      return 2_000_000_000
    case .threeSeconds:
      return 3_000_000_000
    case .fiveSeconds:
      return 5_000_000_000
    case .tenSeconds:
      return 10_000_000_000
    case .fifteenSeconds:
      return 15_000_000_000
    }
  }

  /// Returns the duration in seconds as a Double
  var seconds: Double {
    switch self {
    case .oneSecond:
      return 1.0
    case .twoSeconds:
      return 2.0
    case .threeSeconds:
      return 3.0
    case .fiveSeconds:
      return 5.0
    case .tenSeconds:
      return 10.0
    case .fifteenSeconds:
      return 15.0
    }
  }
}
