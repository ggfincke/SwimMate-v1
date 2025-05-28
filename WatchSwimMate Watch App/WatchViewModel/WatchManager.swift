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
    var isCompactDevice: Bool {
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
    
    // healthkit authorization - now with persistence
    @Published var healthKitAuthorized: Bool = false
    @Published var authorizationRequested: Bool = false
    
    // UserDefaults keys for persistence
    private let authRequestedKey = "HealthKitAuthorizationRequested"
    
    // HK types
    private let requiredShareTypes: Set<HKSampleType> = [
        HKObjectType.workoutType(),
        HKQuantityType.quantityType(forIdentifier: .distanceSwimming)!,
        HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
    ]
    
    private let requiredReadTypes: Set<HKObjectType> = [
        HKObjectType.workoutType(),
        HKQuantityType.quantityType(forIdentifier: .heartRate)!,
        HKQuantityType.quantityType(forIdentifier: .distanceSwimming)!,
        HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
    ]
    
    // types required for basic workout function
    private let essentialReadTypes: Set<HKObjectType> = [
        HKObjectType.workoutType(),
        HKQuantityType.quantityType(forIdentifier: .distanceSwimming)!,
        HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
    ]
    
    // can start workout - now properly checks authorization
    var canStartWorkout: Bool
    {
        return HKHealthStore.isHealthDataAvailable() && healthKitAuthorized
    }
    
    // init
    override init() 
    {
        super.init()
        
        // load persisted auth state & check current status
        loadAndCheckAuthorizationStatus()
    }
    
    // load persisted state (via userdefaults) & check current HK auth status
    private func loadAndCheckAuthorizationStatus()
    {
        // load if ever requested auth
        authorizationRequested = UserDefaults.standard.bool(forKey: authRequestedKey)
        
        // check current HK auth status
        checkCurrentAuthorizationStatus()
    }
    
    // check current HK auth status w/o requesting permission
    private func checkCurrentAuthorizationStatus() 
    {
        guard HKHealthStore.isHealthDataAvailable() else {
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
        { type in
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
        
        for result in essentialResults {
            print("  - \(result)")
        }
        print("  - Final Result: \(isAuthorized)")
        
        DispatchQueue.main.async 
        {
            self.healthKitAuthorized = isAuthorized
            
            // if auth but haven't marked as requested, update that
            if isAuthorized && !self.authorizationRequested 
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
        guard HKHealthStore.isHealthDataAvailable() else 
        {
            print("HealthKit is not available on this device")
            return
        }
        
        print("🔐 Requesting HealthKit authorization...")
        print("🔐 Share types: \(requiredShareTypes)")
        print("🔐 Read types: \(requiredReadTypes)")
        
        healthStore.requestAuthorization(toShare: requiredShareTypes, read: requiredReadTypes) { [weak self] success, error in
            guard let self = self else { return }
            
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.checkCurrentAuthorizationStatus()
                }
            }
        }
    }
    
    // reset auth state (useful for testing or debugging)
    func resetAuthorizationState() {
        UserDefaults.standard.removeObject(forKey: authRequestedKey)
        authorizationRequested = false
        healthKitAuthorized = false
        
        print("🔄 Authorization state reset")
        
        // re-check current status
        checkCurrentAuthorizationStatus()
    }
    
    // update auth requested flag
    func updateAuthorizationRequestedFlag() {
        authorizationRequested = true
        UserDefaults.standard.set(true, forKey: authRequestedKey)
        print("🔄 Authorization requested flag updated")
    }
    
    // check if should show permission dialog
    func shouldShowPermissionDialog() -> Bool {
        return HKHealthStore.isHealthDataAvailable() &&
               (!authorizationRequested || !healthKitAuthorized)
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

    //MARK: Workout related functions
    func startWorkout()
    {
        // check auth before starting workout
        guard canStartWorkout else 
        {
            print("❌ Cannot start workout: HealthKit not authorized")
            return
        }
        
        // if session is already running, return
        guard workoutSession == nil else { return }

        // build config
        let cfg = HKWorkoutConfiguration()
        cfg.activityType = .swimming
        cfg.swimmingLocationType = isPool ? .pool : .openWater

        if isPool 
        {
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
            if let err = err 
            {
                print("❌ beginCollection: \(err)")
            } 
            else 
            {
                // start elapsed time timer
                DispatchQueue.main.async 
                {
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
        // stop elapsed timer
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
        
        // stop timer
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
    func updateLapsCount(from workout: HKWorkout) 
    {
        if let distance = workout.totalDistance, let poolLength = workoutBuilder?.workoutConfiguration.lapLength
        {
            DispatchQueue.main.async 
            {
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
            if calculatedLaps != laps 
            {
                DispatchQueue.main.async 
                {
                    self.laps = calculatedLaps
                }
            }
        }
        else
        {
            if laps != 0 
            {
                DispatchQueue.main.async 
                {
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
        
        // handle timer based on state
        switch toState {
        case .running:
            if fromState == .paused 
            {
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
    
    private func handleWorkoutEnd(date: Date) 
    {
        // show summary immediately
        DispatchQueue.main.async 
        {
            self.showingSummaryView = true
        }
        
        self.workoutBuilder?.endCollection(withEnd: date) { (success, error) in
            if let error = error 
            {
                print("Error ending collection: \(error.localizedDescription)")
                DispatchQueue.main.async 
                {
                    self.workout = nil
                    // summary is already showing
                }
                return
            }
            
            self.workoutBuilder?.finishWorkout { (workout, error) in
                DispatchQueue.main.async 
                {
                    if let error = error 
                    {
                        print("Error finishing workout: \(error.localizedDescription)")
                    }
                    
                    self.workout = workout
                    
                    if let workout = workout 
                    {
                        self.updateLapsCount(from: workout)
                        print("Workout finished: \(workout)")
                    } 
                    else 
                    {
                        print("Workout finished but workout object is nil")
                        self.updateLapsFromCurrentDistance()
                    }
                    
                    // summary will update automatically via @Published
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
