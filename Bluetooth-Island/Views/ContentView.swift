//
//  ContentView.swift
//  Bluetooth-Island
//
//  Main app interface - Setup instructions and testing
//

import SwiftUI

struct ContentView: View {
  @State private var notificationPermissionGranted = false
  @State private var isRequestingPermission = false
  @State private var expandedSections: Set<String> = []

  var body: some View {
    ScrollView {
      VStack(spacing: 32) {
        // Hero Section
        heroSection

        // Setup Instructions
        setupInstructionsSection

        // Hide Banner Instructions
        hideBannerSection

        // Troubleshooting
        troubleshootingSection

        // Footer
        footerSection
      }
      .padding(.horizontal, 20)
      .padding(.vertical, 32)
    }
    .background(Color(UIColor.systemGroupedBackground))
    .onAppear {
      requestNotificationPermission()
    }
  }

  // MARK: - Hero Section

  private var heroSection: some View {
    VStack(spacing: 16) {
      // Title
      Text("Bluetooth Island")
        .font(.largeTitle.bold())
        .foregroundColor(.primary)

      // Description
      Text("Beautiful notifications for your device connections via Live Activities & Notifications.")
        .font(.callout)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
        .padding(.horizontal, 20)

      // Perfect For
      VStack(alignment: .leading, spacing: 8) {
        Text("Perfect for:")
          .font(.subheadline.weight(.semibold))
          .foregroundColor(.secondary)

        VStack(alignment: .leading, spacing: 4) {
          BulletPoint(text: "Non-Apple accessory connection notifications")
          BulletPoint(text: "Car Bluetooth connection alerts")
          BulletPoint(text: "Smart home device connection feedback")
          BulletPoint(text: "... discover endless possibilities!")
        }
      }
      .padding(.top, 8)
    }
  }

  // MARK: - Setup Instructions Section

  private var setupInstructionsSection: some View {
    VStack(alignment: .leading, spacing: 20) {
      Text("Setup")
        .font(.title.bold())
        .foregroundColor(.primary)

      Text("Follow these steps to setup Bluetooth Island:")
        .font(.subheadline)
        .foregroundColor(.secondary)

      VStack(alignment: .leading, spacing: 16) {
        SetupStep(
          number: 1,
          title: "Open Shortcuts Automation",
          description: "Tap the \"Create New Automation\" button below, or open Shortcuts → Automation tab → Tap \"+\""
        )

        // Create Automation Button
        Link(destination: URL(string: "shortcuts://create-automation")!) {
          HStack(spacing: 10) {
            Image(systemName: "plus.circle.fill")
              .font(.body)
              .foregroundColor(.white)

            Text("Create New Automation")
              .font(.subheadline.weight(.semibold))
              .foregroundColor(.white)

            Spacer()

            Image(systemName: "arrow.up.right")
              .font(.caption.weight(.semibold))
              .foregroundColor(.white.opacity(0.8))
          }
          .padding(.horizontal, 14)
          .padding(.vertical, 12)
          .background(
            LinearGradient(
              colors: [Color.purple, Color.purple.opacity(0.8)],
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            )
          )
          .cornerRadius(10)
        }
        .padding(.leading, 44)

        SetupStep(
          number: 2,
          title: "Choose Trigger Type",
          description: "Select \"Bluetooth\" from the trigger list (or NFC, Time of Day, Location, etc.)"
        )

        SetupStep(
          number: 3,
          title: "Select Your Device",
          description: "Choose the Bluetooth device you want to monitor (e.g., \"AirPods Pro\", \"Car Bluetooth\")"
        )

        SetupStep(
          number: 4,
          title: "Configure Trigger Timing",
          description: "Select \"Is Connected\" and enable \"Run Immediately\""
        )

        SetupStep(
          number: 5,
          title: "Add Bluetooth Island Action",
          description: "Search for \"Bluetooth Island\" and choose either \"Show Dynamic Island & Live Activity\" or \"Show Notification\""
        )

        SetupStep(
          number: 6,
          title: "Customize Display",
          description: "Enter device name, choose an icon, and set display duration (Live Activity only)"
        )

        SetupStep(
          number: 7,
          title: "Disable Shortcuts Notification",
          description: "Toggle OFF \"Show When Run\" to prevent the Shortcuts notification banner"
        )

        SetupStep(
          number: 8,
          title: "Save Automation",
          description: "Tap the checkmark (✓) in the top right corner"
        )

        SetupStep(
          number: 9,
          title: "Test It",
          description: "Connect your Bluetooth device and watch for your custom notification!"
        )
      }
      .padding(16)
      .background(Color(UIColor.secondarySystemGroupedBackground))
      .cornerRadius(14)
    }
  }

  // MARK: - Hide Banner Section

  private var hideBannerSection: some View {
    CollapsibleSection(
      title: "Hide \"Running Your Automation\" Notification",
      isExpanded: expandedSections.contains("banner")
    ) {
      if expandedSections.contains("banner") {
        _ = expandedSections.remove("banner")
      } else {
        _ = expandedSections.insert("banner")
      }
    } content: {
      VStack(alignment: .leading, spacing: 16) {
        WarningBox(
          icon: "exclamationmark.triangle.fill",
          text: "This workaround will disable all notifications from the Shortcuts app, including the \"Show Notification\" action.",
          color: .orange
        )

        VStack(alignment: .leading, spacing: 12) {
          InstructionStep(
            number: 1,
            text: "Trigger an automation first (you need at least one recent notification)"
          )
          InstructionStep(
            number: 2,
            text: "Go to Settings → Screen Time → See All Activity"
          )
          InstructionStep(
            number: 3,
            text: "Scroll to \"Notifications\" → Tap \"Show More\""
          )
          InstructionStep(
            number: 4,
            text: "Navigate to \"Last Week\" then back to \"This Week\" to refresh"
          )
          InstructionStep(
            number: 5,
            text: "Tap \"Shortcuts\" → Toggle OFF \"Allow Notifications\""
          )
        }
      }
    }
  }

  // MARK: - Troubleshooting Section

  private var troubleshootingSection: some View {
    CollapsibleSection(
      title: "Troubleshooting",
      isExpanded: expandedSections.contains("troubleshooting")
    ) {
      if expandedSections.contains("troubleshooting") {
        _ = expandedSections.remove("troubleshooting")
      } else {
        _ = expandedSections.insert("troubleshooting")
      }
    } content: {
      VStack(alignment: .leading, spacing: 20) {
        TroubleshootingCategory(
          icon: "iphone.gen3",
          title: "Live Activity Not Appearing",
          solutions: [
            "Ensure Bluetooth Island app is NOT in use, AKA app should be closed.",
            "Check Device Compatibility: Dynamic Island requires iPhone 14 Pro or newer",
            "Verify Live Activities Are Enabled: Settings → Face ID & Passcode → Allow Access When Locked → Live Activities",
            "Check iOS Version: Requires iOS 16.2 or later"
          ]
        )

        TroubleshootingCategory(
          icon: "bell.slash",
          title: "Notification Not Appearing",
          solutions: [
            "Grant Permission: App requests notification permission on first use",
            "Check Notification Settings: Settings → Notifications → Bluetooth Island → Allow Notifications",
            "Verify Automation: Shortcuts → Automation tab → Check automation is enabled"
          ]
        )

        TroubleshootingCategory(
          icon: "bolt.slash",
          title: "Automation Not Triggering",
          solutions: [
            "Check \"Run Immediately\": Edit automation → Ensure \"Run Immediately\" is enabled",
            "Verify Device Connection: Make sure the Bluetooth device actually connects",
            "Test Manually: Tap your automation in Shortcuts to test it directly"
          ]
        )
      }
    }
  }

  // MARK: - Footer Section

  private var footerSection: some View {
    VStack(spacing: 12) {
      Text("Bluetooth Island \(Bundle.main.versionString)")
        .font(.caption)
        .foregroundColor(.secondary)
    }
    .padding(.vertical, 20)
  }

  // MARK: - Actions

  private func requestNotificationPermission() {
    guard !isRequestingPermission else { return }
    isRequestingPermission = true

    Task {
      let notificationManager = NotificationManager()
      let isAuthorized = await notificationManager.checkAuthorization()

      if isAuthorized {
        await MainActor.run {
          notificationPermissionGranted = true
          isRequestingPermission = false
        }
      } else {
        let granted = await notificationManager.requestAuthorization()
        await MainActor.run {
          notificationPermissionGranted = granted
          isRequestingPermission = false
        }
      }
    }
  }
}

// MARK: - Supporting Views

struct BulletPoint: View {
  let text: String

  var body: some View {
    HStack(alignment: .top, spacing: 8) {
      Text("•")
        .font(.subheadline)
        .foregroundColor(.secondary)

      Text(text)
        .font(.subheadline)
        .foregroundColor(.secondary)
    }
  }
}

struct SetupStep: View {
  let number: Int
  let title: String
  let description: String

  var body: some View {
    HStack(alignment: .top, spacing: 12) {
      // Number Badge
      ZStack {
        Circle()
          .fill(Color.blue.opacity(0.15))
          .frame(width: 32, height: 32)

        Text("\(number)")
          .font(.subheadline.bold())
          .foregroundColor(.blue)
      }

      // Content
      VStack(alignment: .leading, spacing: 4) {
        Text(title)
          .font(.subheadline.weight(.semibold))
          .foregroundColor(.primary)

        Text(description)
          .font(.subheadline)
          .foregroundColor(.secondary)
          .fixedSize(horizontal: false, vertical: true)
      }
    }
  }
}

struct CollapsibleSection<Content: View>: View {
  let title: String
  let isExpanded: Bool
  let toggleAction: () -> Void
  let content: Content

  init(
    title: String,
    isExpanded: Bool,
    toggleAction: @escaping () -> Void,
    @ViewBuilder content: () -> Content
  ) {
    self.title = title
    self.isExpanded = isExpanded
    self.toggleAction = toggleAction
    self.content = content()
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      // Header
      Button(action: toggleAction) {
        HStack {
          Text(title)
            .font(.title2.bold())
            .foregroundColor(.primary)

          Spacer()

          Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
            .font(.headline)
            .foregroundColor(.secondary)
        }
        .padding(20)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .cornerRadius(14)
      }

      // Content
      if isExpanded {
        content
          .padding(20)
          .background(Color(UIColor.secondarySystemGroupedBackground))
          .cornerRadius(14)
          .padding(.top, 8)
      }
    }
  }
}

struct WarningBox: View {
  let icon: String
  let text: String
  let color: Color

  var body: some View {
    HStack(alignment: .top, spacing: 12) {
      Image(systemName: icon)
        .font(.title3)
        .foregroundColor(color)

      Text(text)
        .font(.subheadline)
        .foregroundColor(.primary)
    }
    .padding(16)
    .background(color.opacity(0.1))
    .cornerRadius(12)
  }
}

struct InstructionStep: View {
  let number: Int
  let text: String

  var body: some View {
    HStack(alignment: .top, spacing: 12) {
      Text("\(number).")
        .font(.subheadline.bold())
        .foregroundColor(.blue)
        .frame(width: 20, alignment: .leading)

      Text(text)
        .font(.subheadline)
        .foregroundColor(.primary)
    }
  }
}

struct TroubleshootingCategory: View {
  let icon: String
  let title: String
  let solutions: [String]

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack(spacing: 12) {
        Image(systemName: icon)
          .font(.title3)
          .foregroundColor(.blue)
          .frame(width: 28)

        Text(title)
          .font(.headline)
          .foregroundColor(.primary)
      }

      VStack(alignment: .leading, spacing: 8) {
        ForEach(solutions, id: \.self) { solution in
          BulletPoint(text: solution)
        }
      }
      .padding(.leading, 40)
    }
    .padding(16)
    .background(Color(UIColor.tertiarySystemGroupedBackground))
    .cornerRadius(12)
  }
}

struct UseCaseCard: View {
  let icon: String
  let title: String
  let trigger: String
  let deviceName: String
  let deviceIcon: String
  let duration: String

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack(spacing: 12) {
        Image(systemName: icon)
          .font(.title2)
          .foregroundColor(.blue)
          .frame(width: 40, height: 40)

        Text(title)
          .font(.headline)
          .foregroundColor(.primary)
      }

      VStack(alignment: .leading, spacing: 6) {
        DetailRow(label: "Trigger", value: trigger)
        DetailRow(label: "Device Name", value: deviceName)
        DetailRow(label: "Icon", value: deviceIcon)
        DetailRow(label: "Duration", value: duration)
      }
    }
    .padding(16)
    .background(Color(UIColor.tertiarySystemGroupedBackground))
    .cornerRadius(12)
  }
}

struct DetailRow: View {
  let label: String
  let value: String

  var body: some View {
    HStack(spacing: 8) {
      Text("\(label):")
        .font(.footnote.weight(.medium))
        .foregroundColor(.secondary)

      Text(value)
        .font(.footnote)
        .foregroundColor(.primary)
    }
  }
}

#Preview {
  ContentView()
}
