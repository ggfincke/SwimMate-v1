// WatchManager.swift

import Foundation
import HealthKit
import Observation
import SwiftUI
import WatchKit

// Main WatchManager
@Observable
class WatchManager: NSObject
{
    // device properties (determines if device is compact)
    private let screenBounds = WKInterfaceDevice.current().screenBounds
    var isCompactDevice: Bool
    {
        screenBounds.height <= 200
    }

    // pool settings
    var isPool: Bool = true
    var poolLength: Double = 25.0
    var poolUnit: String = "meters"
    var running = false

    // goal unit (separate from pool unit, set when goal is established)
    var goalUnit: String = "meters"
    var goalUnitLocked: Bool = false

    // healthkit
    var healthStore = HKHealthStore()
    var workoutSession: HKWorkoutSession?
    var workoutBuilder: HKLiveWorkoutBuilder?

    // timer for elapsed time updates
    var elapsedTimer: Timer?
    var workoutStartDate: Date?

    // path for views
    var path = NavigationPath()

    // workout metrics
    var elapsedTime: TimeInterval = 0
    var laps: Int = 0
    var distance: Double = 0
    {
        // when distance changes, update laps
        didSet
        {
            updateLapsFromCurrentDistance()
        }
    }

    var averageHeartRate: Double = 0
    var heartRate: Double = 0
    var activeEnergy: Double = 0
    var workout: HKWorkout?

    // goals
    var goalDistance: Double = 0
    var goalTime: TimeInterval = 0
    var goalHours: TimeInterval = 0
    var goalMinutes: TimeInterval = 0
    var goalCalories: Double = 0

    // healthkit authorization
    var healthKitAuthorized: Bool = false
    var authorizationRequested: Bool = false

    // UserDefaults keys for persistence
    let authRequestedKey = "HealthKitAuthorizationRequested"

    // HK types
    let requiredShareTypes: Set<HKSampleType> = [
        HKObjectType.workoutType(),
        HKQuantityType.quantityType(forIdentifier: .distanceSwimming)!,
        HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
    ]

    let requiredReadTypes: Set<HKObjectType> = [
        HKObjectType.workoutType(),
        HKQuantityType.quantityType(forIdentifier: .heartRate)!,
        HKQuantityType.quantityType(forIdentifier: .distanceSwimming)!,
        HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
    ]

    // types required for basic workout function
    let essentialReadTypes: Set<HKObjectType> = [
        HKObjectType.workoutType(),
        HKQuantityType.quantityType(forIdentifier: .distanceSwimming)!,
        HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
    ]

    // can start workout - now properly checks authorization
    var canStartWorkout: Bool
    {
        return HKHealthStore.isHealthDataAvailable() && healthKitAuthorized
    }

    // only pick workout when selected is not nil
    var selected: HKWorkoutActivityType?
    {
        didSet
        {
            guard selected != nil
            else
            {
                return
            }
            startWorkout()
        }
    }

    // showing summary view after workout
    var showingSummaryView = false
    {
        didSet
        {
            if showingSummaryView == false
            {
                selected = nil
            }
        }
    }

    // MARK: - Initialization

    override init()
    {
        super.init()

        // sync goal unit with pool unit initially
        goalUnit = poolUnit

        // load persisted auth state & check current status
        loadAndCheckAuthorizationStatus()
    }
}
