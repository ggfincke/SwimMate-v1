//
//  WatchSwimMateApp.swift
//  WatchSwimMate Watch App
//
//  Created by Garrett Fincke on 4/26/24.
//

import SwiftUI
import HealthKit

@main
struct WatchSwimMate_Watch_App: App
{
    @StateObject private var watchManager = WatchManager()
    @StateObject private var iosConnector = iOSWatchConnector()
    @State private var showingPermissionView = false

    @SceneBuilder var body: some Scene
    {
        WindowGroup
        {
            NavigationStack(path: $watchManager.path)
            {
                WatchRootView()
                    .navigationDestination(for: NavState.self) { state in
                        switch state
                        {
                            case .workoutSetup:
                                WorkoutSetupView()
                            case .goalWorkoutSetup:
                                GoalWorkoutSetupView()
                            case .indoorPoolSetup:
                                IndoorPoolSetupView()
                            case .swimmingView(let set):
                                SwimmingView(set: set)
                            case .importSetView:
                                ImportSetView()
                        }
                    }
            }
            .sheet(isPresented: $watchManager.showingSummaryView)
            {
                SwimmingSummaryView()
            }
            .sheet(isPresented: $showingPermissionView) {
                HealthKitPermissionView()
            }
            .environmentObject(watchManager)
            .environmentObject(iosConnector)
            .onAppear {
                // Check if we should show permission view on launch
                checkForPermissionViewNeeded()
            }
            .onChange(of: watchManager.authorizationRequested) { _, newValue in
                // If authorization was just requested and denied, we might want to show guidance
                if newValue && !watchManager.healthKitAuthorized {
                    // Permission was requested but denied - the settings view will handle this
                }
            }
        }
    }
    
    // Check if we need to show the permission view
    private func checkForPermissionViewNeeded() {
        // Only show permission view if:
        // 1. HealthKit is available on device
        // 2. We haven't requested authorization yet
        // 3. We don't already have authorization
        
        guard HKHealthStore.isHealthDataAvailable() else { return }
        
        // Give the manager a moment to initialize and check existing permissions
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if !watchManager.authorizationRequested && !watchManager.healthKitAuthorized {
                showingPermissionView = true
            }
        }
    }
}
