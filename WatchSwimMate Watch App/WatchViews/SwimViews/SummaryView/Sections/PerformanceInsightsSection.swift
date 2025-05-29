// PerformanceInsightsSection.swift

import SwiftUI

// Performance Insights
struct PerformanceInsightsSection: View
{
    @Environment(WatchManager.self) private var manager
    
    var body: some View
    {
        VStack(spacing: 12)
        {
            // section header
            Text("INSIGHTS")
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundColor(.secondary)
                .tracking(0.5)
                .frame(maxWidth: .infinity)
            
            // insight row
            VStack(spacing: 8)
            {
                InsightRow(
                    icon: "target",
                    title: "Laps Completed",
                    value: "\(currentLaps)",
                    color: .blue
                )
                
                InsightRow(
                    icon: "speedometer",
                    title: "Average Pace",
                    value: calculateAveragePace(),
                    color: .purple
                )
                
                InsightRow(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Performance",
                    value: getPerformanceRating(),
                    color: .green
                )
            }
        }
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.1))
                .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
        )
    }
    
    // Use fallback values for laps
    private var currentLaps: Int {
        return manager.laps
    }
    
    // Use fallback values for calculations
    private var workoutDuration: TimeInterval {
        return manager.workout?.duration ?? manager.elapsedTime
    }
    
    private var totalDistance: Double {
        return manager.workout?.totalDistance?.doubleValue(for: .meter()) ?? manager.distance
    }
    
    private func calculateAveragePace() -> String
    {
        let duration = workoutDuration
        let distance = totalDistance
        
        guard distance > 0 else { return "--:--" }
        
        let paceSeconds = duration / (distance / (manager.poolUnit == "meters" ? 100 : 109.361))
        let minutes = Int(paceSeconds) / 60
        let seconds = Int(paceSeconds) % 60
        
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private func getPerformanceRating() -> String
    {
        let distance = totalDistance
        let duration = workoutDuration
        
        if distance > 2000 || duration > 3600
        {
            return "Excellent"
        }
        else if distance > 1000 || duration > 1800
        {
            return "Great"
        }
        else if distance > 500 || duration > 900
        {
            return "Good"
        }
        else
        {
            return "Nice Start"
        }
    }
}
