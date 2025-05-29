// WatchManager.swift

import Foundation
import SwiftUI
import HealthKit
import WatchKit

// Main WatchManager
class WatchManager: NSObject, ObservableObject
{
    // device properties
    private let screenBounds = WKInterfaceDevice.current().screenBounds
    var isCompactDevice: Bool 
    {
        screenBounds.height <= 200
    }
    
    // pool settings
    @Published var isPool: Bool = true
    @Published var poolLength: Double = 25.0
    @Published var poolUnit: String = "meters"
    @Published var running = false

    // healthkit
    var healthStore = HKHealthStore()
    var workoutSession: HKWorkoutSession?
    var workoutBuilder: HKLiveWorkoutBuilder?
    
    // timer for elapsed time updates
    var elapsedTimer: Timer?
    var workoutStartDate: Date?
    
    // path for views
    @Published var path = NavigationPath()
    
    // workout metrics
    @Published var elapsedTime: TimeInterval = 0
    @Published var laps: Int = 0
    @Published var distance: Double = 0
    {
        // when distance changes, update laps
        didSet
        {
            updateLapsFromCurrentDistance()
        }
    }
    @Published var averageHeartRate: Double = 0
    @Published var heartRate: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var workout: HKWorkout?
    
    // goals
    @Published var goalDistance: Double = 0
    @Published var goalTime: TimeInterval = 0
    @Published var goalHours: TimeInterval = 0
    @Published var goalMinutes: TimeInterval = 0
    @Published var goalCalories: Double = 0
    
    // healthkit authorization - now with persistence
    @Published var healthKitAuthorized: Bool = false
    @Published var authorizationRequested: Bool = false
    
    // UserDefaults keys for persistence
    let authRequestedKey = "HealthKitAuthorizationRequested"
    
    // HK types
    let requiredShareTypes: Set<HKSampleType> = [
        HKObjectType.workoutType(),
        HKQuantityType.quantityType(forIdentifier: .distanceSwimming)!,
        HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
    ]
    
    let requiredReadTypes: Set<HKObjectType> = [
        HKObjectType.workoutType(),
        HKQuantityType.quantityType(forIdentifier: .heartRate)!,
        HKQuantityType.quantityType(forIdentifier: .distanceSwimming)!,
        HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
    ]
    
    // types required for basic workout function
    let essentialReadTypes: Set<HKObjectType> = [
        HKObjectType.workoutType(),
        HKQuantityType.quantityType(forIdentifier: .distanceSwimming)!,
        HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
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
            guard selected != nil else { return }
            startWorkout()
        }
    }
    
    // showing summary view after workout
    @Published var showingSummaryView = false
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
        
        // load persisted auth state & check current status
        loadAndCheckAuthorizationStatus()
    }
} 