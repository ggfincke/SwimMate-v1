// SwimMate/iOSViews/HomeView/Sections/WeeklyStatsSection.swift

import SwiftUI

struct WeeklyStatsSection: View {
    @EnvironmentObject var manager: Manager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("This Week")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
            
            HStack(spacing: 12) {
                HomeStatCard(
                    title: "Workouts",
                    value: "\(weeklyStats.workoutCount)",
                    icon: "figure.pool.swim",
                    color: .blue,
                    trend: weeklyWorkoutTrend
                )
                
                HomeStatCard(
                    title: "Distance",
                    value: weeklyStats.formattedDistance,
                    icon: "ruler",
                    color: .green,
                    trend: weeklyDistanceTrend
                )
                
                HomeStatCard(
                    title: "Time",
                    value: "\(weeklyStats.totalMinutes)m",
                    icon: "clock",
                    color: .orange,
                    trend: weeklyTimeTrend
                )
            }
        }
    }
    
    private var weeklyStats: (workoutCount: Int, totalMinutes: Int, formattedDistance: String) {
        let lastWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())!
        let weeklySwims = manager.swims.filter { $0.date >= lastWeekDate }
        let totalWorkouts = weeklySwims.count
        let totalMinutes = weeklySwims.reduce(0) { $0 + Int($1.duration / 60) }
        let totalDistance = weeklySwims.compactMap { $0.totalDistance }.reduce(0, +)
        
        return (totalWorkouts, totalMinutes, String(format: "%.0f", totalDistance))
    }
    
    private var weeklyWorkoutTrend: StatTrend {
        // Simple trend calculation - in a real app you'd compare to previous week
        let count = weeklyStats.workoutCount
        if count >= 4 { return .up }
        else if count >= 2 { return .neutral }
        else { return .down }
    }
    
    private var weeklyDistanceTrend: StatTrend {
        let distance = weeklyStats.formattedDistance
        if Double(distance) ?? 0 >= 2000 { return .up }
        else if Double(distance) ?? 0 >= 1000 { return .neutral }
        else { return .down }
    }
    
    private var weeklyTimeTrend: StatTrend {
        let minutes = weeklyStats.totalMinutes
        if minutes >= 120 { return .up }
        else if minutes >= 60 { return .neutral }
        else { return .down }
    }
}