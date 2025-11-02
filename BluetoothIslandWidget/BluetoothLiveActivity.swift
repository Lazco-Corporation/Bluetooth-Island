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

/// Animated checkmark that displays during Live Activity
struct AnimatedCheckmark: View {
  let connectionTime: Date

  var body: some View {
    ProgressView(
      timerInterval:
        connectionTime...connectionTime.addingTimeInterval(
          Constants.Design.Animation.checkmarkDuration),
      countsDown: false,
      label: {
        Image(systemName: Constants.Icons.checkmark)
          .foregroundColor(.green)
      },
      currentValueLabel: {
        Image(systemName: Constants.Icons.checkmark)
          .foregroundColor(.green)
      }
    )
    .progressViewStyle(.circular)
    .tint(.green)
    .accessibilityLabel("Connection successful")
  }
}

// MARK: - Widget Configuration

@main
struct BluetoothIslandWidget: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: BluetoothActivityAttributes.self) { context in
      // Lock screen presentation
      LiveActivityLockScreenView(context: context)
    } dynamicIsland: { context in
      // Dynamic Island presentation
      DynamicIsland {
        // Expanded region (when user long-presses)
        DynamicIslandExpandedRegion(.leading) {
          Image(systemName: DeviceIconMapper.icon(for: context.state.deviceType))
            .foregroundColor(.white)
            .font(.system(size: Constants.Design.DynamicIsland.expandedIconSize))
            .frame(
              width: Constants.Design.DynamicIsland.expandedIconFrameSize,
              height: Constants.Design.DynamicIsland.expandedIconFrameSize,
              alignment: .center
            )
            .accessibilityLabel("Device icon")
        }

        DynamicIslandExpandedRegion(.trailing) {
          AnimatedCheckmark(connectionTime: context.state.connectionTime)
            .frame(
              width: Constants.Design.DynamicIsland.expandedIconFrameSize,
              height: Constants.Design.DynamicIsland.expandedIconFrameSize
            )
        }

        DynamicIslandExpandedRegion(.center) {
          VStack(alignment: .leading, spacing: 4) {
            Text(Constants.Notification.defaultTitle)
              .font(.caption2)
              .foregroundColor(.secondary)

            Text(context.state.deviceName)
              .font(.footnote)
              .fontWeight(.semibold)
              .lineLimit(1)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .accessibilityElement(children: .combine)
          .accessibilityLabel("Connected to \(context.state.deviceName)")
        }
      } compactLeading: {
        // Compact leading (left side of notch)
        Image(systemName: DeviceIconMapper.icon(for: context.state.deviceType))
          .foregroundColor(.white)
          .accessibilityLabel("Device connected")
      } compactTrailing: {
        // Compact trailing (right side of notch)
        AnimatedCheckmark(connectionTime: context.state.connectionTime)
      } minimal: {
        // Minimal presentation (when multiple activities are active)
        Image(systemName: DeviceIconMapper.icon(for: context.state.deviceType))
          .foregroundColor(.white)
          .accessibilityLabel("Device connected")
      }
    }
  }
}

// MARK: - Lock Screen View

/// Lock screen presentation of the Live Activity
struct LiveActivityLockScreenView: View {
  let context: ActivityViewContext<BluetoothActivityAttributes>

  var body: some View {
    HStack(spacing: Constants.Design.LockScreen.padding) {
      // Leading: Device icon
      Image(systemName: DeviceIconMapper.icon(for: context.state.deviceType))
        .foregroundColor(.white)
        .font(.system(size: Constants.Design.LockScreen.iconSize))
        .frame(
          width: Constants.Design.LockScreen.iconFrameSize,
          height: Constants.Design.LockScreen.iconFrameSize,
          alignment: .center
        )
        .accessibilityLabel("Device icon")

      // Center: Connection text
      VStack(alignment: .leading, spacing: 4) {
        Text(Constants.Notification.defaultTitle)
          .font(.caption2)
          .foregroundColor(.secondary)

        Text(context.state.deviceName)
          .font(.footnote)
          .fontWeight(.semibold)
          .lineLimit(1)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .accessibilityElement(children: .combine)
      .accessibilityLabel("Connected to \(context.state.deviceName)")

      // Trailing: Animated checkmark
      AnimatedCheckmark(connectionTime: context.state.connectionTime)
        .frame(
          width: Constants.Design.LockScreen.iconFrameSize,
          height: Constants.Design.LockScreen.iconFrameSize,
          alignment: .trailing
        )
    }
    .padding()
  }
}

// MARK: - Previews

// Note: Live Activity previews are best tested on device or simulator
// using the Shortcuts automation triggers
