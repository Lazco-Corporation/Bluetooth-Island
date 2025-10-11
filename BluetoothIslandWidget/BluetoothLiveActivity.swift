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
  @State private var progress: CGFloat = 0.0

  var body: some View {
    ZStack {
      // Background circle
      Circle()
        .stroke(Color.green.opacity(0.3), lineWidth: 2.5)
        .frame(width: 24, height: 24)

      // Animated progress ring
      Circle()
        .trim(from: 0, to: progress)
        .stroke(
          Color.green,
          style: StrokeStyle(lineWidth: 2.5, lineCap: .round)
        )
        .frame(width: 24, height: 24)
        .rotationEffect(.degrees(-90))
        .animation(.linear(duration: 1.0), value: progress)

      // Checkmark in center
      Image(systemName: "checkmark")
        .font(.system(size: 10, weight: .bold))
        .foregroundColor(.green)
    }
    .onAppear {
      progress = 1.0
    }
    .onChange(of: connectionTime) { _ in
      progress = 0.0
      withAnimation(.linear(duration: 1.0)) {
        progress = 1.0
      }
    }
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
        }

        DynamicIslandExpandedRegion(.trailing) {
          AnimatedCheckmark(connectionTime: context.state.connectionTime)
        }

        DynamicIslandExpandedRegion(.bottom) {
          Text(context.state.deviceName)
            .font(.subheadline)
            .padding(.top, 4)
        }
      } compactLeading: {
        // Compact leading (left side of notch)
        Image(systemName: deviceIcon(for: context.state.deviceType))
          .foregroundColor(.white)
      } compactTrailing: {
        // Compact trailing (right side of notch)
        Image(systemName: "checkmark.circle.fill")
          .foregroundColor(.green)
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
