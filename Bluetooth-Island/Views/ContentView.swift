//
//  ContentView.swift
//  Bluetooth-Island
//
//  Main app interface
//
//  Note: This app is designed to run in the background via Shortcuts automation.
//  The UI is intentionally minimal since users interact via the Shortcuts app.
//

import SwiftUI

struct ContentView: View {
  @State private var notificationPermissionGranted = false
  @State private var isRequestingPermission = false

  var body: some View {
    NavigationView {
      VStack {
        // Placeholder for main content
        // TODO: Add setup instructions and demo buttons based on HOMEPAGE_INSTRUCTION.md
      }
    }
    .onAppear {
      requestNotificationPermission()
    }
  }

  /// Requests notification permission when the app first launches
  private func requestNotificationPermission() {
    guard !isRequestingPermission else { return }
    isRequestingPermission = true

    Task {
      let notificationManager = NotificationManager()

      // Check if already authorized
      let isAuthorized = await notificationManager.checkAuthorization()

      if isAuthorized {
        await MainActor.run {
          notificationPermissionGranted = true
          isRequestingPermission = false
        }
      } else {
        // Request authorization
        let granted = await notificationManager.requestAuthorization()
        await MainActor.run {
          notificationPermissionGranted = granted
          isRequestingPermission = false
        }
      }
    }
  }
}

#Preview {
  ContentView()
}
