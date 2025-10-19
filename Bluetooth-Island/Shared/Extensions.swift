//
//  Extensions.swift
//  Bluetooth-Island
//
//  Helpful extensions for common operations
//

import Foundation

// MARK: - Bundle Extensions

extension Bundle {
  /// Returns the display name of the app from Info.plist
  /// Falls back to the bundle name if display name is not available
  var displayName: String? {
    object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
      ?? object(forInfoDictionaryKey: "CFBundleName") as? String
  }

  /// Returns the app version (e.g., "1.0")
  /// Corresponds to MARKETING_VERSION in project.yml
  var appVersion: String {
    infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
  }

  /// Returns the build number (e.g., "1")
  /// Corresponds to CURRENT_PROJECT_VERSION in project.yml
  var buildNumber: String {
    infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
  }

  /// Returns the formatted version with build number (e.g., "v1.0 (1)")
  var versionBuild: String {
    "v\(appVersion) (\(buildNumber))"
  }

  /// Returns the simple version with prefix (e.g., "v1.0")
  var versionString: String {
    "v\(appVersion)"
  }
}
