# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Bluetooth Island is an iOS app that provides two ways to display custom notifications when triggered by **Shortcuts automation**: Live Activities in the Dynamic Island or persistent notifications in Notification Center. The app runs entirely in the background without showing the app UI, making it perfect for automation workflows.

**Key Features:**
- Triggered by Shortcuts app automations (Bluetooth, NFC, Time, Location, etc.)
- **Two notification types:**
  1. **Live Activity** - Animated 1-15 second notification in Dynamic Island with custom icons and animated checkmark
  2. **Notification** - Persistent notification in Notification Center
- Runs completely in background (`openAppWhenRun = false`)
- Configurable display duration (1-15 seconds for Live Activities)
- 13 device type icons to choose from (AirPods, Car, Watch, etc.)
- Automatic permission request on app launch
- No Bluetooth permissions or background modes required
- Requires iOS 16.2+ for Live Activities, iPhone 14 Pro+ for Dynamic Island

## Project Structure

This project uses **XcodeGen** to generate the Xcode project from `project.yml`. Do not manually edit `.xcodeproj` files.

### Organized Folder Structure

The codebase follows a clean architecture with organized folders:

```
Bluetooth-Island/
├── BluetoothIslandApp.swift       # App entry point
├── Models/                         # Data models and enums
│   ├── BluetoothActivityAttributes.swift  # Shared between app & widget
│   ├── DeviceType.swift            # Device icon options for Shortcuts
│   └── Duration.swift              # Display duration options (1-15s)
├── Intents/                        # App Intents for Shortcuts
│   ├── TriggerLiveActivityIntent.swift    # Live Activity intent
│   └── TriggerNotificationIntent.swift    # Notification intent
├── Managers/                       # Business logic
│   └── NotificationManager.swift   # Notification permission & delivery
├── Views/                          # SwiftUI views
│   └── ContentView.swift           # Main app UI (requests permissions on launch)
├── Shortcuts/                      # Shortcuts configuration
│   └── BluetoothIslandShortcuts.swift     # Registers intents with Shortcuts
└── Shared/                         # Utilities shared between app & widget
    ├── Constants.swift             # App-wide constants
    ├── DeviceIconMapper.swift      # SF Symbol icon mapping
    └── Extensions.swift            # Helper extensions
```

**Widget Extension Target (`BluetoothIslandWidget`):**
- `BluetoothLiveActivity.swift` - Widget configuration for Dynamic Island and Lock Screen
- Shares files with main app:
  - `BluetoothActivityAttributes.swift` (data model)
  - `Constants.swift` (design constants, logging config)
  - `DeviceIconMapper.swift` (icon mapping utility)

### Architecture Flow

#### Live Activity Flow
1. **User Setup:** User creates Shortcuts automation with trigger (Bluetooth, NFC, etc.)
2. **Add Action:** User adds "Show Dynamic Island & Live Activity" action from this app
3. **Configure:** User sets device name, icon, and display duration (1-15 seconds)
4. **Trigger Event:** When automation triggers, Shortcuts calls `TriggerLiveActivityIntent`
5. **Background Execution:** Intent runs with `openAppWhenRun = false` (no app UI shown)
6. **Live Activity:** Intent starts Live Activity with animated checkmark in Dynamic Island
7. **Auto-Dismissal:** Activity automatically ends after configured duration via `Task.sleep(nanoseconds:)`

#### Notification Flow
1. **User Setup:** User creates Shortcuts automation with trigger
2. **Add Action:** User adds "Show Notification" action from this app
3. **Configure:** User sets device name and icon
4. **Trigger Event:** When automation triggers, Shortcuts calls `TriggerNotificationIntent`
5. **Background Execution:** Intent runs with `openAppWhenRun = false`
6. **Notification:** `NotificationManager` sends persistent notification to Notification Center
7. **Persistent:** Notification stays in Notification Center until dismissed by user

### Critical Implementation Details

**App Intents Integration:**
- `TriggerLiveActivityIntent` conforms to `LiveActivityIntent` protocol (iOS 16.4+)
- `TriggerNotificationIntent` conforms to `AppIntent` protocol
- Both use `openAppWhenRun = false` to prevent app from opening when run via Shortcuts
- `@Parameter` decorators expose inputs to Shortcuts (device name, icon, duration)
- `@MainActor` on `perform()` ensures Live Activity runs on main thread
- Parameters include `inputOptions: .init(capitalizationType: .words)` for proper text formatting

**Shortcuts Provider:**
- `BluetoothIslandShortcuts` conforms to `AppShortcutsProvider`
- Registers both intents with Shortcuts app
- Provides suggested Siri phrases for voice activation
- Sets icons and display names for Shortcuts picker:
  - Live Activity: `"iphone.gen3.radiowaves.left.and.right"`
  - Notification: `"bell.badge"`

**Live Activity Lifecycle:**
- Activities started with `Activity.request(attributes:content:pushType:)` directly in Intent
- Duration configured via `Duration` enum (1-15 seconds)
- Uses `Task.sleep(nanoseconds: duration.nanoseconds)` for timed dismissal
- Uses `.immediate` dismissal policy for instant cleanup
- Lock Screen and Dynamic Island presentations configured separately in widget

**Notification Management:**
- `NotificationManager` is an `actor` for thread-safe operation
- Automatically requests permission if not granted
- Uses `UNUserNotificationCenter` for notification delivery
- Category identifier: `Constants.Notification.deviceConnectionCategory`
- Minimum trigger interval: `Constants.Notification.minTriggerInterval` (0.1 seconds)

**Permission Handling:**
- App automatically requests notification permission on first launch (`ContentView.onAppear`)
- Permission state tracked with `@State` variables
- Fallback: Intents still check and request permission if needed
- Uses `os.log` with privacy annotations for debugging

**Shared Utilities:**
- `Constants.swift` - Centralized constants for:
  - SF Symbol icon names
  - Design values (sizes, padding, animation duration)
  - Logging configuration (subsystem, categories)
  - App group identifier
  - Notification categories and strings
- `DeviceIconMapper.swift` - Maps device type strings to SF Symbols
  - Eliminates code duplication between app and widget
  - Single source of truth for icon mapping
- `Extensions.swift` - Helper extensions (Bundle.displayName)

**Device Types:**
Available in `DeviceType` enum: `airpods`, `beats`, `watch`, `keyboard`, `mouse`, `speaker`, `headphones`, `car`, `iphone`, `ipad`, `mac`, `tv`, `generic`

**Duration Options:**
Available in `Duration` enum: `oneSecond`, `twoSeconds`, `threeSeconds`, `fiveSeconds` (default), `tenSeconds`, `fifteenSeconds`
- Computed `nanoseconds` property: `UInt64(seconds * 1_000_000_000)`
- Avoids code duplication with formula-based calculation

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
- `NSUserNotificationsUsageDescription` - For notification permission dialog

**Required Entitlements:**
- `com.apple.security.application-groups` - Share data between app and widget
- App group: `group.com.lazco.BluetoothIsland`

**Not Required:**
- ❌ `NSBluetoothAlwaysUsageDescription` - No Bluetooth access needed (name is misleading!)
- ❌ `UIBackgroundModes` - No background modes needed (Shortcuts handles execution)
- ❌ `com.apple.developer.usernotifications.filtering` - Only for notification content extensions

## Swift Concurrency Notes

**MainActor Isolation:**
- `TriggerLiveActivityIntent.perform()` is `@MainActor` for Live Activity access
- `TriggerNotificationIntent.perform()` is `@MainActor` for notification delivery
- `NotificationManager` is an `actor` for thread-safe permission management
- Communication uses `await` for async bridging

**Error Handling:**
- `LiveActivityError.disabled` - Thrown when Live Activities are disabled in Settings
- `LiveActivityError.activityRequestFailed` - Thrown when Activity.request() fails
- Both errors conform to `CustomLocalizedStringResourceConvertible` for user-facing messages

## Testing on Device

**Requirements:**
- Physical iPhone 14 Pro or newer (for Dynamic Island, older devices show Live Activity on Lock Screen)
- iOS 16.2 or later
- Shortcuts app installed (pre-installed on iOS)

**Setup Flow:**
1. Install app on device
2. App automatically requests notification permission on launch
3. Open Shortcuts app
4. Create new Personal Automation
5. Choose trigger (e.g., "When Bluetooth Connects to [Device]")
6. Add action: Search for "Bluetooth Island"
7. Choose either:
   - **"Show Dynamic Island & Live Activity"** - For Dynamic Island notification
   - **"Show Notification"** - For Notification Center alert
8. Configure parameters:
   - Device Name (e.g., "AirPods Pro")
   - Icon (choose from 13 options)
   - Display Duration (Live Activity only, 1-15 seconds)
9. **Important:** Turn OFF "Show When Run" to hide Shortcuts notification banner
10. Save automation
11. Trigger the automation and watch for notification

**Debugging:**
- Use Console.app or Xcode console to view `os.log` messages
- Logger subsystem: `Constants.Logging.subsystem` → `"com.lazco.BluetoothIsland"`
- Categories:
  - `Constants.Logging.Category.intent` → Intent execution
  - `Constants.Logging.Category.notification` → Notification delivery
- Console logs show when Shortcuts trigger intents and when notifications appear

## Common Modifications

### Adjust Default Display Duration

In `Models/Duration.swift:52`, change the default case in `@Parameter`:
```swift
@Parameter(
  title: "Display Duration",
  description: "How long the notification stays visible",
  default: .threeSeconds  // Change from .fiveSeconds
)
var duration: Duration
```

### Add New Device Type Icons

1. Add case to `DeviceType` enum in `Models/DeviceType.swift`
2. Add display representation with SF Symbol name
3. Add mapping in `deviceTypeString` computed property
4. Update `DeviceIconMapper.swift` switch statement in `Shared/DeviceIconMapper.swift`

### Add New Duration Option

1. Add case to `Duration` enum in `Models/Duration.swift`
2. Add display representation
3. The `nanoseconds` and `seconds` computed properties automatically handle it via formula

### Customize Design Constants

Edit `Shared/Constants.swift`:
- `Constants.Design.DynamicIsland.*` - Dynamic Island sizes
- `Constants.Design.LockScreen.*` - Lock Screen sizes
- `Constants.Design.Animation.checkmarkDuration` - Checkmark animation timing

### Change App Bundle Identifier

Update in `project.yml`:
- `bundleIdPrefix: com.lazco`
- App group name: `group.com.lazco.BluetoothIsland`
- Logger subsystem in `Shared/Constants.swift`

Then regenerate project with `xcodegen generate`.

### Modify Dynamic Island Layout

Edit `BluetoothIslandWidget/BluetoothLiveActivity.swift`:
- `DynamicIslandExpandedRegion(.leading)` - Left side of expanded view
- `DynamicIslandExpandedRegion(.trailing)` - Right side of expanded view
- `DynamicIslandExpandedRegion(.center)` - Center content area
- `compactLeading` - Left side of notch in compact view
- `compactTrailing` - Right side of notch in compact view
- `minimal` - Icon shown when multiple activities are active

### Add Siri Phrases

Edit `Shortcuts/BluetoothIslandShortcuts.swift` to add more voice activation phrases:
```swift
phrases: [
  "Show device connection in \(.applicationName)",
  "Trigger \(.applicationName) notification",
  "My device connected",
  "Show \(.applicationName) alert"
]
```

## Shared Files Between Targets

These files are compiled into both the main app and widget extension (configured in `project.yml`):

1. **BluetoothActivityAttributes.swift** - Live Activity data model
   - Must not contain app-specific or widget-specific code
   - Changes affect both targets

2. **Constants.swift** - App-wide constants
   - Design values, logging config, string constants
   - Ensures consistency between app and widget

3. **DeviceIconMapper.swift** - Icon mapping utility
   - Eliminates code duplication
   - Single source of truth for SF Symbol names

When modifying these files, ensure changes are compatible with both targets.

## Example Automation Use Cases

**AirPods Connection (Live Activity):**
- Trigger: "When Bluetooth connects to AirPods Pro"
- Action: Show Dynamic Island & Live Activity
- Config: "AirPods Pro", AirPods icon, 3 seconds
- Result: 3-second animated notification in Dynamic Island

**Car Bluetooth (Notification):**
- Trigger: "When Bluetooth connects to Car Bluetooth"
- Action: Show Notification
- Config: "Welcome to Car", Car icon
- Result: Persistent notification in Notification Center

**NFC Tag (Live Activity):**
- Trigger: "When NFC tag is scanned"
- Action: Show Dynamic Island & Live Activity
- Config: "Office Check-in", Generic icon, 2 seconds
- Result: Visual confirmation in Dynamic Island when scanning NFC tag

**Time-Based (Live Activity):**
- Trigger: "At 9:00 AM on weekdays"
- Action: Show Dynamic Island & Live Activity
- Config: "Work Mode Activated", Mac icon, 5 seconds
- Result: Daily reminder in Dynamic Island

**Location-Based (Notification):**
- Trigger: "When I arrive at Home"
- Action: Show Notification
- Config: "Welcome Home", Speaker icon
- Result: Greeting notification when arriving home

## Architecture Best Practices

**Code Organization:**
- Models contain data structures and enums only
- Intents handle Shortcuts integration and contain minimal logic
- Managers contain business logic (permissions, notifications)
- Views contain UI only
- Shared utilities eliminate duplication

**Constants Management:**
- All magic numbers in `Constants.swift`
- Design values grouped by component
- String literals centralized
- Easy to modify for theming/customization

**Error Handling:**
- Custom error types with user-facing messages
- Logging at key points with privacy annotations
- Graceful fallbacks (permission checks before operations)

**Async/Await:**
- All async operations use structured concurrency
- MainActor for UI-related operations
- Actor for shared state management
- No completion handlers or delegates

**Testing:**
- Demo buttons can be added to ContentView for testing both notification types
- Use `TriggerLiveActivityIntent()` and `TriggerNotificationIntent()` directly
- Test permission flow on first launch
- Verify both Dynamic Island and Lock Screen presentations
