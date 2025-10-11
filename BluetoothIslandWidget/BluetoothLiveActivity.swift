//
//  BluetoothLiveActivity.swift
//  BluetoothIslandWidget
//
//  Widget bundle and Live Activity configuration
//

import ActivityKit
import SwiftUI
import WidgetKit

@main
struct BluetoothIslandWidget: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: BluetoothActivityAttributes.self) { context in
      // Lock screen presentation
      LiveActivityLockScreenView(context: context)
    } dynamicIsland: { context in
      // Dynamic Island presentation
      DynamicIsland {
        // Expanded region
        DynamicIslandExpandedRegion(.leading) {
          Image(systemName: deviceIcon(for: context.state.deviceType))
            .foregroundColor(.white)
            .font(.body)
        }

        DynamicIslandExpandedRegion(.trailing) {
          Image(systemName: "checkmark.circle.fill")
            .foregroundColor(.green)
            .font(.body)
        }

        DynamicIslandExpandedRegion(.bottom) {
          Text(context.state.deviceName)
            .font(.subheadline)
            .padding(.top, 4)
        }
      } compactLeading: {
        // Compact leading (left side of notch)
        Image(systemName: "antenna.radiowaves.left.and.right")
          .foregroundColor(.blue)
      } compactTrailing: {
        // Compact trailing (right side of notch)
        Image(systemName: "checkmark.circle.fill")
          .foregroundColor(.green)
      } minimal: {
        // Minimal presentation (when multiple activities are active)
        Image(systemName: "antenna.radiowaves.left.and.right")
          .foregroundColor(.blue)
      }
    }
  }

  /// Returns the appropriate SF Symbol for the device type
  private func deviceIcon(for deviceType: String?) -> String {
    guard let type = deviceType else { return "antenna.radiowaves.left.and.right" }

    switch type {
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
      return "antenna.radiowaves.left.and.right"
    default:
      return "antenna.radiowaves.left.and.right"
    }
  }
}

// MARK: - Lock Screen View

struct LiveActivityLockScreenView: View {
  let context: ActivityViewContext<BluetoothActivityAttributes>

  var body: some View {
    HStack(spacing: 12) {
      Image(systemName: deviceIcon(for: context.state.deviceType))
        .font(.title2)
        .foregroundColor(.blue)

      VStack(alignment: .leading, spacing: 4) {
        Text("Bluetooth Connected")
          .font(.caption)
          .foregroundColor(.secondary)

        Text(context.state.deviceName)
          .font(.headline)
      }

      Spacer()

      Image(systemName: "checkmark.circle.fill")
        .foregroundColor(.green)
        .font(.title2)
    }
    .padding()
  }

  private func deviceIcon(for deviceType: String?) -> String {
    guard let type = deviceType else { return "antenna.radiowaves.left.and.right" }

    switch type {
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
      return "antenna.radiowaves.left.and.right"
    default:
      return "antenna.radiowaves.left.and.right"
    }
  }
}
