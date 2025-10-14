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
        "Show \(.applicationName) notification",
        "Display in Dynamic Island with \(.applicationName)",
        "Trigger \(.applicationName) Live Activity"
      ],
      shortTitle: "Show Dynamic Island & Live Activity",
      systemImageName: "iphone.gen3.radiowaves.left.and.right"
    ),
    AppShortcut(
      intent: TriggerNotificationIntent(),
      phrases: [
        "Send \(.applicationName) notification",
        "Notify with \(.applicationName)",
        "Show \(.applicationName) alert"
      ],
      shortTitle: "Show Notification",
      systemImageName: "bell.badge"
    )
  ]
}
