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
}
