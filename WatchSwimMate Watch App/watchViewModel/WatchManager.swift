//
//  WatchManager.swift
//  WatchSwimMate Watch App
//
//  Created by Garrett Fincke on 4/26/24.
//

import Foundation
import SwiftUI
import HealthKit
import WatchKit

//class WatchManager: NSObject, HKWorkoutSessionDelegate, ObservableObject

class WatchManager: NSObject, ObservableObject
{
    @Published var isPool: Bool = true
    @Published var poolLength: Double = 25.0
    @Published var poolUnit: String = "meters"
    @Published var running = false


    var healthStore = HKHealthStore()
    var workoutSession: HKWorkoutSession?
    var workoutBuilder: HKLiveWorkoutBuilder?
    
    // MARK: - Workout Metrics
    @Published var elapsedTime: TimeInterval = 0
    @Published var laps: Int = 0
    @Published var distance: Double = 0
    @Published var averageHeartRate: Double = 0
    @Published var heartRate: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var workout: HKWorkout?

    
    
    @Published var goalDistance: Double = 0
    @Published var goalHours: TimeInterval = 0
    @Published var goalMinutes: TimeInterval = 0

    @Published var goalCalories: Double = 0
    
    // only pick workout when selected is not nil
    var selected: HKWorkoutActivityType?
    {
        didSet
        {
            guard let selected = selected else { return }
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
    
    func requestAuthorization()
    {
        let typesToShare: Set = [HKObjectType.workoutType()]
        let typesToRead: Set = [HKQuantityType.workoutType(), HKQuantityType.quantityType(forIdentifier: .heartRate)!]
        
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { success, error in
            if success
            {
                print("Authorization successful")
            }
            else
            {
                print("Authorization failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func startWorkout() 
    {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .swimming
        configuration.swimmingLocationType = isPool ? .pool : .openWater

        if isPool
        {
            if poolUnit == "meters"
            {
                configuration.lapLength = HKQuantity(unit: HKUnit.meter(), doubleValue: poolLength)
            }
            
            else if poolUnit == "yards"
            {
                configuration.lapLength = HKQuantity(unit: HKUnit.yard(), doubleValue: poolLength)
            }
        }
        
        do 
        {
            workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            workoutBuilder = workoutSession?.associatedWorkoutBuilder()
        }
        catch
        {
            // handle exceptions
            return
        }

        workoutSession?.delegate = self
        workoutBuilder?.delegate = self

        workoutBuilder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore,workoutConfiguration: configuration)

        // start workout session and begin data collection
        let startDate = Date()
        workoutSession?.startActivity(with: startDate)
        workoutBuilder?.beginCollection(withStart: startDate) { (success, error) in
            
        // workout has started
        }
    }
    
    // pause
    func pause()
    {
        workoutSession?.pause()
    }

    // resume
    func resume()
    {
        workoutSession?.resume()
    }

    // pause/resume
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

    func endWorkout() 
    {
        workoutSession?.end()
        showingSummaryView = true
    }


    
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
            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning), HKQuantityType.quantityType(forIdentifier: .distanceCycling):
                let meterUnit = HKUnit.meter()
                self.distance = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
            default:
                return
            }
        }
    }
    
    func resetWorkout() 
    {
        selected = nil
        workoutBuilder = nil
        workout = nil
        workoutSession = nil
        activeEnergy = 0
        averageHeartRate = 0
        heartRate = 0
        distance = 0
    }
 
    
}

// MARK: - HKWorkoutSessionDelegate
extension WatchManager: HKWorkoutSessionDelegate 
{
    func workoutSession(_ workoutSession: HKWorkoutSession,
                        didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState,
                        date: Date) 
    {
        DispatchQueue.main.async 
        {
            self.running = toState == .running
        }

        // wait for the session to transition states before ending the builder.
        if toState == .ended 
        {
            workoutBuilder?.endCollection(withEnd: date) 
            { (success, error) in
                self.workoutBuilder?.finishWorkout 
                { (workout, error) in
                    
                }
            }
        }
    }

    // failed with error
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {

    }
}

// MARK: - HKLiveWorkoutBuilderDelegate
extension WatchManager: HKLiveWorkoutBuilderDelegate 
{
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) 
    {
    }

    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) 
    {
        for type in collectedTypes
        {
            guard let quantityType = type as? HKQuantityType else { return }

            let statistics = workoutBuilder.statistics(for: quantityType)

            // update the published values
            updateForStatistics(statistics)
        }
    }
}

