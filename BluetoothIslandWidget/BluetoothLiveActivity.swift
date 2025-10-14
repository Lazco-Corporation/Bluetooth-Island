//
//  BluetoothLiveActivity.swift
//  BluetoothIslandWidget
//
//  Widget bundle and Live Activity configuration
//

import ActivityKit
import SwiftUI
import WidgetKit

// MARK: - Shared Functions

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

// MARK: - Animated Checkmark View

struct AnimatedCheckmark: View {
  let connectionTime: Date

  var body: some View {
    ProgressView(
      timerInterval: connectionTime...connectionTime.addingTimeInterval(0.8),
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
          VStack(alignment: .center) {
            Image(systemName: deviceIcon(for: context.state.deviceType))
              .foregroundColor(.white)
              .font(.system(size: 28))
          }
          .frame(width: 50, height: 50)
        }

        DynamicIslandExpandedRegion(.trailing) {
          VStack(alignment: .center) {
            AnimatedCheckmark(connectionTime: context.state.connectionTime)
          }
          .frame(width: 50, height: 50)
        }

        DynamicIslandExpandedRegion(.center) {
          VStack(alignment: .leading) {
            Text("Connected to")
              .font(.caption2)
              .foregroundColor(.secondary)
            Text(context.state.deviceName)
              .font(.footnote)
              .fontWeight(.semibold)
              .lineLimit(1)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
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
}

// MARK: - Lock Screen View

struct LiveActivityLockScreenView: View {
  let context: ActivityViewContext<BluetoothActivityAttributes>

  var body: some View {
    VStack(spacing: 8) {
      // Top row: Device icon and checkmark
      HStack(spacing: 0) {
        // Leading: Device icon
        Image(systemName: deviceIcon(for: context.state.deviceType))
          .foregroundColor(.white)
          .frame(width: 32, height: 32, alignment: .leading)

        // Center: Connected to text
        Text("Connected to")
          .font(.caption)
          .foregroundColor(.secondary)
          .frame(maxWidth: .infinity, alignment: .center)

        // Trailing: Animated checkmark
        AnimatedCheckmark(connectionTime: context.state.connectionTime)
          .frame(width: 26, height: 26, alignment: .trailing)
      }

      // Bottom row: Device name
      Text(context.state.deviceName)
        .font(.subheadline)
        .lineLimit(1)
        .frame(maxWidth: .infinity, alignment: .center)
    }
    .padding()
  }
}
