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
          Label {
            Text(context.state.deviceName)
              .font(.caption)
          } icon: {
            Image(systemName: deviceIcon(for: context.state.deviceType))
              .foregroundColor(.blue)
          }
        }

        DynamicIslandExpandedRegion(.trailing) {
          Image(systemName: "checkmark.circle.fill")
            .foregroundColor(.green)
            .font(.title3)
        }

        DynamicIslandExpandedRegion(.bottom) {
          HStack {
            Image(systemName: "antenna.radiowaves.left.and.right")
              .foregroundColor(.blue)

            Text("Connected via Bluetooth")
              .font(.caption)
              .foregroundColor(.secondary)
          }
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
    guard let type = deviceType else { return "bluetooth" }

    switch type {
    case "airpods":
      return "airpodspro"
    case "beats":
      return "headphones"
    case "watch":
      return "applewatch"
    case "keyboard":
      return "keyboard"
    case "mouse":
      return "computermouse"
    case "speaker":
      return "hifispeaker"
    default:
      return "bluetooth"
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
    guard let type = deviceType else { return "bluetooth" }

    switch type {
    case "airpods":
      return "airpodspro"
    case "beats":
      return "headphones"
    case "watch":
      return "applewatch"
    case "keyboard":
      return "keyboard"
    case "mouse":
      return "computermouse"
    case "speaker":
      return "hifispeaker"
    default:
      return "bluetooth"
    }
  }
}
