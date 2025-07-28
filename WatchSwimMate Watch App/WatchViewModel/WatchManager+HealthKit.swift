// WatchManager+HealthKit.swift

// HealthKit Authorization Extension

import Foundation
import HealthKit

// MARK: - HealthKit Authorization

extension WatchManager
{
    // load persisted state (via userdefaults) & check current HK auth status
    func loadAndCheckAuthorizationStatus()
    {
        // load if ever requested auth
        authorizationRequested = UserDefaults.standard.bool(forKey: authRequestedKey)

        // check current HK auth status
        checkCurrentAuthorizationStatus()
    }

    // check current HK auth status w/o requesting permission
    func checkCurrentAuthorizationStatus()
    {
        guard HKHealthStore.isHealthDataAvailable()
        else
        {
            DispatchQueue.main.async
            {
                self.healthKitAuthorized = false
            }
            return
        }

        // check auth status for essential types only (heart rate is nice-to-have but not required for basic workout functionality)
        print("🔍 Essential Types Authorization Check:")
        var essentialResults: [String] = []

        let essentialTypesAuthorized = essentialReadTypes.allSatisfy
        {
            type in
            let status = healthStore.authorizationStatus(for: type)
            let isAuthorized = status == .sharingAuthorized
            let result = "\(type): \(authStatusString(status)) (\(isAuthorized ? "✅" : "❌"))"
            essentialResults.append(result)
            return isAuthorized
        }

        // also check if we can share workout data
        let canShareWorkouts = healthStore.authorizationStatus(for: HKObjectType.workoutType()) == .sharingAuthorized
        essentialResults.append("Workout Sharing: \(authStatusString(healthStore.authorizationStatus(for: HKObjectType.workoutType()))) (\(canShareWorkouts ? "✅" : "❌"))")

        let isAuthorized = essentialTypesAuthorized && canShareWorkouts

        for result in essentialResults
        {
            print("  - \(result)")
        }
        print("  - Final Result: \(isAuthorized)")

        DispatchQueue.main.async
        {
            self.healthKitAuthorized = isAuthorized

            // if auth but haven't marked as requested, update that
            if isAuthorized, !self.authorizationRequested
            {
                self.updateAuthorizationRequestedFlag()
            }
        }

        print("HealthKit Authorization Status Check:")
        print("- Authorization Previously Requested: \(authorizationRequested)")
        print("- Currently Authorized (Essential Types): \(isAuthorized)")

        // print type statuses
        for type in requiredReadTypes
        {
            let status = healthStore.authorizationStatus(for: type)
            let isEssential = essentialReadTypes.contains(type)
            print("- \(type): \(authStatusString(status))\(isEssential ? " [Essential]" : " [Optional]")")
        }
    }

    // convert HKAuthorizationStatus to readable string for debugging
    private func authStatusString(_ status: HKAuthorizationStatus) -> String
    {
        switch status
        {
        case .notDetermined: return "Not Determined"
        case .sharingDenied: return "Denied"
        case .sharingAuthorized: return "Authorized"
        @unknown default: return "Unknown"
        }
    }

    // request HK auth & persist request state
    func requestAuthorization()
    {
        guard HKHealthStore.isHealthDataAvailable()
        else
        {
            print("HealthKit is not available on this device")
            return
        }

        print("🔐 Requesting HealthKit authorization...")
        print("🔐 Share types: \(requiredShareTypes)")
        print("🔐 Read types: \(requiredReadTypes)")

        healthStore.requestAuthorization(toShare: requiredShareTypes, read: requiredReadTypes)
        {
            [weak self] success, error in
            guard let self = self
            else
            {
                return
            }

            DispatchQueue.main.async
            {
                // mark requested auth
                self.authorizationRequested = true
                UserDefaults.standard.set(true, forKey: self.authRequestedKey)

                if let error = error
                {
                    print("❌ HealthKit authorization failed: \(error.localizedDescription)")
                }
                else
                {
                    print(success ? "✅ HealthKit authorization request completed successfully" : "⚠️ HealthKit authorization request completed with some denials")
                    print("🔐 Authorization callback - success: \(success)")
                }

                // delay before checking status to allow HK to fully update
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5)
                {
                    self.checkCurrentAuthorizationStatus()
                }
            }
        }
    }

    // reset auth state (useful for testing or debugging)
    func resetAuthorizationState()
    {
        UserDefaults.standard.removeObject(forKey: authRequestedKey)
        authorizationRequested = false
        healthKitAuthorized = false

        print("🔄 Authorization state reset")

        // re-check current status
        checkCurrentAuthorizationStatus()
    }

    // update auth requested flag
    func updateAuthorizationRequestedFlag()
    {
        authorizationRequested = true
        UserDefaults.standard.set(true, forKey: authRequestedKey)
        print("🔄 Authorization requested flag updated")
    }

    // check if should show permission dialog
    func shouldShowPermissionDialog() -> Bool
    {
        return HKHealthStore.isHealthDataAvailable() &&
            (!authorizationRequested || !healthKitAuthorized)
    }
}
