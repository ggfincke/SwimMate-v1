// SwimMate/iOSViews/SettingsView/HealthKitPermissionView.swift

import SwiftUI
import HealthKit
import HealthKitUI

struct HealthKitPermissionView: View {
    @EnvironmentObject var manager: Manager
    let allTypes: Set = [
        HKQuantityType.workoutType(),
        HKQuantityType(.activeEnergyBurned),
        HKQuantityType(.heartRate),
        HKQuantityType(.swimmingStrokeCount),
        HKQuantityType(.waterTemperature),
        HKQuantityType(.underwaterDepth)
    ]

    @State private var trigger = false
    @State private var authenticated = false

    var body: some View {
        VStack 
        {
            if authenticated 
            {
                Text("HealthKit Access Granted")
            } 
            else
            {
                Text("Requesting HealthKit Access...")
            }
        }
        .onAppear 
        {
            requestHealthDataAccess()
        }
        
        // update your views or handle state changes as needed
        .onChange(of: trigger) 
        {
            requestHealthDataAccess()
        }
    }

    private func requestHealthDataAccess() 
    {
        // Ensure Health data is available on the device before requesting access
        guard HKHealthStore.isHealthDataAvailable() else 
        {
            print("HealthKit is not available on this device.")
            return
        }

        manager.healthStore.requestAuthorization(toShare: allTypes, read: allTypes) 
        { success, error in
            if let error = error
            {
                print("*** An error occurred while requesting authentication: \(error.localizedDescription) ***")
            } 
            else
            {
                authenticated = success
            }
        }
    }
}
