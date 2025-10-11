//
//  BluetoothIslandShortcuts.swift
//  Bluetooth-Island
//
//  Shortcuts provider for App Intents
//

import AppIntents

/// Shortcuts provider that exposes app intents to the Shortcuts app
struct BluetoothIslandShortcuts: AppShortcutsProvider {
  static var appShortcuts: [AppShortcut] = [
    AppShortcut(
      intent: TriggerLiveActivityIntent(),
      phrases: [
        "Show Live Activity for device in \(.applicationName)",
        "Display device in Dynamic Island using \(.applicationName)"
      ],
      shortTitle: "Show Live Activity for Device",
      systemImageName: "iphone.gen3.radiowaves.left.and.right"
    ),
    AppShortcut(
      intent: TriggerNotificationIntent(),
      phrases: [
        "Send notification for device in \(.applicationName)",
        "Notify about device using \(.applicationName)"
      ],
      shortTitle: "Show Notification for Device",
      systemImageName: "bell.badge"
    )
  ]
}
