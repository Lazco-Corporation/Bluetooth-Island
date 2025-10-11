//
//  BluetoothLiveActivity.swift
//  BluetoothIslandWidget
//
//  Widget bundle and Live Activity configuration
//

import ActivityKit
import SwiftUI
import WidgetKit

// MARK: - Animated Checkmark View

struct AnimatedCheckmark: View {
  let connectionTime: Date

  var body: some View {
    ProgressView(
      timerInterval: connectionTime...connectionTime.addingTimeInterval(0.7),
      countsDown: false,
      label: {
        Image(systemName: "checkmark")
          .foregroundColor(.green)
      },
      currentValueLabel: {
        Image(systemName: "checkmark")
          .foregroundColor(.green)
      }
    )
    .progressViewStyle(.circular)
    .tint(.green)
    .frame(width: 24, height: 24)
  }
}

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
            .padding(.leading, 1)
        }

        DynamicIslandExpandedRegion(.trailing) {
          AnimatedCheckmark(connectionTime: context.state.connectionTime)
            .padding(.trailing, 1)
        }

        DynamicIslandExpandedRegion(.center) {
          Text("Connected to")
            .font(.caption)
        }

        DynamicIslandExpandedRegion(.bottom) {
          Text(context.state.deviceName)
            .font(.subheadline)
            .padding(.top, 2)
            .lineLimit(1)
        }
      } compactLeading: {
        // Compact leading (left side of notch)
        Image(systemName: deviceIcon(for: context.state.deviceType))
          .foregroundColor(.white)
      } compactTrailing: {
        // Compact trailing (right side of notch)
        AnimatedCheckmark(connectionTime: context.state.connectionTime)
      } minimal: {
        // Minimal presentation (when multiple activities are active)
        Image(systemName: deviceIcon(for: context.state.deviceType))
          .foregroundColor(.white)
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
