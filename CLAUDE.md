# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Bluetooth Island is an iOS app that displays Live Activity notifications in the Dynamic Island when triggered by **Shortcuts automation**. The app runs entirely in the background without showing the app UI, making it perfect for automation workflows.

**Key Features:**
- Triggered by Shortcuts app automations (Bluetooth, NFC, Time, Location, etc.)
- Displays customizable 2-second Live Activity in Dynamic Island
- Runs completely in background (`openAppWhenRun = false`)
- No Bluetooth permissions or background modes required
- Requires iOS 16.2+ (Live Activities) and iPhone 14 Pro+ (Dynamic Island)

## Project Structure

This project uses **XcodeGen** to generate the Xcode project from `project.yml`. Do not manually edit `.xcodeproj` files.

### Main Components

**Main App Target (`Bluetooth-Island`):**
- `BluetoothIslandApp.swift` - App entry point
- `ContentView.swift` - Setup instructions UI for users
- `TriggerLiveActivityIntent.swift` - App Intent for Shortcuts integration
- `BluetoothIslandShortcuts.swift` - Shortcuts provider (registers intent with Shortcuts app)
- `LiveActivityManager.swift` - ActivityKit wrapper for starting/stopping Live Activities
- `BluetoothActivityAttributes.swift` - Shared data model between app and widget

**Widget Extension Target (`BluetoothIslandWidget`):**
- `BluetoothLiveActivity.swift` - Widget configuration for Dynamic Island and lock screen
- Shares `BluetoothActivityAttributes.swift` with main app (configured in project.yml)

### Architecture Flow

1. **User Setup:** User creates Shortcuts automation with trigger (Bluetooth, NFC, etc.)
2. **Add Action:** User adds "Show Device Connection" action from this app
3. **Configure:** User sets device name parameter (e.g., "AirPods Pro")
4. **Trigger Event:** When automation triggers, Shortcuts calls `TriggerLiveActivityIntent`
5. **Background Execution:** Intent runs with `openAppWhenRun = false` (no app UI shown)
6. **Live Activity:** `LiveActivityManager` starts 2-second Dynamic Island notification
7. **Auto-Dismissal:** Activity automatically ends after 2 seconds via Task.sleep()

### Critical Implementation Details

**App Intents Integration:**
- `TriggerLiveActivityIntent` conforms to `AppIntent` protocol
- `openAppWhenRun = false` prevents app from opening when run via Shortcuts
- `@Parameter` decorator exposes device name input to Shortcuts
- `@MainActor` on `perform()` ensures Live Activity runs on main thread

**Shortcuts Provider:**
- `BluetoothIslandShortcuts` conforms to `AppShortcutsProvider`
- Registers app intents with Shortcuts app
- Provides suggested Siri phrases for voice activation
- Sets icon and display name for Shortcuts picker

**Live Activity Lifecycle:**
- Activities started with `Activity.request()` in LiveActivityManager
- 2-second duration enforced by `Task.sleep(nanoseconds: 2_000_000_000)` + `endCurrentActivity()`
- Uses `.immediate` dismissal policy for instant cleanup
- Lock screen and Dynamic Island presentations configured separately

## Build and Development

### Regenerate Xcode Project

Always regenerate after modifying `project.yml`:

```bash
xcodegen generate
```

### Build Project

For simulator:
```bash
xcodebuild -scheme Bluetooth-Island -configuration Debug -sdk iphonesimulator build | xcbeautify
```

For device (requires setting development team in Xcode first):
```bash
xcodebuild -scheme Bluetooth-Island -configuration Debug -sdk iphoneos build | xcbeautify
```

### Version Management

Version numbers are controlled in `project.yml` settings:
- `CURRENT_PROJECT_VERSION` - Build number (CFBundleVersion)
- `MARKETING_VERSION` - User-facing version (CFBundleShortVersionString)

Both targets (app and widget) must have matching versions or iOS installation will fail.

### Code Signing

The `DEVELOPMENT_TEAM` field in `project.yml` is intentionally empty for portability. Set your team in Xcode GUI:
1. Open `Bluetooth-Island.xcodeproj` in Xcode
2. Select project → Select target → Signing & Capabilities
3. Choose team for both `Bluetooth-Island` and `BluetoothIslandWidget` targets

## Permissions and Entitlements

**Required Info.plist Keys:**
- `NSSupportsLiveActivities: true` - Enable Live Activities

**Required Entitlements:**
- `com.apple.security.application-groups` - Share data between app and widget
- App group: `group.com.lazco.BluetoothIsland`

**Not Required:**
- ❌ `NSBluetoothAlwaysUsageDescription` - No Bluetooth access needed
- ❌ `UIBackgroundModes` - No background modes needed (Shortcuts handles execution)
- ❌ `com.apple.developer.usernotifications.filtering` - Only for notification content extensions

## Swift Concurrency Notes

**MainActor Isolation:**
- `TriggerLiveActivityIntent.perform()` is `@MainActor` for Live Activity access
- `LiveActivityManager` is an `actor` for thread-safe activity management
- Communication uses `await` for async bridging

## Testing on Device

**Requirements:**
- Physical iPhone 14 Pro or newer (for Dynamic Island)
- iOS 16.2 or later
- Shortcuts app installed (pre-installed on iOS)

**Setup Flow:**
1. Install app on device
2. Open Shortcuts app
3. Create new Personal Automation
4. Choose trigger (e.g., "When Bluetooth Connects to [Device]")
5. Add action: Search for "Show Device Connection"
6. Set device name parameter (e.g., "AirPods Pro")
7. **Important:** Turn OFF "Notify When Run" to hide Shortcuts notification
8. Save automation
9. Trigger the automation (connect to Bluetooth device, scan NFC tag, etc.)
10. Watch Dynamic Island for 2-second notification

**Debugging:**
- Use Console.app or Xcode console to view `os.log` messages
- Logger subsystem: `com.lazco.BluetoothIsland`
- Categories: `TriggerLiveActivityIntent`, `LiveActivityManager`
- Console logs show when Shortcuts trigger the intent and when Live Activity starts

## Common Modifications

### Adjust Live Activity Duration

In `LiveActivityManager.swift:67`, change the sleep duration:
```swift
try? await Task.sleep(nanoseconds: X_000_000_000) // X seconds
```

### Add New Device Type Icons

Update `determineDeviceType()` in both:
- `LiveActivityManager.swift:96`
- `BluetoothLiveActivity.swift:66` (deviceIcon function)

### Add More Intent Parameters

Edit `TriggerLiveActivityIntent.swift`:
```swift
@Parameter(title: "Connection Type", description: "Type of connection (Bluetooth, Wi-Fi, etc.)")
var connectionType: String

@Parameter(title: "Show Duration", description: "Seconds to show notification")
var duration: Int
```

Then use parameters in `perform()` method.

### Change App Bundle Identifier

Update in `project.yml`:
- `bundleIdPrefix: com.lazco`
- App group name: `group.com.lazco.BluetoothIsland`
- Logger subsystem in Swift files

Then regenerate project with `xcodegen generate`.

### Modify Dynamic Island Layout

Edit `BluetoothLiveActivity.swift`:
- `DynamicIslandExpandedRegion` - Expanded view (when user long-presses)
- `compactLeading`/`compactTrailing` - Compact view (left/right of notch)
- `minimal` - Minimal view (when multiple activities active)

### Add Siri Phrases

Edit `BluetoothIslandShortcuts.swift` to add more voice activation phrases:
```swift
phrases: [
  "Show device connection in \(.applicationName)",
  "Trigger \(.applicationName) notification",
  "My device connected",
  "Show \(.applicationName) alert"
]
```

## Shared Files Between Targets

`BluetoothActivityAttributes.swift` is compiled into both targets:
- Main app includes it via `Bluetooth-Island/` source path
- Widget includes it via explicit path in `project.yml:81`

When modifying this file, ensure changes are compatible with both targets (no app-specific or widget-specific code).

## Example Automation Use Cases

**Bluetooth Connection:**
- Trigger: "When Bluetooth connects to AirPods Pro"
- Action: Show Device Connection ("AirPods Pro")
- Result: 2-second notification in Dynamic Island when AirPods connect

**NFC Tag:**
- Trigger: "When NFC tag is scanned"
- Action: Show Device Connection ("Office Check-in")
- Result: Visual confirmation in Dynamic Island when scanning NFC tag

**Time-Based:**
- Trigger: "At 9:00 AM on weekdays"
- Action: Show Device Connection ("Work Mode Activated")
- Result: Daily reminder in Dynamic Island

**Location-Based:**
- Trigger: "When I arrive at Home"
- Action: Show Device Connection ("Welcome Home")
- Result: Greeting notification when arriving home
