// SecondaryMetricsGrid.swift

import SwiftUI

// secondary metrics
struct SecondaryMetricsGrid: View
{
    @EnvironmentObject var manager: WatchManager
    
    var body: some View
    {
        // grid
        VStack(spacing: 8)
        {
            // first row (laps & HR)
            HStack(spacing: 8)
            {
                MetricCard(
                    title: "Laps",
                    value: "\(calculatedLaps)",
                    unit: "laps",
                    color: .green,
                    icon: "arrow.clockwise"
                )
                
                MetricCard(
                    title: "Heart Rate",
                    value: "\(Int(manager.heartRate))",
                    unit: "bpm",
                    color: .red,
                    icon: "heart.fill"
                )
            }
            
            // second row (calories & per 100 pace)
            HStack(spacing: 8)
            {
                MetricCard(
                    title: "Calories",
                    value: "\(Int(manager.activeEnergy))",
                    unit: "kcal",
                    color: .orange,
                    icon: "flame.fill"
                )
                
                MetricCard(
                    title: "Pace",
                    value: currentPace,
                    unit: "/100\(manager.poolUnit == "meters" ? "m" : "yd")",
                    color: .purple,
                    icon: "speedometer"
                )
            }
        }
    }
    
    // computed properties 
    private var calculatedLaps: Int
    {
        let poolLengthInMeters = manager.poolUnit == "meters" ? manager.poolLength : manager.poolLength * 0.9144
        return poolLengthInMeters > 0 ? Int(manager.distance / poolLengthInMeters) : 0
    }
    
    private var currentPace: String
    {
        let elapsedTime = manager.workoutBuilder?.elapsedTime ?? 0
        guard manager.distance > 0 && elapsedTime > 0 else { return "--:--" }
        
        let distanceIn100Units = manager.distance / (manager.poolUnit == "meters" ? 100 : 109.361)
        let paceSeconds = elapsedTime / distanceIn100Units
        
        let minutes = Int(paceSeconds) / 60
        let seconds = Int(paceSeconds) % 60
        
        return String(format: "%d:%02d", minutes, seconds)
    }
}
