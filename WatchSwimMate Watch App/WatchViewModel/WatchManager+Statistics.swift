// WatchManager+Statistics.swift

// Statistics and Data Processing Extension

import Foundation
import HealthKit

// MARK: - Statistics Processing

extension WatchManager
{
    // update published properties based on HealthKit statistics
    func updateForStatistics(_ statistics: HKStatistics?)
    {
        guard let statistics = statistics
        else
        {
            return
        }

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

    // MARK: - Lap Calcs (probably not needed, WK should handle this)

    // update lap count from completed workout
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

    // calculate laps from current distance
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
