// WatchRootView.swift

import SwiftUI
import HealthKit

// root view for watch app
struct WatchRootView: View
{
    @Environment(WatchManager.self) private var manager
    @Environment(iOSWatchConnector.self) private var iosManager
    @State private var showSettings = false
    @State private var activeButton: String? = nil
    @State private var showHealthKitAlert = false

    var body: some View
    {
        ScrollView
        {
            VStack(spacing: 16)
            {
                HeaderSection()

                if manager.authorizationRequested && !manager.healthKitAuthorized
                {
                    HealthKitWarningSection(showSettings: $showSettings)
                }

                Divider()
                .padding(.horizontal)

                NavigationButtonsSection(
                activeButton: $activeButton,
                showSettings: $showSettings,
                showHealthKitAlert: $showHealthKitAlert
                )
            }
            .padding(.bottom, 12)
        }
        .sheet(isPresented: $showSettings)
        {
            SettingsView()
        }
        .alert("HealthKit Access Required", isPresented: $showHealthKitAlert)
        {
            Button("Open Settings")
            {
                showSettings = true
            }
            Button("Cancel", role: .cancel)
            {
            }
        }
        message:
        {
            Text("SwimMate needs HealthKit access to track your swimming workouts. Please enable access in Settings.")
        }
    }
}

// MARK: - Preview

#Preview
{
    WatchRootView()
    .environment(WatchManager())
    .environment(iOSWatchConnector())
}
