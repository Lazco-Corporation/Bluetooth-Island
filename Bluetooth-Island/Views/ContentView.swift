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
  @State private var selectedSection: HomeSection? = nil
  @State private var scrollOffset: CGFloat = 0
  @Namespace private var namespace

  var body: some View {
    ZStack {
      // Background gradient
      LinearGradient(
        colors: [
          Color(red: 0.1, green: 0.1, blue: 0.2),
          Color(red: 0.15, green: 0.1, blue: 0.25),
          Color(red: 0.2, green: 0.15, blue: 0.3)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
      .ignoresSafeArea()

      if selectedSection == nil {
        mainView
      } else {
        detailView
      }
    }
    .onAppear {
      requestNotificationPermission()
    }
  }

  // MARK: - Main View

  private var mainView: some View {
    ScrollView(showsIndicators: false) {
      VStack(spacing: 0) {
        // Hero Section
        heroSection
          .padding(.top, 60)
          .padding(.bottom, 40)

        // Floating Section Cards
        VStack(spacing: 24) {
          setupCard
          tipsCard
          troubleshootingCard
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 100)
      }
    }
  }

  // MARK: - Hero Section

  private var heroSection: some View {
    ZStack {
      // Floating decorative elements
      FloatingIcon(icon: "airpodspro", offset: CGPoint(x: -80, y: -40), delay: 0)
      FloatingIcon(icon: "applewatch", offset: CGPoint(x: 100, y: -20), delay: 0.5)
      FloatingIcon(icon: "car.fill", offset: CGPoint(x: -90, y: 80), delay: 1.0)
      FloatingIcon(icon: "headphones", offset: CGPoint(x: 110, y: 100), delay: 1.5)

      VStack(spacing: 20) {
        // App name with gradient
        Text("Bluetooth\nIsland")
          .font(.system(size: 56, weight: .black, design: .rounded))
          .multilineTextAlignment(.center)
          .foregroundStyle(
            LinearGradient(
              colors: [.white, Color.purple.opacity(0.8), Color.blue.opacity(0.6)],
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            )
          )
          .shadow(color: .purple.opacity(0.3), radius: 20, x: 0, y: 10)

        // Tagline
        Text("Beautiful notifications for\nyour device connections")
          .font(.system(size: 17, weight: .medium))
          .foregroundColor(.white.opacity(0.8))
          .multilineTextAlignment(.center)
          .lineSpacing(4)

        // Perfect for section - compact
        VStack(spacing: 10) {
          HStack(spacing: 12) {
            PerfectForTag("Car Bluetooth")
            PerfectForTag("AirPods")
          }
          HStack(spacing: 12) {
            PerfectForTag("Smart Home")
            PerfectForTag("& More")
          }
        }
        .padding(.top, 8)
      }
      .padding(.horizontal, 30)
    }
    .frame(height: 400)
  }

  // MARK: - Section Cards

  private var setupCard: some View {
    SectionCard(
      title: "Setup",
      subtitle: "Get started in 9 steps",
      icon: "sparkles",
      gradient: [Color.purple, Color.purple.opacity(0.7)],
      offset: -15
    ) {
      selectedSection = .setup
    }
  }

  private var tipsCard: some View {
    SectionCard(
      title: "Hide Banner",
      subtitle: "Remove automation notifications",
      icon: "eye.slash.fill",
      gradient: [Color.blue, Color.cyan.opacity(0.7)],
      offset: 15
    ) {
      selectedSection = .tips
    }
  }

  private var troubleshootingCard: some View {
    SectionCard(
      title: "Troubleshooting",
      subtitle: "Fix common issues",
      icon: "wrench.and.screwdriver.fill",
      gradient: [Color.pink, Color.orange.opacity(0.7)],
      offset: -10
    ) {
      selectedSection = .troubleshooting
    }
  }

  // MARK: - Detail View

  private var detailView: some View {
    ZStack(alignment: .topTrailing) {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 30) {
          // Header with back button space
          Color.clear.frame(height: 60)

          // Content based on selected section
          if selectedSection == .setup {
            setupDetailView
          } else if selectedSection == .tips {
            tipsDetailView
          } else if selectedSection == .troubleshooting {
            troubleshootingDetailView
          }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 60)
      }

      // Close button
      Button(action: {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
          selectedSection = nil
        }
      }) {
        Image(systemName: "xmark")
          .font(.system(size: 18, weight: .semibold))
          .foregroundColor(.white)
          .frame(width: 44, height: 44)
          .background(
            Circle()
              .fill(.ultraThinMaterial)
              .overlay(
                Circle()
                  .stroke(Color.white.opacity(0.2), lineWidth: 1)
              )
          )
          .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
      }
      .padding(20)
    }
    .transition(.asymmetric(
      insertion: .move(edge: .trailing).combined(with: .opacity),
      removal: .move(edge: .trailing).combined(with: .opacity)
    ))
  }

  // MARK: - Setup Detail View

  private var setupDetailView: some View {
    VStack(alignment: .leading, spacing: 28) {
      // Title
      VStack(alignment: .leading, spacing: 8) {
        Text("Setup")
          .font(.system(size: 40, weight: .black, design: .rounded))
          .foregroundColor(.white)

        Text("Follow these steps to configure Bluetooth Island")
          .font(.system(size: 16, weight: .medium))
          .foregroundColor(.white.opacity(0.7))
      }

      // Create Automation Button
      Link(destination: URL(string: "shortcuts://create-automation")!) {
        HStack(spacing: 12) {
          Image(systemName: "plus.circle.fill")
            .font(.title2)
            .foregroundColor(.white)

          VStack(alignment: .leading, spacing: 2) {
            Text("Create New Automation")
              .font(.system(size: 17, weight: .semibold))
              .foregroundColor(.white)
            Text("Opens Shortcuts app")
              .font(.system(size: 13, weight: .medium))
              .foregroundColor(.white.opacity(0.7))
          }

          Spacer()

          Image(systemName: "arrow.up.right")
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.white.opacity(0.8))
        }
        .padding(20)
        .background(
          RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(
              LinearGradient(
                colors: [Color.purple, Color.purple.opacity(0.8)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              )
            )
            .shadow(color: .purple.opacity(0.4), radius: 20, x: 0, y: 10)
        )
      }

      // Timeline steps
      VStack(spacing: 0) {
        TimelineStep(
          number: 1,
          title: "Open Shortcuts Automation",
          description: "Tap the button above, or open Shortcuts → Automation tab → Tap \"+\"",
          isLast: false
        )

        TimelineStep(
          number: 2,
          title: "Choose Trigger Type",
          description: "Select \"Bluetooth\" from the trigger list (or NFC, Time of Day, Location, etc.)",
          isLast: false
        )

        TimelineStep(
          number: 3,
          title: "Select Your Device",
          description: "Choose the Bluetooth device you want to monitor (e.g., \"AirPods Pro\", \"Car Bluetooth\")",
          isLast: false
        )

        TimelineStep(
          number: 4,
          title: "Configure Trigger Timing",
          description: "Select \"Is Connected\" and enable \"Run Immediately\"",
          isLast: false
        )

        TimelineStep(
          number: 5,
          title: "Add Bluetooth Island Action",
          description: "Search for \"Bluetooth Island\" and choose either \"Show Dynamic Island & Live Activity\" or \"Show Notification\"",
          isLast: false
        )

        TimelineStep(
          number: 6,
          title: "Customize Display",
          description: "Enter device name, choose an icon, and set display duration (Live Activity only)",
          isLast: false
        )

        TimelineStep(
          number: 7,
          title: "Disable Shortcuts Notification",
          description: "Toggle OFF \"Show When Run\" to prevent the Shortcuts notification banner",
          isLast: false
        )

        TimelineStep(
          number: 8,
          title: "Save Automation",
          description: "Tap the checkmark (✓) in the top right corner",
          isLast: false
        )

        TimelineStep(
          number: 9,
          title: "Test It",
          description: "Connect your Bluetooth device and watch for your custom notification!",
          isLast: true
        )
      }
    }
  }

  // MARK: - Tips Detail View

  private var tipsDetailView: some View {
    VStack(alignment: .leading, spacing: 28) {
      // Title
      VStack(alignment: .leading, spacing: 8) {
        Text("Hide Banner")
          .font(.system(size: 40, weight: .black, design: .rounded))
          .foregroundColor(.white)

        Text("Remove the \"Running Your Automation\" notification")
          .font(.system(size: 16, weight: .medium))
          .foregroundColor(.white.opacity(0.7))
      }

      // Warning box
      HStack(alignment: .top, spacing: 16) {
        Image(systemName: "exclamationmark.triangle.fill")
          .font(.title2)
          .foregroundColor(.orange)

        VStack(alignment: .leading, spacing: 6) {
          Text("Important")
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.white)

          Text("This workaround will disable all notifications from the Shortcuts app, including the \"Show Notification\" action.")
            .font(.system(size: 15, weight: .medium))
            .foregroundColor(.white.opacity(0.8))
            .fixedSize(horizontal: false, vertical: true)
        }
      }
      .padding(20)
      .background(
        RoundedRectangle(cornerRadius: 20, style: .continuous)
          .fill(Color.orange.opacity(0.15))
          .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
              .stroke(Color.orange.opacity(0.3), lineWidth: 1)
          )
      )

      // Steps
      VStack(spacing: 0) {
        NumberedStep(
          number: 1,
          text: "Trigger an automation first (you need at least one recent notification)",
          isLast: false
        )

        NumberedStep(
          number: 2,
          text: "Go to Settings → Screen Time → See All Activity",
          isLast: false
        )

        NumberedStep(
          number: 3,
          text: "Scroll to \"Notifications\" → Tap \"Show More\"",
          isLast: false
        )

        NumberedStep(
          number: 4,
          text: "Navigate to \"Last Week\" then back to \"This Week\" to refresh",
          isLast: false
        )

        NumberedStep(
          number: 5,
          text: "Tap \"Shortcuts\" → Toggle OFF \"Allow Notifications\"",
          isLast: true
        )
      }
    }
  }

  // MARK: - Troubleshooting Detail View

  private var troubleshootingDetailView: some View {
    VStack(alignment: .leading, spacing: 28) {
      // Title
      VStack(alignment: .leading, spacing: 8) {
        Text("Troubleshooting")
          .font(.system(size: 40, weight: .black, design: .rounded))
          .foregroundColor(.white)

        Text("Solutions for common issues")
          .font(.system(size: 16, weight: .medium))
          .foregroundColor(.white.opacity(0.7))
      }

      // Issue categories
      IssueCategory(
        icon: "iphone.gen3",
        title: "Live Activity Not Appearing",
        solutions: [
          "Ensure Bluetooth Island app is NOT in use, AKA app should be closed.",
          "Check Device Compatibility: Dynamic Island requires iPhone 14 Pro or newer",
          "Verify Live Activities Are Enabled: Settings → Face ID & Passcode → Allow Access When Locked → Live Activities",
          "Check iOS Version: Requires iOS 16.2 or later"
        ],
        color: Color.purple
      )

      IssueCategory(
        icon: "bell.slash",
        title: "Notification Not Appearing",
        solutions: [
          "Grant Permission: App requests notification permission on first use",
          "Check Notification Settings: Settings → Notifications → Bluetooth Island → Allow Notifications",
          "Verify Automation: Shortcuts → Automation tab → Check automation is enabled"
        ],
        color: Color.blue
      )

      IssueCategory(
        icon: "bolt.slash",
        title: "Automation Not Triggering",
        solutions: [
          "Check \"Run Immediately\": Edit automation → Ensure \"Run Immediately\" is enabled",
          "Verify Device Connection: Make sure the Bluetooth device actually connects",
          "Test Manually: Tap your automation in Shortcuts to test it directly"
        ],
        color: Color.pink
      )

      // Footer
      Text("Bluetooth Island \(Bundle.main.versionString)")
        .font(.system(size: 13, weight: .medium))
        .foregroundColor(.white.opacity(0.4))
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 20)
    }
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

// MARK: - Supporting Types

enum HomeSection {
  case setup
  case tips
  case troubleshooting
}

// MARK: - Custom Views

struct FloatingIcon: View {
  let icon: String
  let offset: CGPoint
  let delay: Double

  @State private var isAnimating = false

  var body: some View {
    Image(systemName: icon)
      .font(.system(size: 28))
      .foregroundStyle(
        LinearGradient(
          colors: [.white.opacity(0.15), .white.opacity(0.05)],
          startPoint: .topLeading,
          endPoint: .bottomTrailing
        )
      )
      .offset(x: offset.x, y: offset.y + (isAnimating ? -10 : 10))
      .blur(radius: 1)
      .onAppear {
        withAnimation(
          .easeInOut(duration: 3)
          .repeatForever(autoreverses: true)
          .delay(delay)
        ) {
          isAnimating = true
        }
      }
  }
}

struct PerfectForTag: View {
  let text: String

  init(_ text: String) {
    self.text = text
  }

  var body: some View {
    Text(text)
      .font(.system(size: 13, weight: .semibold))
      .foregroundColor(.white)
      .padding(.horizontal, 14)
      .padding(.vertical, 8)
      .background(
        Capsule()
          .fill(.ultraThinMaterial)
          .overlay(
            Capsule()
              .stroke(Color.white.opacity(0.2), lineWidth: 1)
          )
      )
      .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
  }
}

struct SectionCard: View {
  let title: String
  let subtitle: String
  let icon: String
  let gradient: [Color]
  let offset: CGFloat
  let action: () -> Void

  var body: some View {
    Button(action: {
      withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
        action()
      }
    }) {
      GeometryReader { geometry in
        HStack(spacing: 20) {
          // Icon
          ZStack {
            Circle()
              .fill(
                LinearGradient(
                  colors: [.white.opacity(0.2), .white.opacity(0.1)],
                  startPoint: .topLeading,
                  endPoint: .bottomTrailing
                )
              )
              .frame(width: 60, height: 60)

            Image(systemName: icon)
              .font(.system(size: 26, weight: .semibold))
              .foregroundColor(.white)
          }

          // Text
          VStack(alignment: .leading, spacing: 4) {
            Text(title)
              .font(.system(size: 24, weight: .bold, design: .rounded))
              .foregroundColor(.white)

            Text(subtitle)
              .font(.system(size: 15, weight: .medium))
              .foregroundColor(.white.opacity(0.7))
          }

          Spacer()

          // Arrow
          Image(systemName: "arrow.right")
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.white.opacity(0.6))
        }
        .padding(24)
        .background(
          RoundedRectangle(cornerRadius: 28, style: .continuous)
            .fill(
              LinearGradient(
                colors: gradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              )
            )
            .shadow(color: gradient[0].opacity(0.4), radius: 20, x: 0, y: 10)
            .overlay(
              RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(
                  LinearGradient(
                    colors: [.white.opacity(0.3), .white.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                  ),
                  lineWidth: 1
                )
            )
        )
        .offset(x: offset)
      }
    }
    .buttonStyle(ScaleButtonStyle())
    .frame(height: 120)
  }
}

struct TimelineStep: View {
  let number: Int
  let title: String
  let description: String
  let isLast: Bool

  var body: some View {
    HStack(alignment: .top, spacing: 16) {
      // Timeline indicator
      VStack(spacing: 0) {
        // Number circle
        ZStack {
          Circle()
            .fill(
              LinearGradient(
                colors: [Color.purple, Color.blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              )
            )
            .frame(width: 36, height: 36)

          Text("\(number)")
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.white)
        }

        // Connecting line
        if !isLast {
          Rectangle()
            .fill(
              LinearGradient(
                colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.2)],
                startPoint: .top,
                endPoint: .bottom
              )
            )
            .frame(width: 2)
            .padding(.vertical, 4)
        }
      }

      // Content
      VStack(alignment: .leading, spacing: 6) {
        Text(title)
          .font(.system(size: 17, weight: .semibold))
          .foregroundColor(.white)

        Text(description)
          .font(.system(size: 15, weight: .medium))
          .foregroundColor(.white.opacity(0.7))
          .fixedSize(horizontal: false, vertical: true)
      }
      .padding(.bottom, isLast ? 0 : 20)
    }
  }
}

struct NumberedStep: View {
  let number: Int
  let text: String
  let isLast: Bool

  var body: some View {
    HStack(alignment: .top, spacing: 16) {
      // Timeline indicator
      VStack(spacing: 0) {
        // Number
        Text("\(number)")
          .font(.system(size: 18, weight: .bold))
          .foregroundStyle(
            LinearGradient(
              colors: [Color.cyan, Color.blue],
              startPoint: .topLeading,
              endPoint: .bottomTrailing
            )
          )
          .frame(width: 32)

        // Connecting line
        if !isLast {
          Rectangle()
            .fill(Color.cyan.opacity(0.2))
            .frame(width: 2)
            .padding(.vertical, 4)
        }
      }

      // Text
      Text(text)
        .font(.system(size: 15, weight: .medium))
        .foregroundColor(.white.opacity(0.8))
        .fixedSize(horizontal: false, vertical: true)
        .padding(.bottom, isLast ? 0 : 20)
    }
  }
}

struct IssueCategory: View {
  let icon: String
  let title: String
  let solutions: [String]
  let color: Color

  var body: some View {
    VStack(alignment: .leading, spacing: 16) {
      // Header
      HStack(spacing: 14) {
        ZStack {
          Circle()
            .fill(
              LinearGradient(
                colors: [color.opacity(0.3), color.opacity(0.15)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
              )
            )
            .frame(width: 48, height: 48)

          Image(systemName: icon)
            .font(.system(size: 22, weight: .semibold))
            .foregroundColor(color)
        }

        Text(title)
          .font(.system(size: 20, weight: .bold))
          .foregroundColor(.white)
      }

      // Solutions
      VStack(alignment: .leading, spacing: 12) {
        ForEach(Array(solutions.enumerated()), id: \.offset) { index, solution in
          HStack(alignment: .top, spacing: 12) {
            Circle()
              .fill(color.opacity(0.6))
              .frame(width: 6, height: 6)
              .padding(.top, 6)

            Text(solution)
              .font(.system(size: 15, weight: .medium))
              .foregroundColor(.white.opacity(0.8))
              .fixedSize(horizontal: false, vertical: true)
          }
        }
      }
    }
    .padding(20)
    .background(
      RoundedRectangle(cornerRadius: 20, style: .continuous)
        .fill(color.opacity(0.12))
        .overlay(
          RoundedRectangle(cornerRadius: 20, style: .continuous)
            .stroke(color.opacity(0.3), lineWidth: 1)
        )
    )
  }
}

struct ScaleButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .scaleEffect(configuration.isPressed ? 0.96 : 1)
      .animation(.spring(response: 0.3, dampingFraction: 0.7), value: configuration.isPressed)
  }
}

#Preview {
  ContentView()
}
