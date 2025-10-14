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
    .oneSecond: .init(title: "1 second", image: .init(systemName: Constants.Icons.timer)),
    .twoSeconds: .init(title: "2 seconds", image: .init(systemName: Constants.Icons.timer)),
    .threeSeconds: .init(title: "3 seconds", image: .init(systemName: Constants.Icons.timer)),
    .fiveSeconds: .init(title: "5 seconds", image: .init(systemName: Constants.Icons.timer)),
    .tenSeconds: .init(title: "10 seconds", image: .init(systemName: Constants.Icons.timer)),
    .fifteenSeconds: .init(title: "15 seconds", image: .init(systemName: Constants.Icons.timer)),
  ]

  /// Returns the duration value in seconds
  var seconds: Double {
    switch self {
    case .oneSecond: return 1.0
    case .twoSeconds: return 2.0
    case .threeSeconds: return 3.0
    case .fiveSeconds: return 5.0
    case .tenSeconds: return 10.0
    case .fifteenSeconds: return 15.0
    }
  }

  /// Returns the duration in nanoseconds for Task.sleep
  /// Computed from seconds to avoid duplication
  var nanoseconds: UInt64 {
    UInt64(seconds * 1_000_000_000)
  }
}
