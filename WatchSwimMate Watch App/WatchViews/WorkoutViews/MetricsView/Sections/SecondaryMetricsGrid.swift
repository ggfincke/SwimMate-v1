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
                    value: "\(manager.laps)",
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
    
    // pace calculation using manager's elapsedTime
    private var currentPace: String
    {
        let elapsedTime = manager.elapsedTime
        guard manager.distance > 0 && elapsedTime > 0 else { return "--:--" }
        
        let distanceIn100Units = manager.distance / (manager.poolUnit == "meters" ? 100 : 109.361)
        let paceSeconds = elapsedTime / distanceIn100Units
        
        let minutes = Int(paceSeconds) / 60
        let seconds = Int(paceSeconds) % 60
        
        return String(format: "%d:%02d", minutes, seconds)
    }
}
