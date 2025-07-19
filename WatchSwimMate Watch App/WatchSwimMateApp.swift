// WatchSwimMateApp.swift

import SwiftUI
import HealthKit

@main
struct WatchSwimMate_Watch_App: App
{
    @State private var watchManager = WatchManager()
    @State private var iosConnector = iOSWatchConnector()
    @State private var showingPermissionView = false

    @SceneBuilder var body: some Scene
    {
        WindowGroup
        {
            NavigationStack(path: $watchManager.path)
            {
                WatchRootView()
                .navigationDestination(for: NavState.self)
                {
                    state in
                    switch state
                    {
                        case .swimSetup:
                        SwimSetupView()
                        case .goalSwimSetup:
                        GoalSwimView()
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
            .sheet(isPresented: $showingPermissionView)
            {
                HealthKitPermissionView()
            }
            .environment(watchManager)
            .environment(iosConnector)
            .onAppear
            {
                // check permission view should be shown on launch
                checkForPermissionViewNeeded()
            }
            .onChange(of: watchManager.authorizationRequested)
            {
                _, newValue in
                // if auth was just requested and some level of access, hide permission view
                if newValue && (watchManager.healthKitAuthorized || hasPartialAccess())
                {
                    showingPermissionView = false
                }
            }
            .onChange(of: watchManager.healthKitAuthorized)
            {
                _, newValue in
                // if auth status changes to authorized, hide permission view
                print("📱 HealthKit authorized changed to: \(newValue)")
                if newValue && showingPermissionView
                {
                    showingPermissionView = false
                    print("📱 Dismissing permission view - authorization granted")
                }
            }
        }
    }

    // check if need to show permission view
    private func checkForPermissionViewNeeded()
    {
        // only show permission view if:
        // 1. HK is available on device
        // 2. we don't have essential permissions

        guard HKHealthStore.isHealthDataAvailable() else
        {
            print("HealthKit not available on this device")
            return
        }

        // give manager a moment to initialize & check existing permissions
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
        {
            if !watchManager.healthKitAuthorized
            {
                print("Showing HealthKit permission view - missing essential permissions")
                showingPermissionView = true
            }
            else
            {
                print("Permission view not needed:")
                print("- Authorization requested: \(watchManager.authorizationRequested)")
                print("- HealthKit authorized: \(watchManager.healthKitAuthorized)")
            }
        }
    }

    // check if have partial access (some permissions granted)
    private func hasPartialAccess() -> Bool
    {
        guard HKHealthStore.isHealthDataAvailable() else
        {
            return false
        }

        let workoutAuthorized = watchManager.healthStore.authorizationStatus(for: HKObjectType.workoutType()) == .sharingAuthorized
        let distanceAuthorized = watchManager.healthStore.authorizationStatus(for: HKQuantityType.quantityType(forIdentifier: .distanceSwimming)!) == .sharingAuthorized
        let energyAuthorized = watchManager.healthStore.authorizationStatus(for: HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!) == .sharingAuthorized

        return workoutAuthorized || distanceAuthorized || energyAuthorized
    }
}
