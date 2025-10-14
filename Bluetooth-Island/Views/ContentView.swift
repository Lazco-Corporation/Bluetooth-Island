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
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(spacing: 24) {
          // App icon and title
          VStack(spacing: 12) {
            Image(systemName: "iphone.gen3.radiowaves.left.and.right")
              .font(.system(size: 60))
              .foregroundColor(.blue)
              .accessibilityLabel("Bluetooth Island app icon")

            Text("Bluetooth Island")
              .font(.title)
              .fontWeight(.bold)
          }
          .padding(.top, 40)

          // Instructions
          VStack(alignment: .leading, spacing: 16) {
            Text("Setup Instructions")
              .font(.headline)

            VStack(alignment: .leading, spacing: 12) {
              InstructionRow(
                number: "1",
                text: "Open the Shortcuts app"
              )

              InstructionRow(
                number: "2",
                text: "Create a new automation with your preferred trigger"
              )

              InstructionRow(
                number: "3",
                text: "Add \"Show Live Activity\" or \"Send Notification\" action"
              )

              InstructionRow(
                number: "4",
                text: "Configure device name and icon"
              )

              InstructionRow(
                number: "5",
                text: "Run your automation to see the notification"
              )
            }
          }
          .padding()
          .background(Color.secondary.opacity(0.1))
          .cornerRadius(12)

          Spacer()
        }
        .padding()
      }
      .navigationBarHidden(true)
    }
  }
}

/// Single instruction row with number badge
struct InstructionRow: View {
  let number: String
  let text: String

  var body: some View {
    HStack(alignment: .top, spacing: 12) {
      Text(number)
        .font(.caption)
        .fontWeight(.bold)
        .foregroundColor(.white)
        .frame(width: 24, height: 24)
        .background(Color.blue)
        .clipShape(Circle())
        .accessibilityLabel("Step \(number)")

      Text(text)
        .font(.subheadline)
        .fixedSize(horizontal: false, vertical: true)
    }
  }
}

#Preview {
  ContentView()
}
