//
//  ContentView.swift
//  Bluetooth-Island
//
//  Main app interface with Shortcuts setup instructions
//

import SwiftUI

struct ContentView: View {
  // MARK: - Body

  var body: some View {
    NavigationView {
      ScrollView {
        VStack(spacing: 32) {
          // Header
          VStack(spacing: 12) {
            Image(systemName: "square.stack.3d.down.right.fill")
              .font(.system(size: 60))
              .foregroundColor(.blue)

            Text("Bluetooth Island")
              .font(.largeTitle)
              .fontWeight(.bold)

            Text("Shortcut-triggered Dynamic Island notifications")
              .font(.subheadline)
              .foregroundColor(.secondary)
              .multilineTextAlignment(.center)
              .padding(.horizontal)
          }
          .padding(.top, 40)

          // Instructions Section
          VStack(alignment: .leading, spacing: 16) {
            Label("How to Use", systemImage: "lightbulb.fill")
              .font(.headline)
              .foregroundColor(.orange)

            VStack(alignment: .leading, spacing: 12) {
              InstructionStep(
                number: 1,
                title: "Open Shortcuts App",
                description: "Launch the Shortcuts app on your iPhone"
              )

              InstructionStep(
                number: 2,
                title: "Create New Automation",
                description: "Tap Automation → Create Personal Automation"
              )

              InstructionStep(
                number: 3,
                title: "Choose Trigger",
                description: "Select a trigger (Bluetooth, NFC, Time, Location, etc.)"
              )

              InstructionStep(
                number: 4,
                title: "Add Action",
                description: "Choose \"Show Live Activity\" or \"Send Notification\""
              )

              InstructionStep(
                number: 5,
                title: "Set Device Name",
                description: "Enter the device name to display (e.g., \"AirPods Pro\")"
              )

              InstructionStep(
                number: 6,
                title: "Choose Device Type",
                description: "Select icon type: Bluetooth, AirPods, Watch, Car, etc."
              )

              InstructionStep(
                number: 7,
                title: "Set Duration",
                description: "Choose how long to display (1s, 2s, 3s, 5s, 10s, 15s)"
              )

              InstructionStep(
                number: 8,
                title: "Disable Shortcuts Banner",
                description: "Turn OFF \"Notify When Run\" to hide Shortcuts notification"
              )
            }
          }
          .padding()
          .background(
            RoundedRectangle(cornerRadius: 16)
              .fill(Color(.systemGray6))
          )
          .padding(.horizontal)

          // Action Types Section
          VStack(alignment: .leading, spacing: 16) {
            Label("Available Actions", systemImage: "bell.and.waves.left.and.right")
              .font(.headline)
              .foregroundColor(.purple)

            VStack(alignment: .leading, spacing: 12) {
              NotificationTypeCard(
                icon: "iphone.gen3.radiowaves.left.and.right",
                title: "Show Live Activity",
                description: "Configurable Dynamic Island notification",
                permission: "No permission • Runs in background",
                permissionColor: .green
              )

              NotificationTypeCard(
                icon: "bell.badge",
                title: "Send Notification",
                description: "Persistent Notification Center alert",
                permission: "Requires notification permission",
                permissionColor: .orange
              )
            }
          }
          .padding()
          .background(
            RoundedRectangle(cornerRadius: 16)
              .fill(Color(.systemGray6))
          )
          .padding(.horizontal)

          // Features Section
          VStack(alignment: .leading, spacing: 16) {
            Label("Features", systemImage: "star.fill")
              .font(.headline)
              .foregroundColor(.yellow)

            VStack(alignment: .leading, spacing: 12) {
              FeatureRow(
                icon: "bolt.fill",
                title: "Background Execution",
                description: "Runs silently without opening the app"
              )

              FeatureRow(
                icon: "sparkles",
                title: "Dual Display Modes",
                description: "Choose Live Activity or standard notification"
              )

              FeatureRow(
                icon: "person.crop.circle.badge.checkmark",
                title: "Customizable",
                description: "Use any device name you want"
              )
            }
          }
          .padding()
          .background(
            RoundedRectangle(cornerRadius: 16)
              .fill(Color(.systemGray6))
          )
          .padding(.horizontal)

          // Info Footer
          VStack(spacing: 8) {
            Image(systemName: "info.circle")
              .font(.title3)
              .foregroundColor(.secondary)

            Text("Trigger Live Activities using Shortcuts automation\nfor any Bluetooth, NFC, or other trigger events")
              .font(.caption)
              .foregroundColor(.secondary)
              .multilineTextAlignment(.center)
          }
          .padding(.bottom, 40)
        }
      }
      .navigationBarHidden(true)
    }
  }
}

// MARK: - Supporting Views

struct InstructionStep: View {
  let number: Int
  let title: String
  let description: String

  var body: some View {
    HStack(alignment: .top, spacing: 12) {
      ZStack {
        Circle()
          .fill(Color.blue)
          .frame(width: 28, height: 28)

        Text("\(number)")
          .font(.system(size: 14, weight: .bold))
          .foregroundColor(.white)
      }

      VStack(alignment: .leading, spacing: 4) {
        Text(title)
          .font(.subheadline)
          .fontWeight(.semibold)

        Text(description)
          .font(.caption)
          .foregroundColor(.secondary)
      }

      Spacer()
    }
  }
}

struct FeatureRow: View {
  let icon: String
  let title: String
  let description: String

  var body: some View {
    HStack(alignment: .top, spacing: 12) {
      Image(systemName: icon)
        .font(.title3)
        .foregroundColor(.blue)
        .frame(width: 28)

      VStack(alignment: .leading, spacing: 4) {
        Text(title)
          .font(.subheadline)
          .fontWeight(.semibold)

        Text(description)
          .font(.caption)
          .foregroundColor(.secondary)
      }

      Spacer()
    }
  }
}

struct NotificationTypeCard: View {
  let icon: String
  let title: String
  let description: String
  let permission: String
  let permissionColor: Color

  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack(spacing: 12) {
        Image(systemName: icon)
          .font(.title2)
          .foregroundColor(.blue)
          .frame(width: 32)

        VStack(alignment: .leading, spacing: 2) {
          Text(title)
            .font(.subheadline)
            .fontWeight(.semibold)

          Text(description)
            .font(.caption)
            .foregroundColor(.secondary)
        }

        Spacer()
      }

      HStack(spacing: 6) {
        Circle()
          .fill(permissionColor)
          .frame(width: 8, height: 8)

        Text(permission)
          .font(.caption2)
          .foregroundColor(permissionColor)
      }
    }
    .padding(12)
    .background(
      RoundedRectangle(cornerRadius: 10)
        .fill(Color(.systemBackground))
    )
  }
}

// MARK: - Preview

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
