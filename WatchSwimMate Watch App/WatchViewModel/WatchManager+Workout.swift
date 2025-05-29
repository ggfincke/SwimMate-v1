// WatchManager+Workout.swift

// Workout Control Extension

import Foundation
import SwiftUI
import HealthKit
import WatchKit

// MARK: - Workout Control
extension WatchManager 
{
    // start new workout session
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
    
    // MARK: - Pause/Resume/Toggle Pause
    
    // pause current workout
    func pause() 
    {
        workoutSession?.pause()
        stopElapsedTimer()
    }

    // resume current workout
    func resume() 
    {
        workoutSession?.resume()
        startElapsedTimer()
    }

    // toggle pause/resume state
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

    // end current workout
    func endWorkout() 
    {
        // stop elapsed timer
        stopElapsedTimer()
        
        // check to ensure active session
        guard let workoutSession = workoutSession, workoutSession.state == .running || workoutSession.state == .paused else 
        {
            print("No active workout session to end")
            showingSummaryView = true
            return
        }
        
        workoutSession.end()
    }
    
    // reset workout with better cleanup
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
    
    // MARK: - Navigation
    
    // reset back to root (for navigation)
    func resetNav() 
    {
        path = NavigationPath()
    }
} 
