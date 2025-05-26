// KeyMetricsSection.swift

import SwiftUI

// Key Metrics Section
struct KeyMetricsSection: View
{
    @EnvironmentObject var manager: WatchManager
    
    private var durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    
    var body: some View
    {
        VStack(spacing: 12)
        {
            // Section header
            HStack
            {
                Text("WORKOUT SUMMARY")
                    .font(.system(size: 10, weight: .semibold, design: .rounded))
                    .foregroundColor(.secondary)
                    .tracking(0.5)
                
                Spacer()
            }
            
            // Metrics grid
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12)
            {
                // duration
                MetricCard(
                    title: "Total Time",
                    value: durationFormatter.string(from: manager.workout?.duration ?? 2400) ?? "40:00",
                    unit: "",
                    color: .yellow,
                    icon: "clock.fill"
                )
                
                // distance
                MetricCard(
                    title: "Distance",
                    value: formatDistance(),
                    unit: manager.poolUnit == "meters" ? "m" : "yd",
                    color: .green,
                    icon: "figure.pool.swim"
                )
                
                // energy
                MetricCard(
                    title: "Calories",
                    value: "\(Int(manager.workout?.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? manager.activeEnergy))",
                    unit: "kcal",
                    color: .pink,
                    icon: "flame.fill"
                )
                
                // heart rate
                MetricCard(
                    title: "Avg HR",
                    value: "\(Int(manager.averageHeartRate))",
                    unit: "bpm",
                    color: .red,
                    icon: "heart.fill"
                )
            }
        }
    }
    
    private func formatDistance() -> String
    {
        let distance = manager.workout?.totalDistance?.doubleValue(for: .meter()) ?? manager.distance
        
        if manager.poolUnit == "yards"
        {
            let yards = distance * 1.09361
            return "\(Int(yards))"
        }
        else
        {
            return "\(Int(distance))"
        }
    }
}
