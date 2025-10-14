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
      shortTitle: "Dynamic Island Notification",
      systemImageName: "iphone.gen3.radiowaves.left.and.right"
    ),
    AppShortcut(
      intent: TriggerNotificationIntent(),
      phrases: [
        "Send \(.applicationName) notification",
        "Notify with \(.applicationName)",
        "Show \(.applicationName) alert"
      ],
      shortTitle: "Notification Center Alert",
      systemImageName: "bell.badge"
    )
  ]
}
