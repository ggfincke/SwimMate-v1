// WatchManager+Delegates.swift

// HealthKit Delegate Extensions

import Foundation
import HealthKit

// MARK: - HKWorkoutSessionDelegate & HKLiveWorkoutBuilderDelegate
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
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState, date: Date) 
    {
        DispatchQueue.main.async 
        {
            self.running = toState == .running
        }
        
        // handle timer based on state
        switch toState 
        {
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
    
    // handle workout end processing
    private func handleWorkoutEnd(date: Date) 
    {
        // show summary immediately
        DispatchQueue.main.async 
        {
            self.showingSummaryView = true
        }
        
        // end collection
        self.workoutBuilder?.endCollection(withEnd: date) 
        { (success, error) in
            if let error = error 
            {
                print("Error ending collection: \(error.localizedDescription)")
                DispatchQueue.main.async 
                {
                    self.workout = nil
                }
                return
            }
            
            // finish workout
            self.workoutBuilder?.finishWorkout 
            { (workout, error) in
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
                }
            }
        }
    }

    /// handle workout session failures
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