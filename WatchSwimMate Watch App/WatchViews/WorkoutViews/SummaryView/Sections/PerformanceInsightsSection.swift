// PerformanceInsightsSection.swift


import SwiftUI

// Performance Insights
struct PerformanceInsightsSection: View
{
    @EnvironmentObject var manager: WatchManager
    
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
                    value: "\(manager.laps)",
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
    
    private func calculateAveragePace() -> String
    {
        let duration = manager.workout?.duration ?? 0
        let distance = manager.workout?.totalDistance?.doubleValue(for: .meter()) ?? 0
        
        guard distance > 0 else { return "--:--" }
        
        let paceSeconds = duration / (distance / (manager.poolUnit == "meters" ? 100 : 109.361))
        let minutes = Int(paceSeconds) / 60
        let seconds = Int(paceSeconds) % 60
        
        return String(format: "%d:%02d", minutes, seconds)
    }
    
    private func getPerformanceRating() -> String
    {
        let distance = manager.workout?.totalDistance?.doubleValue(for: .meter()) ?? 0
        let duration = manager.workout?.duration ?? 0
        
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
