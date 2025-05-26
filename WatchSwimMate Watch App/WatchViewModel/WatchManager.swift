// WatchManager.swift

import Foundation
import SwiftUI
import HealthKit
import WatchKit

// Main WatchManager
class WatchManager: NSObject, ObservableObject
{
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
    private var elapsedTimer: Timer?
    private var workoutStartDate: Date?
    
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
    
    // healthkit authorization
    @Published var healthKitAuthorized: Bool = false
    @Published var authorizationRequested: Bool = false
    
    // can start workout
    var canStartWorkout: Bool
    {
        return true
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
    
    // reset back to root (for navigation)
    func resetNav()
    {
        path = NavigationPath()
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
    
    // MARK: - Timer Management
    private func startElapsedTimer() {
        stopElapsedTimer() 
        workoutStartDate = Date()
        elapsedTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            self?.updateElapsedTime()
        }
    }
    
    private func stopElapsedTimer() {
        elapsedTimer?.invalidate()
        elapsedTimer = nil
    }
    
    private func updateElapsedTime() {
        guard let startDate = workoutStartDate else { return }
        DispatchQueue.main.async {
            self.elapsedTime = Date().timeIntervalSince(startDate)
        }
    }
    
    // request HK auth
    func requestAuthorization()
    {
        let toShare: Set = [
            HKObjectType.workoutType(),
            HKQuantityType.quantityType(forIdentifier: .distanceSwimming)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        ]

        let toRead: Set = [
            HKObjectType.workoutType(),
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .distanceSwimming)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        ]

        healthStore.requestAuthorization(toShare: toShare, read: toRead)
        { ok, err in
            DispatchQueue.main.async {
                self.authorizationRequested = true
                self.healthKitAuthorized = ok
            }
            print(ok ? "✅ HealthKit authorised" :
                  "❌ HealthKit authorisation failed: \(err?.localizedDescription ?? "unknown")")
        }
    }

    //MARK: Workout related functions
    func startWorkout()
    {
        // session is already running, return
        guard workoutSession == nil else { return }

        // building config
        let cfg = HKWorkoutConfiguration()
        cfg.activityType = .swimming
        cfg.swimmingLocationType = isPool ? .pool : .openWater

        if isPool {
            let length = HKQuantity(
                unit: poolUnit == "meters" ? .meter() : .yard(),
                doubleValue: poolLength
            )
            cfg.lapLength = length
        }

        // create session & builder
        do
        {
            workoutSession = try HKWorkoutSession(healthStore: healthStore,
                                                  configuration: cfg)
            workoutBuilder = workoutSession?.associatedWorkoutBuilder()
        }
        catch
        {
            print("❌ Failed to create session: \(error)")
            return
        }

        // wire delegates & data source BEFORE starting
        workoutSession?.delegate = self
        workoutBuilder?.delegate = self
        workoutBuilder?.dataSource =
            HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: cfg)

        // water-lock & go
        WKInterfaceDevice.current().enableWaterLock()
        let now = Date()
        workoutSession?.startActivity(with: now)
        workoutBuilder?.beginCollection(withStart: now)
        { [weak self] _, err in
            if let err = err { 
                print("❌ beginCollection: \(err)") 
            } else {
                // Start our elapsed time timer
                DispatchQueue.main.async {
                    self?.startElapsedTimer()
                }
            }
        }
    }
    
    // pause
    func pause()
    {
        workoutSession?.pause()
        stopElapsedTimer()
    }

    // resume
    func resume()
    {
        workoutSession?.resume()
        startElapsedTimer()
    }

    // toggle pause/resume
    func togglePause()
    {
        if running == true
        {
            pause()
        }
        else
        {
            resume()
        }
    }

    // end workout
    func endWorkout()
    {
        // Stop the elapsed timer
        stopElapsedTimer()
        
        // check to ensure active session
        guard let workoutSession = workoutSession,
              workoutSession.state == .running || workoutSession.state == .paused else {
            print("No active workout session to end")
            showingSummaryView = true
            return
        }
        
        workoutSession.end()
    }
    
    // reset w/ better cleanup
    func resetWorkout()
    {
        selected = nil
        
        // Stop timer
        stopElapsedTimer()
        workoutStartDate = nil
        
        // avoid retain cycles
        workoutBuilder?.delegate = nil
        workoutSession?.delegate = nil
        
        // clean up builder & session
        workoutBuilder = nil
        workoutSession = nil
        
        workout = nil
        activeEnergy = 0
        averageHeartRate = 0
        heartRate = 0
        distance = 0
        elapsedTime = 0
        laps = 0
        
        // reset goals
        goalDistance = 0
        goalTime = 0
        goalCalories = 0
        
        // ensure summary view is hidden
        showingSummaryView = false
    }

    // used to display stats for the watch while swimming
    func updateForStatistics(_ statistics: HKStatistics?)
    {
        guard let statistics = statistics else { return }
        
        DispatchQueue.main.async
        {
            switch statistics.quantityType
            {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .distanceSwimming):
                let metres = HKUnit.meter()
                self.distance = statistics.sumQuantity()?.doubleValue(for: metres) ?? 0
            default:
                return
            }
        }
    }
    
    // update lap count
    func updateLapsCount(from workout: HKWorkout) {
        if let distance = workout.totalDistance, let poolLength = workoutBuilder?.workoutConfiguration.lapLength
        {
            DispatchQueue.main.async {
                self.laps = Int(round(distance.doubleValue(for: .meter()) / poolLength.doubleValue(for: .meter())))
            }
        }
        else
        {
            updateLapsFromCurrentDistance()
        }
    }
    
    // calculate laps from current distance (needed? workout should be able to do this)
    func updateLapsFromCurrentDistance()
    {
        let poolLengthInMeters: Double
        
        if poolUnit == "meters"
        {
            poolLengthInMeters = poolLength
        }
        else
        {
            // convert yards to meters
            poolLengthInMeters = poolLength * 0.9144
        }
        
        if poolLengthInMeters > 0
        {
            let calculatedLaps = Int(round(distance / poolLengthInMeters))
            if calculatedLaps != laps {
                DispatchQueue.main.async {
                    self.laps = calculatedLaps
                }
            }
        }
        else
        {
            if laps != 0 {
                DispatchQueue.main.async {
                    self.laps = 0
                }
            }
        }
    }
}

// MARK: - HKWorkoutSessionDelegate
extension WatchManager: HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate
{
    // MARK: - HKLiveWorkoutBuilderDelegate Methods
    
    // called when workoutbuilder collects events; laps, pause/resume, etc.
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder)
    {
        print("Workout builder collected event")
    }

    // called when new health data is collected during workout
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>)
    {
        // iterate through each collected data type & update published properties
        for type in collectedTypes
        {
            guard let quantityType = type as? HKQuantityType else
            {
                continue
            }

            // stats for this data type
            let statistics = workoutBuilder.statistics(for: quantityType)

            // update published values on main thread
            updateForStatistics(statistics)
        }
    }
    
    // MARK: - HKWorkoutSessionDelegate Methods
    func workoutSession(_ workoutSession: HKWorkoutSession,
                        didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState,
                        date: Date)
    {
        DispatchQueue.main.async
        {
            self.running = toState == .running
        }
        
        // Handle timer based on state
        switch toState {
        case .running:
            if fromState == .paused {
                startElapsedTimer()
            }
        case .paused:
            stopElapsedTimer()
        case .ended:
            stopElapsedTimer()
            handleWorkoutEnd(date: date)
        default:
            break
        }
    }
    
    private func handleWorkoutEnd(date: Date) {
        self.workoutBuilder?.endCollection(withEnd: date) { (success, error) in
            if let error = error {
                print("Error ending collection: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.workout = nil
                    self.showingSummaryView = true
                }
                return
            }
            
            self.workoutBuilder?.finishWorkout { (workout, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error finishing workout: \(error.localizedDescription)")
                    }
                    
                    self.workout = workout
                    
                    if let workout = workout {
                        self.updateLapsCount(from: workout)
                        print("Workout finished: \(workout)")
                    } else {
                        print("Workout finished but workout object is nil")
                        self.updateLapsFromCurrentDistance()
                    }
                    
                    self.showingSummaryView = true
                }
            }
        }
    }

    // failed w/ error
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error)
    {
        print("Workout session failed with error: \(error.localizedDescription)")
        stopElapsedTimer()
        DispatchQueue.main.async
        {
            self.showingSummaryView = true
        }
    }
}