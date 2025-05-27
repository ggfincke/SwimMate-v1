// WatchRootView.swift

import SwiftUI
import HealthKit

// root view for watch app
struct WatchRootView: View
{
    @EnvironmentObject var manager: WatchManager
    @EnvironmentObject var iosManager: iOSWatchConnector
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
        .alert("HealthKit Access Required", isPresented: $showHealthKitAlert) {
            Button("Open Settings") {
                showSettings = true
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("SwimMate needs HealthKit access to track your swimming workouts. Please enable access in Settings.")
        }
    }
}

// MARK: - Preview

#Preview
{
    WatchRootView()
        .environmentObject(WatchManager())
        .environmentObject(iOSWatchConnector())
}
